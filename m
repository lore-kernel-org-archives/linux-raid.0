From: Mike Fedyk <mfedyk@matchmail.com>
Subject: Re: please help, I've screwed up my RAID 1 install
Date: Sat, 3 Jan 2004 23:09:27 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040104070927.GL1882@matchmail.com>
References: <004601c3d26b$f2d70fa0$c800a8c0@KARI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <004601c3d26b$f2d70fa0$c800a8c0@KARI>
To: Matthew Simpson <matthew@symatec-computer.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 03, 2004 at 08:39:15PM -0600, Matthew Simpson wrote:
> The problem is, if I reboot the machine, then I cannot mount /dev/md0 again
> until I do a mkraid /dev/md0 --really-force and rewrite the superblock.  I
> do not lose any data, but I know this "can't be good" [tm].
> 
> What can I do to fix this?  I've tried setting the partition types for
> hda1/hdc1 to the correct "fd" type, but fdisk complains "Partition 1 does
> not exist yet".
> 
> Also, it is possible to boot from a RAID device, is it not?  I assume it
> wasn't working before because of the superblock problem.
> 

Try changing your partitions with cfdisk, and learn and use mdadm for your
raid arrays.  You'll thank me. :-D
