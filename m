From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Change preferred minor number of an md device?
Date: Tue, 1 Feb 2005 09:00:10 +1100
Message-ID: <16894.43626.245995.431559@cse.unsw.edu.au>
References: <200501311813.28516.niccolo@texnet.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Niccolo Rigacci on Monday January 31
Sender: linux-raid-owner@vger.kernel.org
To: Niccolo Rigacci <niccolo@texnet.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 31, niccolo@texnet.it wrote:
> Hi to all, md gurus!
> 
> Is there a way to edit the preferred minor of a stopped device?

mdadm --assemble /dev/md0 --update=super-minor /dev/....

will assemble the array and update the preferred minor to 0 (from
/dev/md0).

However this won't work for you as you already have a /dev/md0
running...

> 
> Alternatively, is there a way to create a raid1 device specifying the 
> preferred minor number md0, but activating it provisionally as a different 
> minor, say md5? An md0 is already running, so "mdadm --create /dev/md0" 
> fails...
> 
> I have to dump my /dev/md0 to a different disk (/dev/md5), but when I boot 
> from the new disk, I want the kernel to autmatically detect the device 
> as /dev/md0.

If you are running 2.6, then you just need to assemble it as /dev/md0
once and that will automatically update the superblock.  You could do
this with kernel parameters of 
   raid=noautodetect md=0,/dev/firstdrive,/dev/seconddrive

NeilBrown
