From: Jonathan Loran <jonathan@loran.name>
Subject: Adding a hot spare to a software raid 5 array
Date: Wed, 15 Jan 2003 14:25:16 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E25DFCC.8080109@loran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


All:

I am new to this list, so apologies for any ignorance, or if this 
question has already been answered (though I did look through the 
archives a bit).  I have a raid 5 array consisting of 6 disks with no 
hot spare.  Here is the output of /proc/mdstat

    Personalities : [raid5]
    read_ahead 1024 sectors
    md0 : active raid5 sdc1[0] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1]
          177718400 blocks level 5, 128k chunk, algorithm 2 [6/6] [UUUUUU]
         
    unused devices: <none>

I recently obtained another identical drive, and want to add it as a hot 
spare.  I have seen on the list the following commands to accomplish this:

    raidhotadd /dev/md0 /dev/sdi1

or

    mdadm /dev/md0 -a /dev/sdi1

Where /dev/sdi1 will be the new drive.  Are these the canonical ways to 
do this?

I get the feeling that mdadm is more stable than raidtools, so I'm 
trying to move to using just them.  I do have backups, but it would sure 
make me happy not to have to recover 100 GB of data from multiple DLT3xt 
tapes.

Thanks in advance,

-- 
    			 
     - Jonathan Loran -  
       (415) 572-1017
     jonathan@loran.name
  			    
	   


