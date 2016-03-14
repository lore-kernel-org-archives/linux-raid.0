From: Shaohua Li <shli@kernel.org>
Subject: Re: multipath: I/O hanging forever
Date: Mon, 14 Mar 2016 11:16:08 -0700
Message-ID: <20160314181608.GA10436@kernel.org>
References: <20160229015333.GA3101@Dell>
 <20160229034616.GA2682@Dell>
 <20160304173044.GA2636@Dell>
 <20160306053103.GA31060@kmo-pixel>
 <20160311222433.GA2617@Dell>
 <20160312094723.7c6a4ff4@tom-T450>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160312094723.7c6a4ff4@tom-T450>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Andrea Righi <righi.andrea@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 12, 2016 at 09:47:23AM +0800, Ming Lei wrote:
> On Fri, 11 Mar 2016 15:24:33 -0700
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
> > On Sat, Mar 05, 2016 at 08:31:03PM -0900, Kent Overstreet wrote:
> > > On Fri, Mar 04, 2016 at 10:30:44AM -0700, Andrea Righi wrote:
> > > > On Sun, Feb 28, 2016 at 08:46:16PM -0700, Andrea Righi wrote:
> > > > > On Sun, Feb 28, 2016 at 06:53:33PM -0700, Andrea Righi wrote:
> > > > > ... 
> > > > > > I'm using 4.5.0-rc5+, from Linus' git. I'll try to do a git bisect
> > > > > > later, I'm pretty sure this problem has been introduced recently (i.e.,
> > > > > > I've never seen this issue with 4.1.x).
> > > > > 
> > > > > I confirm, just tested kernel 4.1 and this problem doesn't happen.
> > > > 
> > > > Alright, I had some spare time to bisect this problem and I found that
> > > > the commit that introduced this issue is c66a14d.
> > > > 
> > > > So, I tried to revert the commit (with some changes to fix conflicts and
> > > > ABI changes) and now multipath seems to work fine for me (no hung task).
> > > 
> > > Is it hanging on first IO, first large IO, or just randomly?
> > 
> > It's always the very first O_DIRECT I/O, in general the task gets stuck
> > in do_blockdev_direct_IO().
> 
> I can reproduce the issue too, and looks it is a MD issue instead of block.
> Andrea, could you try the following patch to see if it can fix your issue?
> 
> ---
> From 43fc9c221e53c64f2df7c100c77cc25c4a98c607 Mon Sep 17 00:00:00 2001
> From: Ming Lei <ming.lei@canonical.com>
> Date: Sat, 12 Mar 2016 09:29:40 +0800
> Subject: [PATCH] md: multipath: don't hardcopy bio in .make_request path
> 
> Inside multipath_make_request(), multipath maps the incoming
> bio into low level device's bio, but it is totally wrong to
> copy the bio into mapped bio via '*mapped_bio = *bio'. For
> example, .__bi_remaining is kept in the copy, especially if
> the incoming bio is chained to via bio splitting, so .bi_end_io
> can't be called for the mapped bio at all in the completing path
> in this kind of situation.
> 
> This patch fixes the issue by using clone style.

Applied, thanks! Looks this issue exists since immutable bio is introduced, but
triggered recently. Will add to stable too.

Thanks,
Shaohua
