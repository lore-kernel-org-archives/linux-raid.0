From: Andrew Morton <akpm@osdl.org>
Subject: Re: MD Oops on boot with 2.6.2-rc1-mm3
Date: Sun, 25 Jan 2004 20:12:06 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040125201206.246b7f86.akpm@osdl.org>
References: <40146B68.6070007@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <40146B68.6070007@comcast.net>
To: Walt H <waltabbyh@comcast.net>
Cc: linux-kernel@vger.kernel.org, jik@kamens.brookline.ma.us, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Walt H <waltabbyh@comcast.net> wrote:
>
> > There appears to be a dud raid patch in -mm.  It'll be one of the md-*
> > patches.
> > 
> > If you have time, could you work out which one?  Ones to start with might be
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.2-rc1/2.6.2-rc1-mm3/ \
> > broken-out/md-02-preferred_minor-fix.patch
> > 
> > and
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.2-rc1/2.6.2-rc1-mm3/ \
> > broken-out/md-06-allow-partitioning.patch
> > 
> > 
> 
> I had a repeatable oops that sounds identical to what Jonathan
> originally reported. Backing out md-06-allow-partitioning.patch fixed
> the oops at boot for me. Thanks,

Thanks.  md-06 and md-07 are in for a bit of a rethink anyway...
