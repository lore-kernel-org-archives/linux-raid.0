From: Simon Valiquette <v.simon@ieee.org>
Subject: Re: raid5 and adding disks
Date: Fri, 17 Sep 2004 19:04:18 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <414B6D72.6070602@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew McCready <ajmccready@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message -----
From: Andrew McCready <ajmccready@yahoo.com>
Date: 	Fri, 17 Sep 2004 10:23:01 -0700 (PDT)
To: linux-raid@vger.kernel.org
Subject: raid5 and adding disks

 > Is it possible to add a disk to a raid5 array after
 > that array has been created?
 >

   You can, using raidreconf, but it have to be done with the RAID 
offline (which is probably fine for you).

   On Debian, you will find it in the raidtools2 package.

   It use 2 raidtab files: one containing the old raid config and 
another containing the intended configuration.  From the doc, it is also 
able to create a RAID-5 array directly from a RAID-1.  Maybe it is able 
to convert directly from RAID-0 to RAID-5, but I would'nt bet on it. 
Also, It is probably better to add only one disk at a time.

   Keep in mind that raidreconf is not the safest tools around.  All of 
those will likely destroy your data:

  - Errors in the raidtab files
  - Power outage
  - Disk failure during the process
  - Not enought memory (actually, the typical error handling code is 
resumed by this error message: "Out of memory where we must not fail. 
Hope you didn't need those data anyway...")
  - Halting the process in the middle.


   mdadm does'nt support what you need yet, but a --reshape option is 
ready for that purpose (what I understood from the code).

   I would like to eventually add the code to do that in mdadm (adding a 
disk to a live RAID-5 array), but I still don't have a deep enought 
understanding of the code.

   I have myself a RAID-5 array completelly full (less than 40GB left), 
but cannot use raidreconf because I cannot put my raid array offline for 
more than a very short periode of time.  My most wanted features for 
adding a disk to a RAID-5 array are:

  - Safe, even in case of a disk failure.
  - Be able to recover from a power (or power-supply) failure
  - Be able to continue after interruption in the middle of the process
  - Be done live, without unmounting the filesystem (growing a 
filesystem live is a different issue).

   I don't know when I will have enought time to build a experimental 
prototype, but thought the issue would interest many people.

Simon Valiquette
http://gulus.USherbrooke.ca


 > I just bought 3 disks that I plan to turn into a raid5
 > array, and I have two more disks in a raid0 array that
 > I'd like to add to it. The problem is that the raid0
 > has 6months worth of data on it, and I have no where
 > else to stick that data while building the raid5
 > array. I was hoping I could build a 3 disk raid5
 > array, move the files over, then add the 2 remaining
 > disks to the raid5 array.
 >
 > Thanks, Andrew
 > -
