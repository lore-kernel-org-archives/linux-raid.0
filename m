From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: [PATCH md 0 of 4] Introduction
Date: Wed, 09 Mar 2005 03:27:08 -0600
Message-ID: <1110360427.6552.9.camel@langvan2.homenetwork>
References: <20050308165021.3745.patches@notabene>
	 <20050307221006.16806431.akpm@osdl.org>
	 <16942.27336.208536.334897@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <16942.27336.208536.334897@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Tue, 2005-03-08 at 21:17, Neil Brown wrote:
> On Monday March 7, akpm@osdl.org wrote:
> > NeilBrown <neilb@cse.unsw.edu.au> wrote:
> > >
> > > The first two are trivial and should apply equally to 2.6.11
> > > 
> > >  The second two fix bugs that were introduced by the recent 
> > >  bitmap-based-intent-logging patches and so are not relevant
> > >  to 2.6.11 yet. 
> > 
> > The changelog for the "Fix typo in super_1_sync" patch doesn't actually say
> > what the patch does.  What are the user-visible consequences of not fixing
> > this?
> 
> -------
> This fixes possible inconsistencies that might arise in a version-1 
> superblock when devices fail and are removed.
> 
> Usage of version-1 superblocks is not yet widespread and no actual
> problems have been reported.
> --------

EVMS 2.5.1 (http://evms.sf.net) has provided support for creation of MD
arrays using version-1 superblock.  Some of EVMS users actually tried to
use this new functionality.  You probably remember I posted a problem
and a patch to fix version-1 superblock update code.

We will continue to test and will report any problems.

--
Regards,
Mike T.


