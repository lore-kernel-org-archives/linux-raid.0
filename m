From: =?UTF-8?Q?Lucian_=C8=98andor?= <lucisandor@gmail.com>
Subject: Recovering the order of drives after RAID5 mix-up [was: RAID5 demise
	or coma? after re-creating with a spare]
Date: Thu, 10 Dec 2009 20:54:42 -0500
Message-ID: <c775b4470912101754o416c98f8v6a57066f1dd46826@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I am partly on the solution and I think it will be useful to post it
here. However, at the end of this very long post, I have a mdadm
question and I would be very grateful to learn the answer to that.

To figure the order of drives in a messed RAID5, I employed a neat
trick that I was told on ext3-users list.
Right at the beginning of the ext2 partition, there is a handy ordered
table, which can be displayed with
od -Ax -tx4 -j 4096 -v /dev/sdg5 -w 32 -v | more
The output is something like:
001000 20000401 20000402 20000403 20fd0001 00000001 00000000 00000000 0=
0000000
001020 20008401 20008402 20008403 20820000 00000000 00000000 00000000 0=
0000000
001040 20010000 20010001 20010002 200a0002 00000000 00000000 00000000 0=
0000000

One follows the second number in each column for each of the component
devices. As you can see, this goes up in arithmetic progression.
Scrolling down, one can find series breaks' locations, which mark the
chunk limit.
~# od -Ax -tx4 -j 131008 -v /dev/sdg5 -w 32 -v -N 128
01ffc0 27bf0000 27bf0001 27bf0002 20060002 00040000 00000000 00000000 0=
0000000
01ffe0 27bf8000 27bf8001 27bf8002 202a2016 00040004 00000000 00000000 0=
0000000
020000 00008120 00018120 00028120 00038120 00048120 000c8120 000d8120 0=
0188120
020020 00288120 003e8120 00798120 00ab8120 01388120 016c8120 04458120 0=
4b08120
So my first chunk ends at position 2000H, i.e., 128Kb.

Next step is to look in each drive for the second column. For your
convenience, the drives have been ordered so that you can see the
progression of the numbers in the second column.
~ # od -Ax -tx4 -j 4096 -v /dev/sdj6 -w 32 -v -N 64
001000 00000401 00000402 00000403 1f230001 00040001 00000000 00000000 0=
0000000
001020 00008401 00008402 00008403 1f6b0000 00040000 00000000 00000000 0=
0000000
~ # od -Ax -tx4 -j 4096 -v /dev/sdh6 -w 32 -v -N 64
001000 08000000 08000001 08000002 20000000 00040000 00000000 00000000 0=
0000000
001020 08008000 08008001 08008002 20000000 00040000 00000000 00000000 0=
0000000
~ # od -Ax -tx4 -j 4096 -v /dev/sdk6 -w 32 -v -N 64
001000 10000000 10000001 10000002 1fde0000 00040000 00000000 00000000 0=
0000000
001020 10008000 10008001 10008002 1fe90000 00040000 00000000 00000000 0=
0000000
~ # od -Ax -tx4 -j 4096 -v /dev/sdf6 -w 32 -v -N 64
001000 18000000 18000001 18000002 20000000 00040000 00000000 00000000 0=
0000000
001020 18008000 18008001 18008002 20000000 00040000 00000000 00000000 0=
0000000
~ # od -Ax -tx4 -j 4096 -v /dev/sdg5 -w 32 -v -N 64
001000 20000401 20000402 20000403 20fd0001 00000001 00000000 00000000 0=
0000000
001020 20008401 20008402 20008403 20820000 00000000 00000000 00000000 0=
0000000
~ # od -Ax -tx4 -j 4096 -v /dev/sdi6 -w 32 -v -N 64
001000 20000000 20000001 20000002 20000000 00000000 00000000 00000000 0=
0000000
001020 20008000 20008001 20008002 20000000 00000000 00000000 00000000 0=
0000000

Let's call the drives in this order A B C D E F. I don't know which is
the parity drive, but I am sure it's either E or F, because there
shouldn't be any duplicate in the second column. So the order is A B C
D E/F.
In the second chunk, I found an apparent duplicate again in the pair
E-F. The order is A B C D E/F.
In the third chunk, I ran into a smaller table. The order is A B C F D/=
E.
=46ourth chunk duplicate is A/C B D F E.
=46ifth chunk order A C D F B/E.
Sixth chunk order is A/B C D F E.
Seventh chunk order is A B C E D/F.  The second table finishes here.

I also found an older email saying that the structure was "Delta
Devices : 1, (5->6)" I searched the net, but I can't make sense of it.

QUESTION: How should I re-create the array? What is the order of the
devices in the mdadm -C that I should issue?

Thanks,
Lucian Sandor



2009/12/6 Lucian =C8=98andor <lucisandor@gmail.com>:
> 2009/12/4 Neil Brown <neilb@suse.de>:
>> On Fri, 4 Dec 2009 14:46:39 -0500
>> Lucian =C8=98andor <lucisandor@gmail.com> wrote:
>>
>>> Hi all,
>>> There is a problem with my Linux installation, and the drives get
>>> renamed and reordered all the time. Now, it just happened that the =
two
>>> degraded RAID5s won't return to life. The system would not boot, so=
 I
>>> panicked and deleted: fstab, mdadm.conf, and some of the superblock=
s.
>>> Now Linux boots, but RAIDs are, of course, dead. I tried to re-crea=
te
>>> the arrays, but I cannot recall the correct order and my attempts
>>> failed. I believe that the partitions are OK, because I don't recal=
l
>>> re-creating without "missing", but surely the superblocks are damag=
ed
>>> and certanily most of them are zero now.
>>> Is there a short way to recover the degraded RAIDs without knowing =
the
>>> order of drives? I have 6 drives in one (including "missing"), that
>>> gives 720 permutations. Also, clearing the superblocks is recoverab=
le,
>>> isn't it?
>>
>> Yes, 720 permutations. =C2=A0But you can probably write a script
>> to generate them all ... how good are your programming skills?
>> Use "--assume-clean" to create the array so that it doesn't
>> auto-resync. =C2=A0Then "fsck -n" to see of the data is even close
>> to correct.
>>
>> And why would you think that erasing the superblocks is a recoverabl=
e
>> operation? =C2=A0It isn't.
>>
>> NeilBrown
>>
>
> Thanks for your reply.
>
> I didn't realize why googling "recovery after zero superblock" was so
> inefficient. Sounds very very troubling.
>
> I will script it then for the one array with non-zeroes superblocks.
> One issue is that I didn't use -assume-clean in my early attempts of
> re-creation. I know this overwrites the superblock. Didn't it make my
> superblocks as useless as if I zeroed them?
>
> Thanks,
> Lucian Sandor
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
