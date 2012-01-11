From: Josh Reynolds <josh.reynolds@yagermaterials.com>
Subject: RAID10 only using 2/4 drives
Date: Wed, 11 Jan 2012 08:51:34 -0600
Message-ID: <4F0DA1F6.9070700@yagermaterials.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello! 1st post on this mailing list, so be gentle.

I've got a production Ubuntu box that I used the installer to create a 
raid10 system on several months ago. I pretty much setup the box and 
then left it alone, to run a couple of different things and some vm's.

I really started to realize something was wrong fairly recently when my 
disk size was showing approx 1/2 of what I thought it should for a 
raid10. Also, my disk speeds were... not something I'd expect for 4 drives.

After looking into it, I realized mdadm had marked two of the drives as 
spares. WTF.

To make sure that I wasn't crazy, I wiped out a partition on each drive, 
and created a raid10 by hand. My original system array is md0, the other 
is md1.

----------------------------
josh@virtserver:~$ cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10]
md1 : active raid10 sda2[0] sdd2[3] sdc2[2] sdb2[1]
       46868480 blocks super 1.2 512K chunks 2 far-copies [4/4] [UUUU]

md0 : active raid10 sdd3[4](S) sdb3[3](S) sdc3[2] sda3[0]
       951370752 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
       bitmap: 3/8 pages [12KB], 65536KB chunk
---------------------------

I notice the 2nd array I created is showing the raid1 and raid0 
personalities... and I have a feeling that's what is gimping the md0 array?

I've tried fail/remove/adding those two partitions marked as spares, and 
it never adds them back as active members.

HELP! :)

  - Josh
