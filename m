From: AndyLiebman@aol.com
Subject: What does mdadm --run do? And should I do it?
Date: Fri, 5 Mar 2004 23:11:19 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1ea.1aa8d579.2d7aa967@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all. I made a couple of postings here two days ago and didn't get any 
definitive response so let me re-phrase my question in a more focused way. 

I have a problem with a 5-disk RAID 5 array. It seems that one of my drives 
(sdc1) failed or got corrupted, but DID NOT get marked in the moment as 
"faulty, removed". Why the Linux md subsystem thought the drive was still good is an 
interesting question but besides the point right now.  Anyway, AFTER I 
REBOOTED the superblock was gone on sdc1. 

mdadm -E /dev/sdc1
mdadm: No super block found on /dev/sdc1 (Expected magic a92b4efc, got 
00000000)

However, the other 4 drives in the array apparently don't "know" that sdc1 is 
faulty so the Linux RAID system is looking for the 5th drive in order to 
start the array. When I try to start it with madam and the uuid, I get this: 

mdadm: added /dev/sdh1 to /dev/md6 as 1
mdadm: added /dev/sdj1 to /dev/md6 as 2
mdadm: no uptodate device for slot 3 of /dev/md6
mdadm: added /dev/sdb1 to /dev/md6 as 4
mdadm: added /dev/sdf1 to /dev/md6 as 0
mdadm: /dev/md6 assembled from 4 drives - need all 5 to start it (use --run 
to insist)

And when I do mdadm -E on the 4 drives that are added to md6, they all report 
that there are 5 active drives in the array, and that none are faulty. 

It seems pretty clear to me that I have to mark sdc1 as faulty and remove it 
(and then add it back, or replace the disk). But what isn't clear is whether I 
should 

1) FIRST start the array with --run (as the mdadm message suggests) and 
afterwards do the ' --fail --remove '  thing? 

2)  FIRST do ' mdadm -- fail --remove ' on sdc1 and then use --run? 

3)  do ' mdadm -- fail --remove ' on sdc1 and then not bother with --run?

3)  or whether --run itself will cause sdc1 to be set as faulty, removed


This just isn't clear from the mdadm manual pages. Is --run a combination of 
-- fail --remove --and then start? 

I'm really worried about doing the wrong thing. Is there somebody out there 
who knows what's correct? If you want more information about what happened to 
my arrays and the nature of the corruption, please look at my previous posts. 

Thanks in advance for your answers. 

Andy Liebman
