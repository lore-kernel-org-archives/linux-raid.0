From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: new superblock and raid10 support in mdadm
Date: Tue, 14 Sep 2004 19:01:55 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16710.45955.263778.461212@cse.unsw.edu.au>
References: <1095088590.3713.4.camel@rich>
	<16710.17573.491674.378912@cse.unsw.edu.au>
	<20040914064051.GA28661@middle.of.nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jurriaan on Tuesday September 14
To: Jurriaan <thunder7@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 14, thunder7@xs4all.nl wrote:
> From: Neil Brown <neilb@cse.unsw.edu.au>
> Date: Tue, Sep 14, 2004 at 11:08:53AM +1000
> > A new format is being supported because the old format has problems.
> > One is that it cannot work with devices larger than 2 Gigabytes (and I
> > have had a request from someone who wanted to include such a device in
> > an MD array).
> 
> I presume you mean terabyte, but I'm not sure you don't mean petabyte or
> something else very large?

Yes.  terabyte (2^(32+9) bytes is the max size)
> 
> > The raid10 module is in 2.4.9-rc2 and will be in 2.4.9 when it gets
> > released. 
> 
> 2.6.9 I presume?

You presume correctly.  I type poorly :-)

> >  * near_copies and far_copies must be at least one, and there product is at most
> 
> ----------------------------------------------------------their
> 

Would you believe that I deliberately put in those errors just to see
if anyone actually reads these comments..... no, I wouldn't either.

Thanks,
NeilBrown
