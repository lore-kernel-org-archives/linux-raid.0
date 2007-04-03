From: Al Boldi <a1426z@gawab.com>
Subject: Re: raid1 does not seem faster
Date: Tue, 3 Apr 2007 16:42:27 +0300
Message-ID: <200704031642.27701.a1426z@gawab.com>
References: <Pine.LNX.4.61.0704011417470.8018@yvahk01.tjqt.qr> <200704011558.31670.a1426z@gawab.com> <46118473.10205@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46118473.10205@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Al Boldi wrote:
> > The problem is that raid1 one doesn't do striped reads, but rather uses
> > read-balancing per proc.  Try your test with parallel reads; it should
> > be faster.
:
:
> It would be nice if reads larger than some size were considered as
> candidates for multiple devices. By setting the readahead larger than
> that value speed increases would be noted for sequential access.

Actually, that's what I thought for a long time too, but as Neil once pointed 
out, for striped reads to be efficient, each chunk should be located 
sequentially, as to avoid any seeks.  This is only possible by introducing 
some offset layout, as in raid10, which infers a loss of raid1's 
single-disk-image compatibility.

What could be feasible, is some kind of an initial burst striped readahead, 
which could possibly improve small reads < (readahead * nr_of_disks).


Thanks!

--
Al

