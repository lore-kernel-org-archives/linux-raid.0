From: Christoph Hellwig <hch@infradead.org>
Subject: Re: md software raid
Date: Tue, 27 Oct 2009 23:50:46 -0400
Message-ID: <20091028035046.GA19955@infradead.org>
References: <70ed7c3e0910271747o29e53a69l2b88de8d538284aa@mail.gmail.com> <20091028005303577.NTSS9287@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091028005303577.NTSS9287@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 27, 2009 at 07:52:56PM -0500, Leslie Rhorer wrote:
> 
> > Leslie,
> > 
> > How do you check xfs? xfs_check?
> 
> 	Yes.
> 
> > Why not use xfs_repair -n?
> 
> 	I guess the short answer is, "I didn't know it would make a
> difference".  I take it, then, xfs_repair uses a completely different method
> of scanning for errors than xfs_check, one whihcdoes not require so much
> memory?  I find that a bit surprising.

xfs_repair is a separate program that is actually mainainted.  xfs_check
is deprecated and we'll eventually remove it after porting one
remaining checking pass over to xfs_repair (currently xfs_repair can't
check the freespace btree but only fully rebuild them when in repair
mode)

