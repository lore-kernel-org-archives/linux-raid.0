From: AndyLiebman@aol.com
Subject: Urgent-- Solved my problem. Please don't spend time on it
Date: Sat, 6 Mar 2004 14:58:58 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <d5.6e037dd.2d7b8782@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Hi to all who may read this. 

I solved the problem I wrote in about yesterday and the two days before (see 
below). After a lot of worrying and nervousness, I realized that I had a new 
RAID (on a new server) that I could play with to simulate the problem that 
developed on my production machine. And as I had intentionally made it a very 
small RAID 5 array on the new server -- so that it would sync quickly and so that 
I could experiment -- I found the answer and the security that I was on the 
right track. When I repeated the same steps on my production machine, I found my 
data was still good! 

I WILL say that the mdadm manual could benefit from more information about the
'--run' option. In the manual, it's not clear exactly what it does. And 
because mdadm can give you an error message telling you to use '--run' to insist on 
starting an array, an inexperienced user like me with a RAID problem can 
worry a lot. So, I volunteer to write up a brief paragraph describing when one 
might want to use the '--run' option and what it does. I think it could save a 
lot of people a lot of worry and panic in the future. I'll send it to Neil Brown 
and if he thinks it's helpful he can include it in the manual. 

I hope somebody else does the same for the '--force' option. That's another 
one that could really use further explanation. 

Otherwise, I'm enchanted with mdadm. It's an amazingly user-friendly program. 

I also want to say that I'm having great success with the 2.6.3 kernel and 
RAID. As I'm using firewire drives (getting i/o in the range of 85 MB/sec), the 
2.6.3 kernel is particularly handy because it gives much more useful 
information with 'cat /proc/mdstat' that is helpful for figuring out the device ID of 
any drive that's causing problems. With the 2.4 kernel (and presumably earlier 
ones) mdstat referred to PCI slot numbers and the like and it was a bit of a 
challenge to figure out what device ID went with what drive and array. But with 
the 2.6 kernel I'm finding that mdstat lists the current device id's. Of 
course, the device ids can change from one boot to the next, but at least you know 
what id a drive currently has. I'll write more on that later too. 

In the meantime, thanks for being patient with my panics. 
Andy Liebman
------------------------------------------------------------------
HERE'S MY POSTING FROM YESTERDAY



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
