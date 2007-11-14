From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [stable] [PATCH 000 of 2] md: Fixes for md in 2.6.23
Date: Tue, 13 Nov 2007 20:36:05 -0700
Message-ID: <e9c3a7c20711131936t3c5f858cm8937b24d97fe998c@mail.gmail.com>
References: <20071022171426.31103.patches@notabene>
	 <20071114002214.GA31928@kroah.com> <20071114002308.GB31928@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071114002308.GB31928@kroah.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, M@suse.de, linux-kernel@vger.kernel.org, Stable <stable@kernel.org>
List-Id: linux-raid.ids

On Nov 13, 2007 5:23 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Nov 13, 2007 at 04:22:14PM -0800, Greg KH wrote:
> > On Mon, Oct 22, 2007 at 05:15:27PM +1000, NeilBrown wrote:
> > >
> > > It appears that a couple of bugs slipped in to md for 2.6.23.
> > > These two patches fix them and are appropriate for 2.6.23.y as well
> > > as 2.6.24-rcX
> > >
> > > Thanks,
> > > NeilBrown
> > >
> > >  [PATCH 001 of 2] md: Fix an unsigned compare to allow creation of bitmaps with v1.0 metadata.
> > >  [PATCH 002 of 2] md: raid5: fix clearing of biofill operations
> >
> > I don't see these patches in 2.6.24-rcX, are they there under some other
> > subject?
>
> Oh nevermind, I found them, sorry for the noise...
>

Careful, it looks like you cherry picked commit 4ae3f847 "md: raid5:
fix clearing of biofill operations" which ended up misapplied in
Linus' tree,  You should either also pick up def6ae26 "md: fix
misapplied patch in raid5.c" or I can resend the original "raid5: fix
clearing of biofill operations."

The other patch for -stable "raid5: fix unending write sequence" is
currently in -mm.

> greg k-h

Regards,
Dan
