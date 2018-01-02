From: RQM <rqm@protonmail.com>
Subject: Re: Troubleshooting "Buffer I/O error" on reading md device
Date: Tue, 02 Jan 2018 05:40:12 -0500
Message-ID: <XUhdgUHMsoit8A9Qw13P1q6NQUxsgqNZCsgx6us_8kHu50GPOvQoOBwP-ryQz54CBi6Js7J2xwC8jgKQ5geXi5AdVLT27YlucQ4tWH-8xlM=@protonmail.com>
References: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com>
 <87373og9z9.fsf@notabene.neil.brown.name>
Reply-To: RQM <rqm@protonmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87373og9z9.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid\\@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

thanks for the quick and helpful responses! Answers inline:

=E2=80=8B> Step one is confirm that it is easy to reproduce.
> Does
> dd if=3D/dev/md0 bs=3D4K skip=3D1598030208 count=3D1 of=3D/dev/null
>
> trigger the message reliably?
> To check that "4K" is the correct blocksize, run
> blockdev --getbsz /dev/md0
>
> use whatever number if gives as 'bs=3D'.


blockdev does indeed report a blocksize of 4096, and the dd line does relia=
bly trigger
dd: error reading '/dev/md0': Input/output error
and the same line in dmesg as before.

> Once you can reproduce with minimal IO, do
> echo file:raid5.c +p > /sys/kernel/debug/dynamic_debug/control
>repeat experiment
>
>echo file:raid5.c -p > /sys/kernel/debug/dynamic_debug/control
>
> and report the messages that appear in 'dmesg'.

I had to replace the colon with a space in those two lines (otherwise I wou=
ld get "bash: echo: write error: Invalid argument"), but after that, this i=
s what I got in dmesg:
https://paste.ubuntu.com/26305369/

> Also report "mdadm -E" of each member device, and kernel version (though
> I see that is in the serverfault report :  4.9.30-2+deb9u5).

mdadm -E says: https://paste.ubuntu.com/26305379/
The kernel has been updated between the serverfault post and my first mail =
to this list to 4.9.65-3+deb9u1. No changes since.

>
> Then run
> blktrace /dev/md0 /dev/sd[acdef]
> in one window while reproducing the error again in another window.
> Then interrupt the blktrace.  This will produce several blocktrace*
> files.  create a tar.gz of these and put them somewhere that I can get
> them - hopefully they won't be too big.

I had to adjust the last blktrace argument to /dev/sd[b-f] since after the =
last reboot the names of the drives have changed, but here's the output:
https://filebin.ca/3mnjUz1OIXqm/blktrace-out.tar.gz
I also included the blktrace terminal output in there.

Thank you so much for the effort! Please let me know if you need anything.
