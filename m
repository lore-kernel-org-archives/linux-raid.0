From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 13 Oct 2009 18:52:41 -0400
Message-ID: <20091013225241.GA32197@infradead.org>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com> <20091013013352.GA24869@infradead.org> <66781b10910130406s4119985fg5db7679a2e9fd4f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <66781b10910130406s4119985fg5db7679a2e9fd4f2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Oct 13, 2009 at 12:06:24PM +0100, mark delfman wrote:
> A little more information which I ?think? seems to point at MD.....
> 
> Creating an EXT3 FS on an MD RAID also shows a circa 50% performance drop.
> We have tried a multitude of RAID options (raid6/0 various chunks etc).
> 
> Using a hardware based raid XFS / EXT3 shows no performance drop
> (although the hardware raid is significantly slower than MD in the
> first place)
> 
> We are happy to keep testing and offering anything that could be
> useful, we are just a little stuck thinking of anything else to do....

Can you test with conv=direct added to the dd command lines?  If that
shows the problems too it's probably writeback-related.  If not the
problems must be somewhere lower in the stack.
