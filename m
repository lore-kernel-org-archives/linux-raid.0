From: Al Boldi <a1426z@gawab.com>
Subject: Re: Good, recent FS comparison?
Date: Sat, 17 Sep 2005 00:17:08 +0300
Message-ID: <200509162258.37730.a1426z@gawab.com>
References: <6d5bedd8050915131148b8108a@mail.gmail.com> <432A37BF.7060305@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <432A37BF.7060305@dtbb.net>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

Tyler wrote:
> Ewan Grantham wrote:
> >I've just setup a nice, 6-disk, USB-2 300 Gig/disk array, and was
> >prepared to follow my normal pattern of installing ext3 as the
> >filesystem. However, I saw the interview with Hans Reiser about
> >ReiserFS4, and am now wondering if reiser has really improved enough
> >to use it, or if ext3 is still the way to go?
>
> You'd be best off trying some tests of your own, using files of the size
> and quantity you expect to use on a regular basis.  I would consider
> ext3, xfs, and reiser3/4... and run some tests with them.  We've had
> really good luck using XFS on large raids, I personally had a bad
> experience with reiserfs 3, it lost data on a USB based drive, as if it
> were never even there, even after trying the recovery tools.

Don't touch anything that doesn't do ordered-mode journaling, especially if 
you use raid, unless your data-consistency requirements don't require this.

XFS is best, but does not support ordered-mode.
reiser4 is still new.
ext3 is rock-solid!

--
Al

