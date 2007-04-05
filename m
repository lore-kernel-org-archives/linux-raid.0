From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: raid6 rebuild
Date: Thu, 5 Apr 2007 10:48:51 +0200
Message-ID: <20070405084851.GA7696@xi.wantstofly.org>
References: <20070404194638.GB3712@xi.wantstofly.org> <Pine.LNX.4.64.0704050701310.20368@lion.drogon.net> <20070405062114.GB6978@xi.wantstofly.org> <Pine.LNX.4.64.0704050910140.20368@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704050910140.20368@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 05, 2007 at 09:15:38AM +0100, Gordon Henderson wrote:

> >>>[*] probably an entirely defective batch of 14 Samsung Spinpoint
> >>>500G disks
> >>
> >>Lets hope not... Keep checking those SMART values...
> >
> >Failed disk #2 still reports a SMART status of "PASSED"..
> 
> Hmmm.. I'd be tempted to double check your hardware + kernel versions
> then 

I think in this case it's more of a disagreement between me and the
disk about whether certain levels and patterns of bad sectors are
acceptable or not.

dd'ing the disk to /dev/null keeps reporting new UncorrectableError
sectors, which overwriting with zeroes then supposedly fixes (judging
by the increasing Reallocated_Sector_Ct), but a subsequent read from
the very same sectors reports the very same UncorrectableError errors
again, plus new errors from other sectors.

The SMART short offline tests also report "Completed: read failure".

Meanwhile, the disk still feels that that its SMART status is PASSED.

(FYI, these are Samsung Spinpoint T166S HD501LJ disks with serial
numbers in the range S0VVJ1KP3xxxxx)
