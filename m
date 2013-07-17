From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: MD RAID 1 fail/remove/add corruption in 3.10
Date: Wed, 17 Jul 2013 10:52:31 +0800
Message-ID: <51E606EF.7070801@fnarfbargle.com>
References: <20130716144920.39f428b7@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130716144920.39f428b7@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>, Martin Wilck <mwilck@arcor.de>
List-Id: linux-raid.ids

On 17/07/13 02:49, Joe Lawrence wrote:
> Hi Neil, Martin,
>
> While testing patches to fix RAID1 repair GPF crash w/3.10-rc7
> ( http://thread.gmane.org/gmane.linux.raid/43351 ), I encountered disk
> corruption when repeatedly failing, removing, and adding MD RAID1
> component disks to their array.  The RAID1 was created with an internal
> write bitmap and the test was run against alternating disks in the
> set.  I bisected this behavior back to commit 7ceb17e8 "md: Allow
> devices to be re-added to a read-only array", specifically these lines
> of code:

This sounds like an issue I just bumped up against in RAID-5.
I have a test box with a RAID-5 comprised of 2 x 2TB drives, and 6 
RAID-0's of 2 x 1TB drives.


root@test:/root# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md3 : active raid5 md20[0] md25[8] md24[7] md22[6] sdl[4] sdn[3] md23[2] 
md21[1]
       13673683968 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[8/8] [UUUUUUUU]
       bitmap: 0/15 pages [0KB], 65536KB chunk

md22 : active raid0 sdk[0] sdm[1]
       1953524736 blocks super 1.2 512k chunks

md20 : active raid0 sdj[0] sdo[1]
       1953522688 blocks super 1.2 512k chunks

md21 : active raid0 sdh[0] sdi[1]
       1953524736 blocks super 1.2 512k chunks

md25 : active raid0 sda[0] sdb[1]
       2441900544 blocks super 1.2 512k chunks

md23 : active raid0 sdd[0] sde[1]
       1953522688 blocks super 1.2 512k chunks

md24 : active raid0 sdf[0] sdg[1]
       1953524736 blocks super 1.2 512k chunks

I was running a check over md3 whilst rsyncing a load of data onto it.
md20 was ejected some time during this process. (A smart query issued 
caused a timeout on one of the drives). I removed md20, stopped md20, 
started md20 and re-added md20.

This should have caused a re-build as the bitmap would have been way out 
of sync, however it immediately reported the rebuild complete and left 
the array mostly trashed. (about 500,000 mismatch counts).

kernel at the time was late in the 3.11-rc1 merge window. 
3.10.0-09289-g9903883

I've been meaning to try and reproduce it, but as each operation takes 
about 5 hours it's slow going.

This is a test array, so it has no data value. I'm happy to try to 
reproduce this fault if it would help any.

Regards,
Brad
