From: RQM <rqm@protonmail.com>
Subject: Re: Troubleshooting "Buffer I/O error" on reading md device
Date: Fri, 05 Jan 2018 07:55:14 -0500
Message-ID: <M1riU2VdgyXq3ozdVUjaSDLksJfD8z3lZEy7D8JWIMb9mJk8A6CFz7Q1_tA_wFkVGC1lyTI7yTMb8DXv7T6JDGvKzUFGHbY7mZ9vLNqlowo=@protonmail.com>
References: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com>
 <87373og9z9.fsf@notabene.neil.brown.name>
 <XUhdgUHMsoit8A9Qw13P1q6NQUxsgqNZCsgx6us_8kHu50GPOvQoOBwP-ryQz54CBi6Js7J2xwC8jgKQ5geXi5AdVLT27YlucQ4tWH-8xlM=@protonmail.com>
 <87r2r8dk80.fsf@notabene.neil.brown.name>
 <f92IIdV_PSMtdilVnQDOaLSxzvpTkAa6D0nxpuplzzdnaP9km9JveoXfzOlygcXD5Y_HpN49Fh0x4nOZFhXPfv5VyPrT6CgFO-nsULq6wn0=@protonmail.com>
 <871sj5dsiv.fsf@notabene.neil.brown.name>
Reply-To: RQM <rqm@protonmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871sj5dsiv.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid\\\\\\\\\\\\\\@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

here's the metadata dump:
https://filebin.ca/3n9OgaeSlV6x/dump.tgz
=E2=80=8B
When I try assembling with no-bbl, this is what I get:

# mdadm -A /dev/md0 --update=3Dno-bbl /dev/sd[bcdef]3
mdadm: Cannot remove active bbl from /dev/sdc3
mdadm: Cannot remove active bbl from /dev/sde3
mdadm: /dev/md0 has been started with 5 drives.

The array does start up, but the behavior regarding dd reads and writes rem=
ains as it was before:
Failure to read with the corresponding error messages in dmesg and on stdou=
t/stderr,
failure to write, but only indicated in dmesg.

By the way, I have run smart long tests a day or two ago, and it reportedly=
 completed without errors on all involved disks.

Thank you again so much for your help!
=E2=80=8B

>-------- Original Message --------
>Subject: Re: Troubleshooting "Buffer I/O error" on reading md device
>Local Time: January 5, 2018 2:05 AM
>UTC Time: January 5, 2018 1:05 AM
>From: neilb@suse.com
>To: RQM <rqm@protonmail.com>
>linux-raid\\\\\\\@vger.kernel.org <linux-raid@vger.kernel.org>
>
>On Thu, Jan 04 2018, RQM wrote:
>
>>Hello,
>>>I needed "mdadm -E" the components of the array, so the partitions
>>> rather than the whole devices. e.g. /dev/sdb1, not /dev/sdb.
>>>Sorry, that should have occurred to me. Here's the output:
>>https://paste.ubuntu.com/26319689/
>>Indeed, bad blocks are present on two devices.
>>>You can remove the bad block by over-writing it.
>>> dd if=3D/dev/zero of=3D/dev/md0 bs=3D4K seek=3D1598030208 count=3D1
>>> though that might corrupt some file containing the block.
>>>I have tried that just now, but before running mdadm -E above. dd appear=
s to succeed when writing to the bad block, but after that, reading that bl=
ock with dd fails again:
>> "dd: error reading '/dev/md0': Input/output error"
>>In dmesg, the following errors appear:
>> [220444.068715] VFS: Dirty inode writeback failed for block device md0 (=
err=3D-5).
>> [220445.850229] Buffer I/O error on dev md0, logical block 1598030208, a=
sync page read
>>I have repeated the dd write-then-read experiment, with identical results=
.
>>The filesystem is indeed ext4, but it's not of tremendous importance to m=
e that all data is recovered, as the array contains backup data only. Howev=
er, I would like to get the backup system back into operation, so I'd be ve=
ry grateful for further hints how to get the array into a usable state.
>>
> The easiest approach is to remove the bad block log.
> Stop array, and then assemble with --update=3Dno-bbl.
> e.g
> mdadm -S /dev/md0
> mdadm -A /dev/md0 --update=3Dno-bbl /dev/sd[bcdef]3
>
> Before you do that though, please take a dump of the metadata and send
> it to me, in case I get motivated to figure out why writing didn't work.
>
> mkdir /tmp/dump
> mdadm --dump /tmp/dump /dev/sd[bcdef]3
> tar czSf /tmp/dump.tgz /tmp/dump
>
> The files in /tmp are sparse images of the hard drives with only
> the metadata present.  The 'S' flag to tar should cause it to notice
> this and create a tiny tgz file.
> Then send me /tmp/dump.tgz.
>
> Thanks,
> NeilBrown
>
>
>>Thank you so much for your help so far!
>>
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
