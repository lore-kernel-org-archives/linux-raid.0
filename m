From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID halting
Date: Fri, 24 Apr 2009 18:50:31 +1200
Message-ID: <49F16137.1050108@sauce.co.nz>
References: <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Leslie Rhorer wrote:
> 
> 3.  The man page says "When a filesystem is created on a logical volume
> device, mkfs.xfs will automatically  query  the  logical  volume  for
> appropriate sunit and swidth values."  Does this mean it is best for me to
> simply not worry about setting these parameters and let mkfs.xfs do it, or
> is there a good reason for me to intervene?

XFS will do exactly that and choose the correct sunit and swidth based 
upon the RAID stripe size you have chosen - do not worry about it.


> 5.  Finally, one other thing concerns me a bit.  The researchers I read
> suggested XFS has by far the worst file deletion performance of any of the
> journaling file systems, and Reiserfs supposedly has the best.  I find that
> shocking, since deleting multi-gigabyte files on the existing file system
> can take a rather long time - close to a minute.  Small to moderate sized
> files get deleted in a flash, but 20GB or 30GB files take forever.  I didn't

Quad core Xeon 2.8GHz md RAID6 of 16 x 750GB. Delete 20GB file:

time rm -f dump

real    0m1.849s
user    0m0.000s
sys     0m1.633s

Regards,

Richard
