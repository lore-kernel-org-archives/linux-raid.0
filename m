From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: RE: [PATCH] imsm: fix: does not allow to use invalid chunk size
Date: Tue, 6 Dec 2011 15:49:48 +0000
Message-ID: <74AAB12B538EC94087A0D16AFDFC24F405507F@IRSMSX102.ger.corp.intel.com>
References: <20111125121204.662.4111.stgit@linux.site>
 <20111206115613.77736d93@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111206115613.77736d93@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Tuesday, December 06, 2011 1:56 AM
> To: Hawrylewicz Czarnowski, Przemyslaw
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Labun, Marcin;
> Ciechanowski, Ed
> Subject: Re: [PATCH] imsm: fix: does not allow to use invalid chunk size
> 
> On Fri, 25 Nov 2011 13:12:04 +0100 Przemyslaw Czarnowski
> <przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> 
> > Only least significant bit of chunk size provided by user has been
> > used in test with OROM capabilities. This way user could pass value
> > which is not a power of 2.
> >
> > Signed-off-by: Przemyslaw Czarnowski
> > <przemyslaw.hawrylewicz.czarnowski@intel.com>
> > ---
> >  platform-intel.h |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> >
> > diff --git a/platform-intel.h b/platform-intel.h index
> > 6c094d7..99450ba 100644
> > --- a/platform-intel.h
> > +++ b/platform-intel.h
> > @@ -124,11 +124,13 @@ static inline int imsm_orom_has_raid5(const
> > struct imsm_orom *orom)  static inline int imsm_orom_has_chunk(const
> > struct imsm_orom *orom, int chunk)  {
> >  	int fs = ffs(chunk);
> > +	int orom_chunk_bit;
> >
> >  	if (!fs)
> >  		return 0;
> >  	fs--; /* bit num to bit index */
> > -	return !!(orom->sss & (1 << (fs - 1)));
> > +	orom_chunk_bit = (orom->sss & (1 << (fs - 1)));
> > +	return orom_chunk_bit && 1 << orom_chunk_bit == chunk;
> >  }
> >
> >
> 
> applied, thanks.
> 
> However it feels a bit clumsy, though maybe that is just me.
> I would use a separate explicit test for "is a power of 2".
> ie.
> 
>   if (chunk & (chunk-1))
>         return 0; /* not a power of 2 */
>   fs = ffs(chunk);
>   return !!(orom->sss & (1 << (fs-2)));
> 
You're right,

Please get the one from the bottom of this email then... It is based on your input (~90%) so sign it up and ship:)
Moreover previous one is not the right one I wanted to send out...

--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski

> or something like that.
> 
> NeilBrown

-- 
Subject: [PATCH] fix: imsm: validate strip size - tuned up

Neil's proposal seems more reasonable and shows what is really going on
here.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 platform-intel.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/platform-intel.h b/platform-intel.h
index 99450ba..c997f1b 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -124,13 +124,12 @@ static inline int imsm_orom_has_raid5(const struct imsm_orom *orom)
 static inline int imsm_orom_has_chunk(const struct imsm_orom *orom, int chunk)
 {
        int fs = ffs(chunk);
-       int orom_chunk_bit;
-
        if (!fs)
                return 0;
        fs--; /* bit num to bit index */
-       orom_chunk_bit = (orom->sss & (1 << (fs - 1)));
-       return orom_chunk_bit && 1 << orom_chunk_bit == chunk;
+       if (chunk & (chunk-1))
+               return 0; /* not a power of 2 */
+       return !!(orom->sss & (1 << (fs - 1)));
 }
 
 
-- 
1.7.7
