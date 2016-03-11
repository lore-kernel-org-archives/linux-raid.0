From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: multipath: I/O hanging forever
Date: Fri, 11 Mar 2016 15:24:33 -0700
Message-ID: <20160311222433.GA2617@Dell>
References: <20160229015333.GA3101@Dell>
 <20160229034616.GA2682@Dell>
 <20160304173044.GA2636@Dell>
 <20160306053103.GA31060@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160306053103.GA31060@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 05, 2016 at 08:31:03PM -0900, Kent Overstreet wrote:
> On Fri, Mar 04, 2016 at 10:30:44AM -0700, Andrea Righi wrote:
> > On Sun, Feb 28, 2016 at 08:46:16PM -0700, Andrea Righi wrote:
> > > On Sun, Feb 28, 2016 at 06:53:33PM -0700, Andrea Righi wrote:
> > > ... 
> > > > I'm using 4.5.0-rc5+, from Linus' git. I'll try to do a git bisect
> > > > later, I'm pretty sure this problem has been introduced recently (i.e.,
> > > > I've never seen this issue with 4.1.x).
> > > 
> > > I confirm, just tested kernel 4.1 and this problem doesn't happen.
> > 
> > Alright, I had some spare time to bisect this problem and I found that
> > the commit that introduced this issue is c66a14d.
> > 
> > So, I tried to revert the commit (with some changes to fix conflicts and
> > ABI changes) and now multipath seems to work fine for me (no hung task).
> 
> Is it hanging on first IO, first large IO, or just randomly?

It's always the very first O_DIRECT I/O, in general the task gets stuck
in do_blockdev_direct_IO().

Thanks,
-Andrea
