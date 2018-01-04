From: RQM <rqm@protonmail.com>
Subject: Re: Troubleshooting "Buffer I/O error" on reading md device
Date: Thu, 04 Jan 2018 09:45:08 -0500
Message-ID: <f92IIdV_PSMtdilVnQDOaLSxzvpTkAa6D0nxpuplzzdnaP9km9JveoXfzOlygcXD5Y_HpN49Fh0x4nOZFhXPfv5VyPrT6CgFO-nsULq6wn0=@protonmail.com>
References: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com>
 <87373og9z9.fsf@notabene.neil.brown.name>
 <XUhdgUHMsoit8A9Qw13P1q6NQUxsgqNZCsgx6us_8kHu50GPOvQoOBwP-ryQz54CBi6Js7J2xwC8jgKQ5geXi5AdVLT27YlucQ4tWH-8xlM=@protonmail.com>
 <87r2r8dk80.fsf@notabene.neil.brown.name>
Reply-To: RQM <rqm@protonmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r2r8dk80.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid\\\\\\@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

> I needed "mdadm -E" the components of the array, so the partitions
> rather than the whole devices. e.g. /dev/sdb1, not /dev/sdb.

Sorry, that should have occurred to me. Here's the output:
https://paste.ubuntu.com/26319689/

Indeed, bad blocks are present on two devices.

> You can remove the bad block by over-writing it.
> dd if=3D/dev/zero of=3D/dev/md0 bs=3D4K seek=3D1598030208 count=3D1
> though that might corrupt some file containing the block.

I have tried that just now, but before running mdadm -E above. dd appears t=
o succeed when writing to the bad block, but after that, reading that block=
 with dd fails again:
"dd: error reading '/dev/md0': Input/output error"

In dmesg, the following errors appear:
[220444.068715] VFS: Dirty inode writeback failed for block device md0 (err=
=3D-5).
[220445.850229] Buffer I/O error on dev md0, logical block 1598030208, asyn=
c page read

I have repeated the dd write-then-read experiment, with identical results.

The filesystem is indeed ext4, but it's not of tremendous importance to me =
that all data is recovered, as the array contains backup data only. However=
, I would like to get the backup system back into operation, so I'd be very=
 grateful for further hints how to get the array into a usable state.

Thank you so much for your help so far!
