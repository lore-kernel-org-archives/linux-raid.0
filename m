From: Frank van Maarseveen <frankvm@xs4all.nl>
Subject: Re: RAID 5 questions
Date: Sun, 1 Aug 2004 12:24:30 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040801102430.GC28625@janus>
References: <1091325475.2374.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1091325475.2374.11.camel@localhost>
To: Ninti Systems <office@ninti.com.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Aug 01, 2004 at 11:27:56AM +0930, Ninti Systems wrote:
> 
> Q1: Is it true that Linux can't/shouldn't boot off a RAID 5 array?

From software RAID it can't.

USB storage devices (memory stick) are incredibly useful for this --
I've even booted a webserver from a digital camera ;-). The only catch
may be the latency of the USB code when you don't want to use initrd:
The kernel panics (no root dev) because it takes noticeable time before
the kernel sees an USB storage device. But there are several tiny patches
for this, it's merely a nuisance.

-- 
Frank
