From: Karl Voit <news@Karl-Voit.at>
Subject: Re: only 4 spares and no access to my data
Date: Mon, 10 Jul 2006 11:42:48 +0000 (UTC)
Message-ID: <loom.20060710T132722-427@post.gmane.org>
References: <loom.20060709T205013-455@post.gmane.org>  <62b0912f0607091223y3d0a1ab5xbc5fb01ce2a74f9e@mail.gmail.com>  <loom.20060710T095111-275@post.gmane.org>  <44B213CD.5010907@idgmail.se>  <loom.20060710T112944-980@post.gmane.org> <62b0912f0607100416v51309355v693b5c83ee51fdbc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich <molle.bestefich <at> gmail.com> writes:

> Karl Voit wrote:
> 
> > root <at> ned ~ # mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1\
> >  /dev/sdc1 /dev/sdd1
> > mdadm: cannot open device /dev/sda1: Device or resource busy
> > mdadm: /dev/sda1 has no superblock - assembly aborted
> 
> Odd message.  Does "lsof | grep sda" show anything using /dev/sda(1)?

Nope.

> > The problem seems to be the superblocks.
> 
> Which ones, those on sd[abcd]1 ?

I guessed so.

> You've probably destroyed them by syncing the array consisting of sd[abcd].

Sh..

> > Can I repair them?
> 
> No, but you can recreate them without touching your data.
> I think the suggestion from Andreas Gredler sounds sane.
> 
> I'm unsure if hot-adding a device will recreate a superblock on it.
> Therefore I'd probably run --create on all four devices and use sysfs
> to force a repair, instead of (as Andreas suggests) creating the array
> with one 'missing' device.
>
> Do remember to zero the superblocks on sd[abcd] first, to prevent mishaps...

Just to make sure, that I do not make any dumb commands. Is it true, that I
should try the following lines?

mdadm --stop /dev/md0
mdadm --zero-superblock /dev/sda
mdadm --zero-superblock /dev/sdb
mdadm --zero-superblock /dev/sdc
mdadm --zero-superblock /dev/sdd
mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 --force
(check, if it worked - probably not - and if not, try the following line)
mdadm --create -n 4 -l 5 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
sysfs: Sorry, what should I do with sysfs. I do not know this tool yet.

root@ned /sys/block/md0 # l
total 0
-r--r--r--  1 root root 4096 2006-07-10 13:38 dev
-r--r--r--  1 root root 4096 2006-07-10 13:38 range
-r--r--r--  1 root root 4096 2006-07-10 13:38 removable
-r--r--r--  1 root root 4096 2006-07-10 13:38 size
-r--r--r--  1 root root 4096 2006-07-10 13:38 stat
root@ned /sys/block/md0 #

Did you mean something like "echo repair > /sys/block/md0/md/sync_action" which
I googled?

