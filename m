From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md ] Fix BUG in raid5 resync code.
Date: Tue, 8 Jun 2004 09:01:21 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16580.62401.182339.62963@cse.unsw.edu.au>
References: <20040604163651.7946.patches@notabene>
	<E1BW8LY-00024X-F7@notabene.cse.unsw.edu.au>
	<1086600795.40c4365bca98b@www.tastycake.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nick Maynard on Monday June 7
To: Nick Maynard <nick.maynard@alumni.doc.ic.ac.uk>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 7, nick.maynard@alumni.doc.ic.ac.uk wrote:
> Hi Neil,
> 
> > Today I lucked upon a bug in raid5 that appears to have been there
> > since 2.4.0 and earlier.   I guess it doesn't trigger very often.
> >
> > 2.4 will need a similar fix.
> <snip>
> 
> Do you have any idea when we can expect this fix ported to 2.4?

It is in the linux-2.4 bk repository:
http://linux.bkbits.com:8080/linux-2.4/cset@40c31f28n8OMv8RVMIjLPDkq3APFWA?nav=index.html|ChangeSet@-2d

so it will be in the next (pre)release.

> Also, when the 2.6 kernel series will include it?

It is in Linux 2.6.7-rc3
http://linux.bkbits.com:8080/linux-2.5/cset@40c209c4CQWb5gFyz-f96tQ8QaBv-A?nav=index.html|ChangeSet@-3d

NeilBrown
