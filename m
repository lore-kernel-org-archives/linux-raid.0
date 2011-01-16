From: Bart Kus <me@bartk.us>
Subject: Re: (help!) MD RAID6 won't --re-add devices? [SOLVED!]
Date: Sun, 16 Jan 2011 13:19:26 -0800
Message-ID: <4D3360DE.3060603@bartk.us>
References: <4D2EF83D.6080203@bartk.us> <4D31DE07.1000507@bartk.us> <4D31FAA2.2080202@bartk.us> <AANLkTikwEG30jkZuPT+WAEc8=LLPi6c1-Rtv91uH3v-z@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikwEG30jkZuPT+WAEc8=LLPi6c1-Rtv91uH3v-z@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the COW idea, had not thought of that.  Luckily, I had 10=20
spare 2TB drives racked and powered, so I just backed up all the drives=
=20
using dd.

Turns out a good way to test if you've got the right combination of=20
drives is to do echo check > sync_action, wait 5 seconds, and then chec=
k=20
mismatch_cnt.  If you've found the right combination, the count will be=
=20
low or zero.

Another important thing to note is that "Version" reported by mdadm=20
--detail /dev/mdX is NOT always the same as version reported by mdadm=20
--examine /dev/sdX.  I guess array header and drive header track=20
different version numbers.  My array header was reporting 1.02 while al=
l=20
the drives were showing 1.2.

And a key thing to know is that the default Data Offset has CHANGED ove=
r=20
the years.  My original drives reported an offset of 272 sectors, and I=
=20
believe the array was made with mdadm-2.6.6.  Using mdadm-3.1.4 to=20
create a new array put the offset at 2048 sectors, a huge change!  Also=
,=20
it seems when mdadm-3.1.4 added the old drives (272 offset at the time)=
=20
into the array that was missing 5/10 drives and marked them as spares,=20
the spare-marking process changed the offset to 384 sectors.  The array=
=20
when created with mdadm-3.1.4 had actually reduced the Used Dev Size a=20
bit from what the original array had, so none of the permutations worke=
d=20
since everything was misaligned.  I had to downgrade to mdadm-3.0 which=
=20
created the array with the proper Dev Size and the proper Data Offset o=
f=20
272 sectors for the RAID6 blocks to line up.

Is there documentation somewhere about all these default changes?  I sa=
w=20
no options to specify the data offset either.  That would be a good=20
option to add.

But best to add would be functional --re-add capability!  Reporting the=
=20
array is "busy" when I'm trying to return its 5 missing drives isn't=20
useful.  It should re-add its old drives as expected and flush any=20
pending buffers.

Below is the (very hacky) code I used to test all the permutations of=20
the 5 drives whose sequence was lost by being marked as spares. =20
Hopefully it doesn't have to help anyone in the future.

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>

char *permutation[] =3D { "nopqr", "noprq", "noqpr", "noqrp", "norpq",=20
"norqp", "npoqr", "nporq", "npqor", "npqro", "nproq", "nprqo", "nqopr",=
=20
"nqorp", "nqpor", "nqpro", "nqrop", "nqrpo", "nropq", "nroqp", "nrpoq",=
=20
"nrpqo", "nrqop", "nrqpo", "onpqr", "onprq", "onqpr", "onqrp", "onrpq",=
=20
"onrqp", "opnqr", "opnrq", "opqnr", "opqrn", "oprnq", "oprqn", "oqnpr",=
=20
"oqnrp", "oqpnr", "oqprn", "oqrnp", "oqrpn", "ornpq", "ornqp", "orpnq",=
=20
"orpqn", "orqnp", "orqpn", "pnoqr", "pnorq", "pnqor", "pnqro", "pnroq",=
=20
"pnrqo", "ponqr", "ponrq", "poqnr", "poqrn", "pornq", "porqn", "pqnor",=
=20
"pqnro", "pqonr", "pqorn", "pqrno", "pqron", "prnoq", "prnqo", "pronq",=
=20
"proqn", "prqno", "prqon", "qnopr", "qnorp", "qnpor", "qnpro", "qnrop",=
=20
"qnrpo", "qonpr", "qonrp", "qopnr", "qoprn", "qornp", "qorpn", "qpnor",=
=20
"qpnro", "qponr", "qporn", "qprno", "qpron", "qrnop", "qrnpo", "qronp",=
=20
"qropn", "qrpno", "qrpon", "rnopq", "rnoqp", "rnpoq", "rnpqo", "rnqop",=
=20
"rnqpo", "ronpq", "ronqp", "ropnq", "ropqn", "roqnp", "roqpn", "rpnoq",=
=20
"rpnqo", "rponq", "rpoqn", "rpqno", "rpqon", "rqnop", "rqnpo", "rqonp",=
=20
"rqopn", "rqpno", "rqpon" };

