From: Luca Berra <bluca@comedia.it>
Subject: Re: raid5 wont restart after disk failure, then corrupts
Date: Wed, 1 Mar 2006 12:37:34 +0100
Message-ID: <20060301113734.GA32059@percy.comedia.it>
References: <20060228220811.GA32469@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060228220811.GA32469@cjx.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 28, 2006 at 10:08:11PM +0000, Chris Allen wrote:
>
>Yesterday morning we had an io error on /dev/sdd1:
>
>Feb 27 10:08:57 snap25 kernel: SCSI error : <0 0 3 0> return code = 0x10000
>Feb 27 10:08:57 snap25 kernel: end_request: I/O error, dev sdd, sector 50504271
>Feb 27 10:08:57 snap25 kernel: raid5: Disk failure on sdd1, disabling device. Operation continuing on 7 devices
>
>So, I shutdown the system and replaced drive sdd with a new one. 
>When I powered up again, all was not well. The array wouldn't start:
>
>Feb 27 13:36:02 snap25 kernel: md: md0: raid array is not clean -- starting background reconstruction
....
>Feb 27 13:36:02 snap25 kernel: raid5: cannot start dirty degraded array for md0

something happened whan you shut down the system and the superblock on
the drives was not updated

>I tried assembling the array with --force, but this would produce exactly the
>same results as above - the array would refuse to start.
>
>QUESTION: What should I have done here? Each time I have tried this in the past, I
recreate the array with a missing drive in place of sdd.
mount your fs readonly (as ext2 in case it was ext3) and verify that all
data is readable.

>have had no problems restarting the array and adding the new disk. What had gone
>wrong, and why wouldn't the array start?
something happened whan you shut down the system and the superblock on
the drives was not updated

>Then things went from bad to worse.
>
>
>===========================================
>PROBLEM 2 - DATA CORRUPTION
>===========================================
>
>
>1. Any idea what had happened here? Why didn't it notice that sdd1 was stale? 
something happened whan you shut down the system and the superblock on
the drives was not updated
>
>2. If I had let it complete its resync would it have sorted out the corruption? 
no
>Or would it have made things worse?
possibly yes

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
