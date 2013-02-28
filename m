From: Jamie Thompson <jamierocks@gmail.com>
Subject: Re: Corrupted FS after recovery. Coincidence?
Date: Thu, 28 Feb 2013 01:01:04 +0000
Message-ID: <512EAC50.1070305@gmail.com>
References: <512E6098.6040703@jamie-thompson.co.uk> <512E947D.1030000@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512E947D.1030000@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: joystick <joystick@shiftmail.org>
List-Id: linux-raid.ids

On 27/02/2013 23:19, joystick wrote:
> Not coincidence.
I don't really believe in coincidences, but you never know :)

>
> For sure MD cannot possibly recover 500GB in 9 seconds so something 
> must be wrong.
I wasn't sure if it had some clever way of noticing the change and 
simply "shifted" the start data to the end and left the middle as-was. 
Linux software RAID and LVM is awesome, so it seemed possible :)

> You do not show metadata type. My guess is that it is at the end of 
> the disk (1.0 maybe) and so when you added sdf1 MD thought it was a 
> re-add and re-synced only the parts that were dirty in the bitmap 
> (changed since removal of sdf). However since you moved the start of 
> the disk, all data coming from such disk are offsetted and hence 
> bogus. That's why metadata default for mdadm is version 1.2: you don't 
> risk this kind of crazy things with 1.2 .
It's an old array I've had for years, so 0.90. :(

> With nondegraded raid-5 (which is the situation after adding sdf1), in 
> raid5 the reads always come from the nonparity disk for every stripe. 
> So when you read, approximately you get 1/3 of data from sdf1, all of 
> it bogus. Clearly also ext3 is not happy with its metadata screwed up, 
> hence the read errors you see.
>
> If I am correct, the "fix" for your array is simple:
> - fail sdf1
> After that already you can read. Then do mdadm --zero-superblock 
> /dev/sdf1 (and maybe even mdadm --zero-superblock /dev/sdf then 
> repartition the drive, just to be sure) so mdadm treats it like a new 
> drive. Then you can re-add. Ensure it performs a full resync, 
> otherwise fail it again and report here.
>
> Too bad you performed fsck already with bogus sdf1 in the raid... Who 
> knows what mess it has done! I guess many files might be unreachable 
> by now. That was unwise.
After killing all the services that were dying from db corruption (ldap, 
mysql, etc) I tried to fsck /var (where all the errors were coming 
from)...but couldn't unmount it, so I failed the new disk as it was 
clear that the quick recovery was the most likely culprit, then rebooted 
with forced fscks. I guess I had a lucky hunch there then! I'd already 
shut off syslogd before I failed the new disk as I was trying to unmount 
/var, so these actions weren't logged.

Ok, so a --zero-superblock is all I need to ensure a recovery doesn't 
happen again and I get a proper rebuild? Cool.

> For the backup you performed to an external disk: if my reasoning is 
> correct you can throw it away. This is unless you like to have 1/3 of 
> the content of your files full of bogus bytes. You will have more luck 
> backing up the array again after failing sdf1 (most parity data should 
> still be correct, except where fsck wrote data).
:) My backup was made from the degraded array after a reboot and the 
automatic safe repairs, and so far a fsck -nv gives just 16 inodes on 
/home with errors, all of which are old chat logs, /usr has 29 inodes 
with errors, 13 of which I have the filenames of (so easy to grab the 
files from their packages if recovery goes badly)...the other 16...well. 
Guess I'll discover those in time. Finally, /var has just 15 inodes with 
errors, all of which are wiki captcha images, apparently. So lucky 
escape there it would seem!

Incidentally, I've made a handy little script I'm playing with whilst 
waiting for the scans to complete:
> #!/bin/sh
> fsck -nv $1 | grep -ioE "inode ([0-9]+)" | cut -c 7- | sort | uniq | 
> xargs -i -d \\n debugfs -R 'ncheck {}' $1 | grep -e "^[0-9]"
Give it a partition (i.e. /dev/main/homes) and it'll eventually show you 
the filenames of inodes with errors...last bit of piping from debugfs is 
not quite right yet though, had to do that manually.
...I do love the *nix command line ;)

> However before proceeding with anything I suggest to wait for some 
> other opinion on the ML, 'cuz I am not infallible (euphemism).
> Disassemble the raid in the meantime. This will make sure at least 
> that a cron'd "repair" does not start, that would be disastrous.
Indeed. I'm being pressured to get the system back up, but I'm taking 
very measured steps now! I've scped some of the backup I made to my 
location and things seem fine...I want to do more checks though to be 
sure. Touch wood, I might be lucky...

> Also please tell us your kernel version and cat /proc/mdstat please so 
> we can make better guesses.
Certainly.

> mrlinux:/# uname -a
> Linux mrlinux 3.2.0-4-686-pae #1 SMP Debian 3.2.35-2 i686 GNU/Linux
>
> mrlinux:/# cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md1 : active raid5 sde1[0] sdc1[1]
>       975145216 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]
>       bitmap: 175/233 pages [700KB], 1024KB chunk
>
> md0 : active raid1 sda1[0] sdb1[1]
>       1951744 blocks [2/2] [UU]
>
> unused devices: <none>
Nothing fancy :)

>
> Good luck
> J.
>
Thanks for your advice (and thanks Adam as well!)
- Jamie
