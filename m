From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 10/13] FIX: Cannot unmount array after reshape
Date: Wed, 12 Jan 2011 15:12:37 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176E1AD34@irsmsx503.ger.corp.intel.com>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
	<20110110112848.10776.61232.stgit@gklab-128-013.igk.intel.com>
 <20110112155311.43fb2ed2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112155311.43fb2ed2@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, January 12, 2011 5:53 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 10/13] FIX: Cannot unmount array after reshape
> 
> On Mon, 10 Jan 2011 12:28:48 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > After reshape array remains blocked (i.e. cannot be umounted) due to
> suspend_lo
> > sysfs entry setting.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> 
> I think I have address this issues elsewhere in the code.
> 
> Thanks,
> NeilBrown

I agree, it is addressed now.

Thanks 
Adam

> 
> > ---
> >
> >  Grow.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 6b2889e..f083ba5 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -2026,6 +2026,7 @@ static int reshape_array(char *container, int
> fd, char *devname,
> >  				unsigned long long current_size = 0;
> >  				unsigned long long new_size =
> >  					info2->custom_array_size/2;
> > +				unsigned long long suspend_value;
> >
> >  				if (sysfs_get_ll(sra,
> >  						 NULL,
> > @@ -2043,6 +2044,13 @@ static int reshape_array(char *container, int
> fd, char *devname,
> >  					dprintf(" from %llu to %llu.\n",
> >  						current_size, new_size);
> >  				}
> > +				/* manage suspend_* entries
> > +				 * set suspend_lo to suspend_hi value
> > +				 * to unblock array
> > +				 */
> > +				sysfs_get_ll(sra, NULL, "suspend_hi",
> &suspend_value);
> > +				sysfs_set_num(sra, NULL, "suspend_lo",
> suspend_value);
> > +
> >  				sysfs_free(info2);
> >  			}
> >  		}

