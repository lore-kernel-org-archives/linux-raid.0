From: Christoph Hellwig <hch@infradead.org>
Subject: Re: "Enhanced" MD code avaible for review
Date: Wed, 17 Mar 2004 19:32:06 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040317193206.A17987@infradead.org>
References: <459805408.1079547261@aslan.scsiguy.com> <4058A481.3020505@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4058A481.3020505@pobox.com>; from jgarzik@pobox.com on Wed, Mar 17, 2004 at 02:18:25PM -0500
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-raid@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 17, 2004 at 02:18:25PM -0500, Jeff Garzik wrote:
> > 	o Allow fully pluggable meta-data modules
>=20
> yep, needed

Well, this is pretty much the EVMS route we all heavily argued against.
Most of the metadata shouldn't be visible in the kernel at all.

> > 	o Improve the ability of MD to auto-configure arrays.
>=20
> hmmmm.  Maybe in my language this means "improve ability for low-leve=
l=20
> drivers to communicate RAID support to upper layers"?

I think he's talking about the deprecated raid autorun feature.  Again
something that is completely misplaced in the kernel.  (=E5gain EVMS li=
ght)

> > 	o Support multi-level arrays transparently yet allow
> > 	  proper event notification across levels when the
> > 	  topology is known to MD.
>=20
> I'll need to see the code to understand what this means, much less=20
> whether it is needed ;-)

I think he mean the broken inter-driver raid stacking mentioned below.
Why do I have to thing of EVMS when for each feature?..

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
