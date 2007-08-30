From: Iustin Pop <iusty@k1024.org>
Subject: Re: Using my Mirror disk to boot up.
Date: Thu, 30 Aug 2007 07:14:24 +0200
Message-ID: <20070830051424.GA9525@teal.hq.k1024.org>
References: <12399907.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <12399907.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: chee <cheeming81@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 29, 2007 at 08:25:59PM -0700, chee wrote:
> 
> i,
> 
> This is my Filesystem:
> 
> Filesystem Size Used Avail Use% Mounted on
> /dev/md0 9.7G 6.6G 2.7G 72% /
> none 189M 0 189M 0% /dev/shm
> /dev/md2 103G 98G 289M 100% /home
> 
> and this is mirror settings:
> 
> Personalities : [raid1]
> md1 : active raid1 hda2[0] hdd2[1]
> 512000 blocks [2/2] [UU]
> 
> md2 : active raid1 hdd3[1] hda3[0]
> 109298112 blocks [2/2] [UU]
> 
> md0 : active raid1 hdd1[1] hda1[0]
> 10240128 blocks [2/2] [UU]
> 
> The problem i am facing is my mirror disk does not seem to boot up when i
> swap hard disk to test where my mirroring disk is working. The only thing i
> see was this 'LI' in the monitor and hangs there.
> 
The problem is (most likely) that your mirrors only cover the
hd[ad][123] partitions, and not the whole disk. Thus, the MBR of hda is
not synchronized to hdd.

You can do two things here:
  - fix your lilo.conf to correctly write to both hda and hdd (IIRC, you
    need the directive raid-extra-boot=mbr or raid-extra-boot=mbr-only,
    depending on how exactly you install lilo)
  - change to a partitionable raid array instead of three arrays (one
    for each partition); that will cover also the mbr of the drive


regards,
iustin
