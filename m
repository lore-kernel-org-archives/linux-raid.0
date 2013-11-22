From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Triple parity and beyond
Date: Fri, 22 Nov 2013 21:32:17 +0100
Message-ID: <20131122203217.GA3739@lazy.lzy>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
 <20131119181237.GA3666@lazy.lzy>
 <528C9297.9030801@hesbynett.no>
 <20131120215939.GA2622@lazy.lzy>
 <528DDCC9.7050701@hesbynett.no>
 <20131121200545.GB1916@lazy.lzy>
 <528E6DB2.6050005@hesbynett.no>
 <20131121205229.GA2458@lazy.lzy>
 <528EA609.9060702@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <528EA609.9060702@hesbynett.no>
Sender: linux-btrfs-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Andrea Mazzoleni <amadvance@gmail.com>, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org, hpa@zytor.com, creamyfish@gmail.com
List-Id: linux-raid.ids

Hi David,

On Fri, Nov 22, 2013 at 01:32:09AM +0100, David Brown wrote:
> > One typical case is when many errors are
> > found, belonging to the same disk.
> > This case clearly shows the disk is to be
> > replaced or the interface checked...
> > But, again, the user is the master, not the
> > machine... :-)
> 
> I don't know what sort of interface you have for the user, but I guess
> that means you'll have to collect a number of failures before showing
> them so that the user can see the correlation on disk number.

as usual in Unix, one software will collect
data to a file, an other one will analyze
that file.
Originally, one idea was even to check at
stripe level how many errors (and where)
are present. From that some statistics will
be presented to the user.
This would be integrated in the check tool,
of course.

> >> For most ECC schemes, you know that all your blocks are set
> >> synchronously - so any block that does not fit in, is an error.  With
> >> raid, it could also be that a stripe is only partly written - you can
> > 
> > Could it be?
> > I would consider this an error.
> 
> It could occur as the result of a failure of some sort (kernel crash,
> power failure, temporary disk problem, etc.).  More generally, md raid
> doesn't have to be on local physical disks - maybe one of the "disks" is
> an iSCSI drive or something else over a network that could have failures
> or delays.  I haven't thought through all cases here - I am just
> throwing them out as possibilities that might cause trouble.

OK, I misunderstood you, I was thinking during
normal operation...
Again, the check can find that issue, it will
tell that it cannot find where the problem is.
But it will tell where.
Possibly, an other tool can check the FS at
that position.

bye, 

-- 

piergiorgio
