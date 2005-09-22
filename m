From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Good, recent FS comparison?
Date: Thu, 22 Sep 2005 13:14:23 +0100
Message-ID: <20050922121423.GA30182@mail.shareable.org>
References: <6d5bedd8050915131148b8108a@mail.gmail.com> <200509162258.37730.a1426z@gawab.com> <20050921153703.GB19896@mail.shareable.org> <200509220034.42284.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200509220034.42284.a1426z@gawab.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

Al Boldi wrote:
> Jamie Lokier wrote:
> > Al Boldi wrote:
> > > ext3 is rock-solid!
> >
> > If only.  Recently I had a system come up after a power cycle with a
> > directory where reading any file in that directory gives an I/O error.
> > The disk is fine, and it's using ext3 in ordered mode, with IDE
> > write-caching disabled to be sure.
> 
> 2.4 or 2.6?
> 
> In 2.4 try a reboot and force an fsck before mounting.

2.4.26, uclinux - it's an embedded device.

Doing an fsck before mounting would be an unacceptable boot-time delay.

Why do you suggest that, specifically for 2.4?  Is there a known
problem with 2.4 and ext3?

Thanks,
-- Jamie
