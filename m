From: AndyLiebman@aol.com
Subject: Making RAIDS with firewire drives -- changing device IDs.
Date: Sat, 25 Oct 2003 16:21:52 EDT
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <114.2a8b6710.2ccc3560@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone, 

I have a problem, however, and I'm wondering if anybody knows how to solve 
it. 

Using raidtab and mkraid, I am creating RAID arrays with external firewire 
drives and 5 separate PCI firewire controllers. I'm getting great performance. 
However, it seems that the device IDs of the drives are not fixed. When I 
created the RAIDs, I specified devices sda1, sdb1, sdc1, etc. in my raidtab.  
However, if I add additional drives to my system (say, to make a second additional 
RAID array) -- or if I accidentally unplug some drives while moving the 
computer and plug them in again differently - what was once sdb1 can now become 
sde1. This seems like a dangerous situation to me. At the very least, the 
information in the raidtab file will no longer accurate. 

I have now carefully labeled what drive is pluged into what controller port 
-- to guard against the accidental unplugging problem. However, it's inevitable 
that I'm going to want to add more drives to the system and that's going to 
change the device label assignments. 

I understand that mdadm can use UUIDs to identify drives. It's not clear to 
me whether each disk or partition that belongs to an array gets the SAME UUID 
number on it -- allowing mdadm to find all the disks that go together.  Or does 
each member of an array gets its own UUID and somewhere there's a record of 
all the UUIDs that go together? And if it's the latter, where is that record 
kept? 

Regardless of the answer to the above question, my bigger question is, will 
UUIDs give me a way of guaranteeing that I'll be able to start and manage my 
arrays even if the device labels (sda1, sdb1, etc.) change from what they were 
when I created the arrays? Do I have to record a UUID for each drive? Or only 
from each array? 

Based on what I have read about mdadm, it seems to me that each device in an 
array probably gets the same UUID, and that once I store the information from 
an array in the etc/mdadm.conf file I can use the UUID instead of the device 
name to start the array. 

(I also understand that all the involved device names must be listed in the 
mdadm.conf file. However, I'm not sure whether it would be bad to list ALL 
firewire devices (sda, sdb, etc.) in the mdadm.conf file, even if some of them are 
NOT part of any of the arrays listed there? If I had 12 firewire drives 
involved in arrays, but two that weren't, would it be bad to list all 14 in the 
mdadm.conf file if I wasn't sure which ones didn't belong to any arrays?) 

Right now I have three RAID 1 arrays that I made out of sda1, sdb1, sdc1, sdd
1, sde1, sdf1. These are md0, md1, and md2. On top of that, I have made a RAID 
0 array that stripes the three mirrors. 

Now lets say next month I want to make another set of arrays just like the 
first. So, I'll plug six more drives into my system and now, in addition to the 
first group of devices, I also have sdg1, sdh1, sdi1, sdj1, sdk1, sdl1. 

I'm 99 percent sure that when I plug in those devices and boot up my 
computer, some of the new devices will get assigned the older device ids. And some of 
the older drives that were part of the first group of arrays will get device 
IDs in the g-l range. That's just the way Firewire works, I'm afraid. 

Will I be able to start up my old arrays? 

And in order to create NEW arrays, will I have to figure out what device IDs 
(sda, sdb, etc.) correspond to the new empty drives that I just added? And 
what's the best way to do that? 

I am using Mandrake 9.2 -- which includes a configuration program (HardDrake) 
that lets me see all the device IDs and also tells me what the hardware 
location is for that device. So, for instance, sda is currently at 
scsi/host2/bus0/target1/lun0/part1. 

After adding new drives, assuming I can activate my existing arrays, I should 
be able to do a    "cat /proc/mdstat" that will tell me what hardware 
location corresponds to each device in those arrays. I should then be able to go back 
to HardDrake and see what the device IDs are (sda, sdb, etc) which correspond 
to those hardware locations that are referred to in the existing arrays. And 
then I would know what hardware locations -- and therefore device IDs -- are 
available for the new arrays. 

Does this make sense? Is there any easier way to solve my problem? I would 
very much appreciate the answers of people who know better than I. 

Thanks in advance. 

Sincerely, 

Andy Liebman


P.S.   The problem of "changing device id's" cropped up today after I wrote 
this note. I was resyncing one of my mirrors (md1 -- originally made up of sdc 
and sde). One of the drives had developed a "bad sector" and I needed to 
replace it. All I did was unplug the existing drive (with the computer shut down), 
put a new drive in its place, and boot up. 

The drive was recognized fine -- and I still had device id's sda- through 
-sdf. As it turns out, I didn't have any data on any of my drives, so I just 
issued the command "mkraid --really-force /dev/md1" to recreate the array. And 
much to my horror, I saw the drive lights come on for the drive I just replaced 
AND one of the drives that was supposed to be in my md2. Upon investigating the 
situation, I discovered that the drive that HAD BEEN sde was now sdf, and 
vice versa. So, without adding any additional drives (just substituting one for 
another), and without changing which PCI cards and ports the drives were 
plugged into, the drive ids changed! My raidtab file no longer accurately described 
what drive (sda, sdb, sdc, etc.) was supposed to be in what RAID array
