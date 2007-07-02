From: jahammonds prost <gmitch64@yahoo.com>
Subject: RAID5 Expansion
Date: Sun, 1 Jul 2007 18:16:14 -0700 (PDT)
Message-ID: <5375.21564.qm@web55809.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've just finished adding some extra disks to my server, and I've got a couple of questions I can't quite work out...


I've just added 3 more 320Gb drives into the server, and I want to expand my existing md0 with /dev/sd1 and /dev/hde1. Do I need to do these individually, or can they both be done at the same time. Also can you (and is there any point in) changing the stripe size? most of the files on this disk will be 350Mb+ video files.


Also, when I started building this server, I was using a mix of 300Gb and 320Gb drives, so for the 320Gb drives, I made /dev/hda2 with the remaining 20Gb. As time has gone on, I've replaced all the 300Gb drives with 320Gb ones. Is there any easy way to pull these extra 20Gb partitions into the main array? I've got them set as /dev/md1 at the moment, and I use lvm, so I could pull them into my filesystem that way. Killing /dev/md1 is an option (I can back up the data elsewhere). Killing /dev/md0 isn't.. All the data is backed up, but it would be a full weekend of swapping DVDs in and out to restore it.

Thanks.


Graham


      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/ 
