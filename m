From: Brennahn Chesteine <ven_ficken@yahoo.com>
Subject: Redhat8 software RAID0 and kernel upgrade, won't boot
Date: Tue, 18 Mar 2003 07:27:50 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030318152750.95214.qmail@web14402.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I really need someone to have a bit of pitty on me and
hold my hand for a minute. 

It all started when I purchased a Silicon Image ATA
RAID controller for my Linux boxen.. OPPS. Well I
swallowed my pride and decided I would cut my losses
and setup software RAID0. RH8 made this so easy a
lobotamized gerbil could do it. I set up the box to
have both root and swap partitions in RAID0 and the
/boot partition was left alone. Now everything was
fine and dandy. Enter day two, I went to get rid of
that nasy evil RH Kernel and swap it out for 2.4.20. I
have done this in the past without software RAID and
had no trouble.   

Well, 2.4.20 built without error and installed clean.
I said yes to RAID support and built everything under
that as a module. Also enable generic SCSI support and
emulation for the CD burner. went to update
lilo.con.... @%$#@!!! I installed grub instead of
lilo... grrr!. Knowing squat about grub I opend the
grub.conf and cloned my existing config and replaced
initrd with 2.4.20 and renamed it. 

Rebooted and whola there 2.4.20 was as an option.
Selected it and thins went to churning..... PANIC
cannot find root. I have read and read about have to
voodoo the lilo.conf file to make it work but have
found zilch on grub.

Can anyone point me in the correct direction here?? To
be honest I really don't know what information I need
to provide.. I just want a non stock kernel to boot...
waaah!

Seriously, thanks in advance for any help!  

 

__________________________________________________
Do you Yahoo!?
Yahoo! Platinum - Watch CBS' NCAA March Madness, live on your desktop!
http://platinum.yahoo.com
