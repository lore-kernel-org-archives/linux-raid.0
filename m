From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 0 of 4] Introduction
Date: Wed, 9 Mar 2005 14:17:28 +1100
Message-ID: <16942.27336.208536.334897@cse.unsw.edu.au>
References: <20050308165021.3745.patches@notabene>
	<20050307221006.16806431.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Andrew Morton on Monday March 7
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 7, akpm@osdl.org wrote:
> NeilBrown <neilb@cse.unsw.edu.au> wrote:
> >
> > The first two are trivial and should apply equally to 2.6.11
> > 
> >  The second two fix bugs that were introduced by the recent 
> >  bitmap-based-intent-logging patches and so are not relevant
> >  to 2.6.11 yet. 
> 
> The changelog for the "Fix typo in super_1_sync" patch doesn't actually say
> what the patch does.  What are the user-visible consequences of not fixing
> this?

-------
This fixes possible inconsistencies that might arise in a version-1 
superblock when devices fail and are removed.

Usage of version-1 superblocks is not yet widespread and no actual
problems have been reported.
--------
> 
> 
> Is the bitmap stuff now ready for Linus?

I agree with Paul - not yet.
I'd also like to get a bit more functionality in before it goes to
Linus, as the functionality may necessitate in interface change (I'm
not sure).
Specifically, I want the bitmap to be able to live near the superblock
rather than having to be in a file on a different filesystem.

NeilBrown
