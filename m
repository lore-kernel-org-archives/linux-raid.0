From: Matt Darcy <kernel-lists@projecthugo.co.uk>
Subject: mdadm --spare options
Date: Thu, 22 Dec 2005 15:12:50 +0000
Message-ID: <43AAC272.6070903@projecthugo.co.uk>
Reply-To: kernel-lists@projecthugo.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I'm looking for some one to clear up a missunderstanding on my part.

I have 7 sata disks, /dev/sdc - /dev/sdi

They all have 1 partition on them.

I am trying to make a raid5 array out of the 7 disks including 1 spare.

Sounds simple enough.

I wasn't sure if the the ---raid-devices included the --spare-devices 
option, I assumed not due to the --spare-devices, being marked as "extra."

I've issued the following command to do this

mdadm  --create /dev/md6 --level=5 --raid-devices=6 --spare-devices=1 
/dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1

Which starting making the array no problem.

A quick check on the raid progress and I see this

md6 : active raid5 sdh1[7] sdi1[6](S) sdg1[4] sdf1[3] sde1[2] sdd1[1] 
sdc1[0]
      1225558080 blocks level 5, 64k chunk, algorithm 2 [6/5] [UUUUU_]
      [==========>..........]  recovery = 54.3% (133157472/245111616) 
finish=154.9min speed=12041K/sec


which to me reads as sc1 disk 0 sdd disk1 sde disk 2 etc etc.
The questions are

1.) what happened to the disk order - shy is sdi (the spare) disk 6 
before sdh disk 7
2.) is there a way I can specifcy which disk I want to use as the 
"spare" - thats not critical, but would be handy.
3.) the UUUUU_ suggests that 5 disks are in use and will go to UUUUUU 
when all 6 disks are synced, is there a marker for the spare, or should 
there be a marker for the spare ? again I assume not bet I've not used 
the "spare" option on the software level before.
4.) I've accepted the default, right to left striping, I'm curious to 
the pros and cons of using left to right and symentic or even asymetric. 
I can think of uses for asymetric, but the other parity layouts I'd be 
interested in hearing peoples thoughts.

Many thanks,

Matt









