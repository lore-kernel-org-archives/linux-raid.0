From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Encrypted software RAID1 with Debian Stretch
Date: Fri, 1 Sep 2017 10:46:57 +0100
Message-ID: <59A92C91.7010508@youngman.org.uk>
References: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
Sender: linux-raid-owner@vger.kernel.org
To: commentsabout@riseup.net, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/09/17 00:58, commentsabout@riseup.net wrote:
> Hello,
> 
> (this is a cross-post from debian-users mailing list
> https://groups.google.com/d/msg/linux.debian.user/jjdr6LXaOm8/MOoVVo0lAwAJ
> )
> 
> Here is a picture of what I'm trying to achieve:
> https://imgur.com/a/DAM8D (the "Today" column). 
> 
Have you read the raid wiki? There's a few bits there about how to
install a raid system, and/or how to update a system to raid.

Bearing in mind you're installing debian on an SSD, and *then* adding
raid that makes your life simpler, you can install the system and then
setup the raid. I personally normally think booting off a rescue disk
and using the command line is simpler than trying to use a graphical
installer, but if you've already got a working system, that's not a problem.

> I am trying to build a home backup system. The system (Debian Stretch) 
> will be on a SSD. For the time being, I only have one pair of HDDs (the 
> "Today" column in the picture) ; in the future (the "Future" column), I 
> would like to add other pairs of HDD to store other kind of data. 
> 
> This backup system will only be turned on when needed, I don't plan on 
> using it as some sort of server or a NAS. 
> 
Okay. Personal preference (and I don't do it myself, but I'd have to
rebuild my system to do it) I would use btrfs for the filesystems. Yes
it has a bad rep for its inbuilt raid, but if all you're doing is backup
snapshots it should be great. Each backup cycle consists of "take a
snapshot, do an in-place rsync", so if only 10MB of live data has
changed, the backup only uses an extra 10MB on the backup drives.

> We are talking about software RAID1. 
> 
> I would like everything to be encrypted (FDE), from the system (/ and 
> /swap) to the RAID1 drives. 
> 
> If possible, I would like to have different encryption keys for the 
> system and the various RAID1 pairs (in the "Future" column in the 
> picture, one for the system, one for "work", one for "family", one for 
> "misc"). So that I can give the system encryption passphrase, "family" 
> and "misc" ones to my wife and keep the "work" one for myself. 
> 
> I'm a complete noob when it comes to this kind of operations so I'm
> looking for a step by step ELI5 explanation (I have tried to use the
> Debian graphical installer to achieve this but have failed because I was
> just messing around with the options trying to figure out what to do). 
> 
> Thank you in advance for your help :) 
> 
Okay, two-disk raid-1 is okay. When you add drives, DON'T go for another
mirror, go to raid-6. Whether you partition the drives first, or use raw
drives, is up to you, but hand over the entire disk to your raid.

Put lvm on top of the raid. Okay, you could move partitions around, it's
not too hard, but creating three partitions for work, family, and misc
on top of lvm makes everything a lot simpler.

These three partitions are btrfs. That means *everything* can easily be
expanded as you add capacity - when you add two new drives and go raid-6
you just say "mdadm --add new drives", then you increase the array
capacity - "mdadm --resize" ? can't remember - then you expand lvm, then
you expand your filesystems.

When you've run out of slots and want to use bigger drives, it's "mdadm
--replace" instead of --add. MAKE SURE you *always* have access to a
spare SATA slot for expansion or disaster recovery! Add-in SATA cards
are cheap.

Then personally, I'd just script the backup routine so either when the
server is powered on, or requiring you to log in and do it, it

Takes the snapshots
Runs the rsync
Does a smartctl over all drives and emails you the results
Does "cat /proc/mdstat" and emails you the results
Does an "mdadm --examine" and "mdadm --display" over all drives and
arrays (one command is for drives, the other for arrays) and emails you
the results
Does the btfs equivalent of "du" and emails you the results
Anything else you can think of ...

And then shut down.

Note also, that filling up a btrfs partition can easily trash a
partition. That why the "du", and MAKE SURE you check it!!! (Note that
the "du" command itself doesn't work properly on btrfs ... :-(

Note that I have NOT put "do a scrub" in there. You really must do
regular scrubs, but they scan the entire array and are rate-throttled.
Running one could easily take days so you don't want to automate it, but
you don't want to forget it, either!

Note also, I've really only covered the raid aspect. I don't know lvm, I
don't know btrfs. I don't know LUKS. But this is exactly how I would set
up a backup server.

Cheers,
Wol
