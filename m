From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/3] Assemble imsm spares in matching domain only
Date: Wed, 5 Jan 2011 13:36:57 +1100
Message-ID: <20110105133657.42864b56@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E5CFBA0@irsmsx504.ger.corp.intel.com>
	<20101226222252.1255c6a9@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010E759F48@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E759F48@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Tue, 4 Jan 2011 14:04:13 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> 
> 
> > -----Original Message-----
> > From: Neil Brown [mailto:neilb@suse.de]
> > Sent: Sunday, December 26, 2010 12:23 PM
> > To: Czarnowska, Anna
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Hawrylewicz Czarnowski, Przemyslaw; Labun, Marcin; Neubauer, Wojciech
> > Subject: Re: [PATCH 2/3] Assemble imsm spares in matching domain only
> > 
> > 
> > Thanks for these three.
> > 
> > I have applied the first,
> > applied the seconds with a couple of changes as mentioned below,
> > but I haven't applied the first.  I don't like the fact that knowledge
> > about
> > imsm is explicitly hard-coded into mdadm.c  All explicit knowledge
> > about imsm
> > should be in super-intel.c...
> > 
> > I think you can make this work by adding some code in to Assemble()
> > just near:
> > 	/* Now reject spares that don't match domains of identified
> > members */
> > 
> > at that point, if (!st  || !st->sb), then we could include all those
> > spares
> > which have ->used == 3.
> > i.e. when there are now more arrays to be found, all the spares get
> > included
> > into one last array.
> 
> I have implemented it this way but:
> (!st || !st->sb) does not necessarily mean we are assembling "last" array.
> This also happens when we find no devices for an array from config file.
> So if the first array is missing we take all spares into spare-container
> and they don't have a chance to be matched with other arrays.
> Should we ignore this case as a bad config?

I think we should only automatically gather the spares when auto_assem is
true.
So the condition would be
    if (auto_assem && (!st || !st->sb))

> 
> With auto assembly if we have this condition it means we can take all spares
> that did not match anything before.
> This is what we want but there is another problem: we do not attempt auto assembly
> if we manage to assemble anything from config file. 
> This means that when there is a good config file then
> only the spares matching some array will be assembled.
> We will not come back for the remaining ones.
> 
> If mdadm.c is a bad place to force spares assembly then maybe it makes sense
> to add an ARRAY line with uuid=0 as last array in config?
> This would take care of spares that have different domains than all arrays. 

Yes, I think having an array with uuid=0 to collect all the remaining spares
seems like a good idea.
It may turn out not to work quite the way we want, but I think we should try
it an get some experience with how well it works.  I think it is at least
close to the correct solution.

Thanks,

NeilBrown


