From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH] Fix: Sometimes mdmon throws core dump during reshape
Date: Wed, 7 Sep 2011 06:36:12 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A0175F4@IRSMSX101.ger.corp.intel.com>
References: <20110905103955.4372.52448.stgit@gklab-128-013.igk.intel.com>
 <20110907140759.6ed12d4d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110907140759.6ed12d4d@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, September 07, 2011 6:08 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH] Fix: Sometimes mdmon throws core dump during
> reshape
> 
> On Mon, 05 Sep 2011 12:39:55 +0200 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > Problem was found during reshaping 2 volumes /raid0 and raid5/ in
> container.
> > Sometimes mdmon throws core dump due to NULL pointer exception.
> >
> > Problem occurs in scenario:
> > - managemon: is about spare activation (degraded raid4 volume == raid0
> under takeover)
> > - managemon: detect level change and signals monitor (manage_member()
> calls replace_array())
> > - monitor: detects transition raid4/5->raid0 and sets a->container to
> NULL
> >            to indicate array deactivation
> > - managemon : continues his work and tries to activate spare (a-
> >check_degraded is set).
> >               NULL pointer is passed to metadata handler
> activate_spare()
> >               Core dump is generated.
> >
> > To resolve this situation managemon (after monitor kick) checks again
> > a->container pointer to learn if current array is not to be
> deactivated.
> 
> This looks like it might be the same bug as is fixed by
>      Lukasz Dorau <lukasz.dorau@intel.com>
> in
>   Subject: [PATCH] FIX: Mdmon crashes after changing RAID level from 1
> to 0
> 
> Does that look likely?
> 
> Thanks,
> NeilBrown

It is very rarely problem and I had got single reproduction only with applied patch pointed by you.
To completely solve this problem using Lukasze's patch only, new array monitoring deactivation
should be extended to every case. Container field should never be used for deactivation task.

Do you prefer such approach?


BR
Adam


> 
> 
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  managemon.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> >
> > diff --git a/managemon.c b/managemon.c
> > index d020f82..3540dac 100644
> > --- a/managemon.c
> > +++ b/managemon.c
> > @@ -475,6 +475,12 @@ static void manage_member(struct mdstat_ent
> *mdstat,
> >  		}
> >  	}
> >
> > +	/* we are after monitor kick,
> > +	 * so container field can be cleared - check it again
> > +	 */
> > +	if (a->container == NULL)
> > +		return;
> > +
> >  	/* We don't check the array while any update is pending, as it
> >  	 * might container a change (such as a spare assignment) which
> >  	 * could affect our decisions.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

