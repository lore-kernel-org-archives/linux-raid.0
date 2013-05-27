From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: mdadm vs zfs for home server?
Date: Mon, 27 May 2013 17:33:15 -0500
Message-ID: <51A3DF2B.7070200@hardwarefreak.com>
References: <20130527180912.GA6068@septictank.raw-sewage.fake>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130527180912.GA6068@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 5/27/2013 1:09 PM, Matt Garman wrote:
...
> I got to thinking about the chances of data loss.  First off: I do
> have backups.  But I want to take every "reasonable" precaution
> against having to use the backups.  Initially I started thinking
> about zfs's raid-z3 (basically, triple-parity raid, the next logical
> step in the raid5, raid6 progression).  But then I decided that,
> based on the check speed of my current raid6, maybe I want to get
> away from parity-based raid all together.
> 
> Now I've got another 3TB drive on the way (rounding out the total to
> six) and am leaning towards RAID-10.  I don't need the performance,
> but it should be more performant than raid6.  And I assume (though I
> could be very wrong) that the weekly "check" action ought to be much
> faster than it is with raid6.  Is this correct?

The primary reason RAID6 came into use is double drive failure during
RAID5's lengthy rebuild times causing total array loss.  RAID10 rebuilds
are the same as a mirror rebuild.  Takes ~4-6 hours with 3TB drives.
Over the ~20 years RAID10 has been in use in both soft/hardware
solutions it has been shown that partner drive loss during rebuild is
extremely rare.  RAID6 rebuild times will be double/triple or more that
of RAID10.  And these will stress all drives in the array.  A RAID10
rebuild only stresses the two drives in the mirror being rebuilt.

RAID10 rebuild time is constant regardless of array size.  RAID6 rebuild
times tend to increase as the number of drives increases.  You may not
need the application performance of RAID10, but you would surely benefit
from the drastically lower rebuild time.  The only downside to md/RAID10
is that it cannot be expanded.  Many hardware RAID controllers can
expand RAID10 arrays, however.

WRT to scheduled scrubbing, I don't do it, I don't believe in it.  While
it may give you some piece of mind, this simply puts extra wear on the
drives.  RAID6 it is self healing, right, so why bother with scrubbing?
 It's a self fulfilling prophecy kinda thing--the more you scrub, the
more likely you are to need to scrub due to the wear of previous scrubs.
 I don't do it any arrays.  It just wears the drives out quicker.

If "losing" another 3TB to redundancy isn't a problem for you, I'd go
RAID10, and format the md device directly with XFS.  You may not need
the application performance of XFS, but backups using xfsdump are faster
than you can possibly imagine.  Why?  They're performed entirely in
kernel space inside the filesystem driver, no user space calls as with
traditional Linux backup utils such as rsync.  Targets include a local
drive, a local or remote file (NFS), tape, etc.

-- 
Stan


