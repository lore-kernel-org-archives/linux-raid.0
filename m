From: Karl Voit <news@Karl-Voit.at>
Subject: Re: only 4 spares and no access to my data
Date: Mon, 10 Jul 2006 12:36:52 +0000 (UTC)
Message-ID: <loom.20060710T142912-798@post.gmane.org>
References: <loom.20060709T205013-455@post.gmane.org>  <62b0912f0607091223y3d0a1ab5xbc5fb01ce2a74f9e@mail.gmail.com>  <loom.20060710T095111-275@post.gmane.org>  <44B213CD.5010907@idgmail.se>  <loom.20060710T112944-980@post.gmane.org>  <62b0912f0607100416v51309355v693b5c83ee51fdbc@mail.gmail.com>  <loom.20060710T132722-427@post.gmane.org> <62b0912f0607100507s21544d12xec9a8bf117b6edc2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich <molle.bestefich <at> gmail.com> writes:

> Karl Voit wrote:
> > OK, I upgraded my kernel and mdadm:
> >
> > "uname -a":
> > Linux ned 2.6.13-grml #1 Tue Oct 4 18:24:46 CEST 2005 i686 GNU/Linux
> 
> That release is 10 months old.
> Newest release is 2.6.17.

Sorry, my fault. "dpkg -i <kernel> does not boot the new one *g*

root@ned ~ # uname -a
Linux ned 2.6.17-grml #1 PREEMPT Tue Jun 20 19:39:46\
 CEST 2006 i686 GNU/Linux
root@ned ~ #

Now that should be working.

> > "dpkg --list mdadm" --> "2.4.1-6"
> 
> Newest release is 2.5.2.
> 2.4.1 is 3 months old.

Debian seems to be old. I downloaded the current version and replaced the binary:

root@ned ~ # wget http://www.cse.unsw.edu.au/~neilb/source/\
mdadm/mdadm-2.5.2.tgz
[...]
root@ned ~/tmp2del/mdadm-2.5.2 # make
[...]
root@ned ~/tmp2del/mdadm-2.5.2 # mv /sbin/mdadm /sbin/mdadm_v2.4.1
root@ned ~/tmp2del/mdadm-2.5.2 # cp ./mdadm /sbin/mdadm
root@ned ~/tmp2del/mdadm-2.5.2 #

> > Is it true, that I should try the following lines?
> > 
> > mdadm --stop /dev/md0
> > mdadm --zero-superblock /dev/sda
> > mdadm --zero-superblock /dev/sdb
> > mdadm --zero-superblock /dev/sdc
> > mdadm --zero-superblock /dev/sdd
> > mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 --force
> > (check, if it worked - probably not - and if not, try the following line)
> > mdadm --create -n 4 -l 5 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
"echo repair > /sys/block/md0/md/sync_action"

Before that, I'd like to check again now with the latest kernel and the latest
mdadm:

root@ned ~ # mdadm --stop /dev/md0
mdadm: stopped /dev/md0
root@ned ~ # mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1\
 /dev/sdd1
mdadm: No suitable drives found for /dev/md0
root@ned ~ # mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1\
 /dev/sdd1 --run
mdadm: No suitable drives found for /dev/md0
root@ned ~ # mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1\
 /dev/sdd1 --force
mdadm: No suitable drives found for /dev/md0
root@ned ~ # mdadm --zero-superblock /dev/sda
mdadm: Unrecognised md component device - /dev/sda
root@ned ~ #

OK, those are other (newer) messages. Do they change anything or should I try
the commands above now?

