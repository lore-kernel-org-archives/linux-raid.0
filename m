From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: (help!) MD RAID6 won't --re-add devices?
Date: Sat, 15 Jan 2011 19:05:16 -0500
Message-ID: <AANLkTikwEG30jkZuPT+WAEc8=LLPi6c1-Rtv91uH3v-z@mail.gmail.com>
References: <4D2EF83D.6080203@bartk.us> <4D31DE07.1000507@bartk.us> <4D31FAA2.2080202@bartk.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D31FAA2.2080202@bartk.us>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Kus <me@bartk.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 15, 2011 at 2:50 PM, Bart Kus <me@bartk.us> wrote:
> Some research has revealed a frightening solution:
>
> http://forums.gentoo.org/viewtopic-t-716757-start-0.html
>
> That thread calls upon mdadm --create with the --assume-clean flag. =A0=
It also
> seems to re-enforce my suspicions that MD has lost my device order nu=
mbers
> when it marked the drives as spare (thanks, MD! =A0Remind me to get y=
ou a nice
> christmas present next year.). =A0I know the order of 5 out of 10 dev=
ices, so
> that leaves 120 permutations to try. =A0I've whipped up some software=
 to
> generate all the permuted mdadm --create commands.
>
> The question now: how do I test if I've got the right combination? =A0=
Can I dd
> a meg off the assembled array and check for errors somewhere?

I guess running a read-only fsck is the best way to proove it working.

>
> The other question: Is testing incorrect combinations destructive to =
any
> data on the drives? =A0Like, would RAID6 kick in and start "fixing" p=
arity
> errors, even if I'm just reading?
>

If you don't want to risk your data, you could create a cowloop of
each device before writing to it, or dm snapshot using dmsetup.

I made a script for dmsetup snapshot on the side when I really needed
it because cowloop wouldn't compile. Here it is, it should help you
understand how it works!


RODATA=3D$1
shift
COWFILE=3D$1
shift
=46SIZE=3D$1
shift
PREFIX=3D$1
shift

if [ -z $RODATA ] || [ -z $COWFILE ] || [ -z $FSIZE ] || [ ! -z $5 ]
then
	echo "Usage: $0 [read only device] [loop file] [size of loop in MB] {p=
refix}"
	echo "Read only device won't ever get a write."
	echo "Loop file can be a file or device where writes will be directed =
too."
	echo "Size is specified in MB, you will be able to write that much
change to the device created."
	echo "Prefix will get prepended to all devices created by this script
in /dev/mapper"
	exit -1
fi

MRODATA=3D$PREFIX${RODATA#/dev/}data
COWFILELOOP=3D$(losetup -f)
MCOWFILE=3D$PREFIX${RODATA#/dev/}cow
MSNAPSHOT=3D$PREFIX${RODATA#/dev/}snap


dd if=3D/dev/zero of=3D$COWFILE bs=3D1M seek=3D$FSIZE count=3D1
losetup $COWFILELOOP $COWFILE
echo "0 $(blockdev --getsz $RODATA) linear $RODATA 0" | dmsetup create =
$MRODATA
echo "0 $(blockdev --getsz $COWFILELOOP) linear $COWFILELOOP 0" |
dmsetup create $MCOWFILE
echo "0 $(blockdev --getsz /dev/mapper/$MRODATA) snapshot
/dev/mapper/$MRODATA /dev/mapper/$MCOWFILE p 64" | dmsetup create
$MSNAPSHOT

echo "You can now use $MSNAPSHOT for your tests, up to ${FSIZE}MB."
exit 0


> --Bart
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
