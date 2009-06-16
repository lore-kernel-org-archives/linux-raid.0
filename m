From: <linux-raid.vger.kernel.org@atu.cjb.net>
Subject: =?UTF-8?B?UmU6IFJBSUQtNiBtZGFkbSBkaXNrcyBvdXQgb2Ygc3luYyBpc3N1ZSAobW9yZSBxdWVzdGlvbnMp?=
Date: Tue, 16 Jun 2009 02:13:18 -0600
Message-ID: <200906160813.n5G8DNgw019811@cjb.net>
References: <18999.13573.674937.482254@notabene.brown>
Reply-To: <linux-raid.vger.kernel.org@atu.cjb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18999.13573.674937.482254@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> No.  They won't become spares unless you tell them to, but you
> cannot force them to be 100% read-only.

This would be a very nice feature to have, rebuilding disks while
guaranteeing that the data on the "good" disks is not modified in
any way.

> > [ 4628.7] mdadm[19700]: segfault at 0 ip 000000000041617f sp 00007fff87776290 error 4 in mdadm[400000+2a000]
> > 
> > mdadm - v2.6.7.1 - 15th October 2008
> 
> It would be great if you could get a stack trace of this.  Is the
> an "mdadm --monitor" that is dying, or mdadm running for some other
> reason?

It was not me running the command, so presumably it was the
/etc/init.d/mdadm service running.  I looked at that file, and near
as I can tell (it's fairly confusing and calls many other files) it
runs one of these three commands:

# mdadm --monitor
# mdadm --syslog
# mdadm --monitor --syslog

Is there some way I could modify this script so it would capture the
debugging output when it seg faults?  Or maybe replacing the
/sbin/mdadm binary with a wrapper Bash script that runs the real mdadm
in a debug mode?  I know nothing about debugging mdadm.

> > I've noticed that dmesg most often lists disks as "ata1", "ata9"
> > etc.  Do you know how to translate these disk identifiers?
> 
> Sorry, I cannot help you there.  I would probably look in /sys and
> see if anything looks vaguely similar.

I spent quite a while looking in /proc and /sys, but wasn't able to
come up with anything.  The only method I came up with was to go back
in the dmesg history until there was a message from only one disk at
a time, in which case it was easy to deduce which "ata*" related to
which "/dev/sd*".

> What you could do is add both drives, then abort the recovery with
>   echo idle > /sys/block/md13/md/sync_action
> The recovery will then start again immediately, but using both drives.

Thank you.

> A future release of mdadm will 'freeze' the sync action before adding
> any drives, then unfreeze afterwards so this will work better in the
> future.

That sounds like a good way to deal with it.

> "Medium Error" is not good.  It implies you have lost data.
> Though it might be transient due to heat? or something.

So far I have only attempted the one rebuild (before this issue with
a Spare being created of the /dev/sdc1).  I have switched it from the
motherboard SATA port to one on the PCI card.  Hopefully it can get
through the rebuild this time.

It wouldn't be due to heat currently, as the disks are as well
ventilated as is possible: in a plastic frame outside the computer,
open to the air, several inches from other disks, with a standing
room fan blowing air over them.

Before the crash a week ago, 4 of the 8 disks were close together in
a 3.5" metal drive cage and were quite hot to the touch.  I'm not
sure if the problematic /dev/sdc disk was in the group of hot disks
or not.  Also not sure if heat can cause permanent damage to a disk.
I think it's just a bad batch of disks, when I recently went looking
online for people with the same model disk, there were lots of
comments about them dying.

> The array doesn't go completely off-line.  It remains sufficiently
> active for you to be able to read any block that isn't on a dead
> drive.  Possibly there isn't much point in that.

I see.  It seems unlikely that I would be able to swapoff 100MB+ of
data in such a situation, but I was able to, after the RAID-5 on
/dev/md9 lost two disks.

> > What is this "recovery done" referring to?
> > No recovery was completed.
> 
> I just means that it has done all the recovery that it can.

Perhaps a more appropriate message would be something like:

"unable to continue with recovery, aborting"

> > I arrived home and performed the following commands
> > (I have removed some of the duplicate commands):
> > 
> > # mdadm --verbose --verbose --detail --scan /dev/md13
> > # mdadm --verbose --verbose --detail --scan /dev/md13
> > # mdadm /dev/md13 --remove /dev/sdj1 /dev/sdi1
> > # mdadm --verbose --verbose --detail --scan /dev/md13
> > # mdadm /dev/md13 --remove /dev/sdc1
> > # mdadm --verbose --verbose --detail --scan /dev/md13
> > # mdadm /dev/md13 --re-add /dev/sdc1
> 
> This is where you went wrong.  This will have added /dev/sdc1 as
> a spare, because the array was too degraded to have any hope of
> really re-adding it.

Do you mean that "mdadm --detail --scan /dev/md13" caused the disk
to become marked as a Spare?  Because it was listed as a Spare the
first time I ran that command when I arrived home.

> You should be able to create the array with
> 
>  mdadm --create /dev/md13 -l6 -n8 missing /dev/sdd1 /dev/sda1 /dev/sdf1 \
>                                   missing /dev/sdc1 /dev/sde1 /dev/sdb1
>         
> providing none of the devices have changed names.
> Then you should be able to get at your data.
> You could try a recovery again - it might work.

Thank you.

> But if it fails, don't remove and re-add drives that you think have
> good data.  Rather stop the array and re-assemble with --force.

Okay.  But just to clarify, this last time the rebuild failed, I did
not --remove and --re-add any disks until after I saw that /dev/sdc
had become a Spare.

I am off to sleep now, will try the rebuild before I go to work.

Thanks for all your help, very much appreciated.

 - S.A.





