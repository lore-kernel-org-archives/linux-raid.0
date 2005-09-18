From: Matt Stegman <matts@ksu.edu>
Subject: Re: Good, recent FS comparison?
Date: Sun, 18 Sep 2005 11:34:02 -0500 (CDT)
Message-ID: <Pine.GSO.4.44L.0509181124430.23379-100000@unix2.cc.ksu.edu>
References: <432D3024.3080302@dtbb.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <432D3024.3080302@dtbb.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: Al Boldi <a1426z@gawab.com>, linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

This has been discussed on the mailing list before.  Quick rundown:

"Ordered mode" means that a file's metadata isn't written until after the
file's data.  On XFS, which doesn't use ordered mode, under certain
circumstances you may see files which are the correct size, with correct
times, etc, but with only null bytes for the data.

In my experience it's not that big a deal; I can almost always easily
recreate data which could be lost by being written out just before a crash
or power loss.  I put important systems on an UPS and use stable kernels,
and I've never personally seen the null data problem.

Currently, I believe only ext3 and reiserfs support ordered mode.  I'm not
sure if reiser4's journaling is ordered or not.

-- 
Matt Stegman

On Sun, 18 Sep 2005, Tyler wrote:
>
> Al Boldi wrote:
>
> >Don't touch anything that doesn't do ordered-mode journaling, especially if
> >you use raid, unless your data-consistency requirements don't require this.
> >
> >XFS is best, but does not support ordered-mode.
> >reiser4 is still new.
> >ext3 is rock-solid!
> >
>
> Al... you've given us some "do's" .. can you give us some "why's" to go
> along with them? :)  I would appreciate a run-down with some more
> specific info as to what/why.

