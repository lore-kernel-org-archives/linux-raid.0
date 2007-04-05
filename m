From: Iustin Pop <iusty@k1024.org>
Subject: Re: raid1 does not seem faster
Date: Thu, 5 Apr 2007 06:58:19 +0200
Message-ID: <20070405045819.GA5525@teal.hq.k1024.org>
References: <Pine.LNX.4.61.0704011417470.8018@yvahk01.tjqt.qr> <200704011558.31670.a1426z@gawab.com> <46118473.10205@tmr.com> <200704031642.27701.a1426z@gawab.com> <461430B6.9060703@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <461430B6.9060703@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 04, 2007 at 07:11:50PM -0400, Bill Davidsen wrote:
> You are correct, but I think if an optimization were to be done, some 
> balance between the read time, seek time, and read size could be done. 
> Using more than one drive only makes sense when the read transfer time is 
> significantly longer than the seek time. With an aggressive readahead set 
> for the array that would happen regularly.
> 
> It's possible, it just takes the time to do it, like many other "nice" 
> things.

Maybe yes, but why optimise the single-reader case? raid1 already can
read in parallel from the drives when multiple processes read from the
raid1. Optimising the single reader can help in hdparm or other
benchmark cases, but in real life I see very often the total throughput
of a (two drive) raid1 being around two times the throughput of a single
drive.

regards,
iustin
