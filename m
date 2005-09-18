From: Al Boldi <a1426z@gawab.com>
Subject: Re: Good, recent FS comparison?
Date: Sun, 18 Sep 2005 15:32:54 +0300
Message-ID: <200509181426.33327.a1426z@gawab.com>
References: <6d5bedd8050915131148b8108a@mail.gmail.com> <200509162258.37730.a1426z@gawab.com> <432D3024.3080302@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <432D3024.3080302@dtbb.net>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

Tyler wrote:
> Al Boldi wrote:
> >Don't touch anything that doesn't do ordered-mode journaling, especially
> > if you use raid, unless your data-consistency requirements don't require
> > this.
>
> Al... you've given us some "do's" .. can you give us some "why's" to go
> along with them? :)  I would appreciate a run-down with some more
> specific info as to what/why.

see 'XFS corruption on power-blackout' thread

> >XFS is best, but does not support ordered-mode.
Highest performance ratio available due to low CPU usage.

> >reiser4 is still new.
New, but promising.

> >ext3 is rock-solid!
Low performance ratio due to high CPU usage.

--
Al