int main()
{
         int i, mismatches, status;
         FILE *handle;
         char command[1024];

         for (i =3D 0; i < sizeof permutation / sizeof (char *); i++) {
                 mismatches =3D -1; // Safety
                 sprintf(command, "/sbin/mdadm --create /dev/md4=20
--assume-clean -R -e 1.2 -l 6 -n 10 -c 64 /dev/sda1 /dev/sd%c1 /dev/sdc=
1=20
/dev/sdd1 /dev/sd%c1 /dev/sdm1 /dev/sd%c1 /dev/sd%c1 /dev/sd%c1 /dev/sd=
b1",
                         permutation[i][0], permutation[i][1],=20
permutation[i][2], permutation[i][3], permutation[i][4]);
                 printf("Running: %s\n", command);
                 status =3D system(command);
                 if (WEXITSTATUS(status) !=3D 0) {
                         printf("Command error\n");
                         return;
                 }
                 sleep(1);
                 handle =3D fopen("/sys/block/md4/md/sync_action", "w")=
;
                 fprintf(handle, "check\n");
                 fclose(handle);
                 sleep(5);
                 handle =3D fopen("/sys/block/md4/md/mismatch_cnt", "r"=
);
                 fscanf(handle, "%d", &mismatches);
                 fclose(handle);
                 printf("Permutation %s =3D %d mismatches\n",=20
permutation[i], mismatches);
                 fflush(stdout);
                 sprintf(command, "/sbin/mdadm --stop /dev/md4");
                 printf("Running: %s\n", command);
                 status =3D system(command);
                 if (WEXITSTATUS(status) !=3D 0) {
                         printf("Command error\n");
                         return;
                 }
                 sleep(1);

         }
}

The permutations I got from an online permutation generator:

http://users.telenet.be/vdmoortel/dirk/Maths/permutations.html

Didn't feel like writing that part of the algorithm.

--Bart


On 1/15/2011 4:05 PM, J=E9r=F4me Poulin wrote:
> On Sat, Jan 15, 2011 at 2:50 PM, Bart Kus<me@bartk.us>  wrote:
>> Some research has revealed a frightening solution:
>>
>> http://forums.gentoo.org/viewtopic-t-716757-start-0.html
>>
>> That thread calls upon mdadm --create with the --assume-clean flag. =
 It also
>> seems to re-enforce my suspicions that MD has lost my device order n=
umbers
>> when it marked the drives as spare (thanks, MD!  Remind me to get yo=
u a nice
>> christmas present next year.).  I know the order of 5 out of 10 devi=
ces, so
>> that leaves 120 permutations to try.  I've whipped up some software =
to
>> generate all the permuted mdadm --create commands.
>>
>> The question now: how do I test if I've got the right combination?  =
Can I dd
>> a meg off the assembled array and check for errors somewhere?
> I guess running a read-only fsck is the best way to proove it working=
=2E
>
>> The other question: Is testing incorrect combinations destructive to=
 any
>> data on the drives?  Like, would RAID6 kick in and start "fixing" pa=
rity
>> errors, even if I'm just reading?
>>
> If you don't want to risk your data, you could create a cowloop of
> each device before writing to it, or dm snapshot using dmsetup.
>
> I made a script for dmsetup snapshot on the side when I really needed
> it because cowloop wouldn't compile. Here it is, it should help you
> understand how it works!
>
>
> RODATA=3D$1
> shift
> COWFILE=3D$1
> shift
> FSIZE=3D$1
> shift
> PREFIX=3D$1
> shift
>
> if [ -z $RODATA ] || [ -z $COWFILE ] || [ -z $FSIZE ] || [ ! -z $5 ]
> then
> 	echo "Usage: $0 [read only device] [loop file] [size of loop in MB] =
{prefix}"
> 	echo "Read only device won't ever get a write."
> 	echo "Loop file can be a file or device where writes will be directe=
d too."
> 	echo "Size is specified in MB, you will be able to write that much
> change to the device created."
> 	echo "Prefix will get prepended to all devices created by this scrip=
t
> in /dev/mapper"
> 	exit -1
> fi
>
> MRODATA=3D$PREFIX${RODATA#/dev/}data
> COWFILELOOP=3D$(losetup -f)
> MCOWFILE=3D$PREFIX${RODATA#/dev/}cow
> MSNAPSHOT=3D$PREFIX${RODATA#/dev/}snap
>
>
> dd if=3D/dev/zero of=3D$COWFILE bs=3D1M seek=3D$FSIZE count=3D1
> losetup $COWFILELOOP $COWFILE
> echo "0 $(blockdev --getsz $RODATA) linear $RODATA 0" | dmsetup creat=
e $MRODATA
> echo "0 $(blockdev --getsz $COWFILELOOP) linear $COWFILELOOP 0" |
> dmsetup create $MCOWFILE
> echo "0 $(blockdev --getsz /dev/mapper/$MRODATA) snapshot
> /dev/mapper/$MRODATA /dev/mapper/$MCOWFILE p 64" | dmsetup create
> $MSNAPSHOT
>
> echo "You can now use $MSNAPSHOT for your tests, up to ${FSIZE}MB."
> exit 0
>
>
>> --Bart
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
