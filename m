From: David Chow <davidchow@shaolinmicro.com>
Subject: Re: RAID-1 does not rebuild after hot-add
Date: Tue, 05 Aug 2003 00:41:18 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F2E8CAE.7090208@shaolinmicro.com>
References: <3F2D1FAC.9030905@shaolinmicro.com> <16173.43804.617586.906225@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
>
>I'm afraid I've got no idea what would be causing this.  
>I can only suggest you try a plain 2.4.21 kernel and if the problem
>persists we can add some extra printk's to find out what is happening.
>
>NeilBrown
>
Actually, I will try to recompile a plain vanilla kernel 2.4.21 and see 
what happens. However, it seems the problem exists if the raid is 
created by mkraid with one of the disk set to failed-disk . Then hot 
adding other disks to the degraded array will cause this behaviour. I 
deduce it is something wrong in the superblock because I can only make a 
normal RAID with no failed-disk using "mkraid --force" or mdadm which 
will of course resync right after the raid starts. Is there any chance 
to record any failed disk information in RAID superblocks (I mean 
recording failed-disk on the good disk's superblock)? I thought it 
doesn't make sense but it did happen and is repeatable (you can try if 
you want). This it the only thing to deal with because we can never keep 
the already started "good" disk superblock which is previously created 
in a degraded mode with failed-disk. Also, I've make sure other hot add 
partitions have already dd'ed to zeros. Maybe, I can hexdump a copy of 
the superblock for you to look at. What is the offset and size of the 
superblock of a RAID-1 device? I am sure this can effectively solve the 
problem right away.

regards,
David Chow

