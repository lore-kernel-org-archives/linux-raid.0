From: Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org>
Subject: Making more space in RAID5 array: questions
Date: Sat, 05 Jul 2003 00:16:10 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.2.0.9.0.20030704235310.00b2ea38@mailhost.ivimey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Folks,

I have a 112GB Linux-SW RAID-5 array on 4x40GB Seagate Barracuda ATA IV IDE 
disks that is currently ok but is low on free space. There is no raid-spare 
drive.

I am not using LVM and the FS is IBMs JFS. The OS is Linux RH9 with a 
kernel.org kernel 2.4.22-pre2. The IDE controller is an motherboard Promise 
20276.

I have a spare 40G partition on my system (physical) drive and am thinking 
of adding it to the array.

I am aware of "raidreconf" being able to resize a raid array, but it's 
reportedly _very_ slow, is still beta, and the backup-before rule applies. 
However backing up and/or restoring is also very slow and error-prone 
because it's to multiple 12GB (DDS3) DAT tapes using "tar" (JFS has no 
"dump"). I am aware what LVM is but have little experience of it and have 
been wary of using it together with raid. My reason for using raid is to 
improve the reliability of my data.

Q1: What is the usual [ideal] strategy for adding space to a raid-5 disk array?

Q2: Has anyone experienced resizing JFS file systems using LVM: is it stable?

Q3: What should I do from here?

Q4: <afterthought> I could leave the spare 40G partition for array 
hot-spare -- would that be a Good Thing(TM)?

Thanks

Ruth


