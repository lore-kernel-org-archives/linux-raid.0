From: Scott Kopel <skopel@english.fsu.edu>
Subject: recovery question?
Date: Mon, 13 Oct 2003 11:21:51 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.0.0.22.2.20031013111015.032c1a58@englishmail.fsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a raid1 with two disks /dev/hda and /dev/hdc ... three md devices
/dev/md0 made up of hda1 and hdc1
/dev/md1 made up of hda2 and hdc2
/dev/md2 made up of hda3 and hdc3

--I accidently formatted hda1 using #mke2fs -vj /dev/hda1 ... bonehead move 
number 1
--then I booted from a backup drive and resynced the raid
--when I tried to boot from the /dev/md0 I couldn't boot because of 
filesystem errors
--so then I ran e2fsck /dev/md0 and several errors were noted and fixed.. I 
didn't write down the error messages because I was too harried, bonehead 
move number 2, however I think the errors were files without inodes... the 
errors were fixed and a bunch of files and directories were put in 
lost&found ... mostly they were a recently installed phpmyadmin directory 
in /var/www/html/phpmyadmin and the only other file I've found missing so 
far is /usr/bin/info..
--I am curious what happened.. did the format remove the superblock and 
resyncing rewrote the superblock using the inodes for  these files?
any info would be appreciated



Scott Kopel
English Department, FSU
Mail Code 1580
850 644 6177 

