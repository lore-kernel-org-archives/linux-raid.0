From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Mon, 12 Oct 2009 21:33:52 -0400
Message-ID: <20091013013352.GA24869@infradead.org>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Oct 12, 2009 at 05:58:20PM +0100, mark delfman wrote:
> Hi... in recent tests we are seeing a 50% drop in performance from
> XFS>MD on a 2.6.30 kernel (compared to a 2.6.28 kernel)
> 
> In short:  Performance to MD0 direct = circa 1.7GBsec (see below), via
> xfs circa 850MBsec.  On previous system (2.6.28) there was no drop in
> performance (in fact often an increase).
> 
> I am hopefully that this is simply a matter of barriers etc on the
> newer kernel and MD, but we have tried many options and nothing seems
> to change this so would very much appreciate advice.

Did barrier support for RAID0 got introduced in 2.6.30?

