From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 01/11] imsm: FIX: Return longer map for failure setting
Date: Thu, 1 Dec 2011 07:54:11 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A054E1E@IRSMSX101.ger.corp.intel.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
	<20111124121718.5254.16301.stgit@gklab-128-013.igk.intel.com>
	<CAA9_cmdeSfx6dZVwUZ-00mLfFAi+PPKcGCDLBpB8icA5BS4j6g@mail.gmail.com>
	<79556383A0E1384DB3A3903742AAC04A054C06@IRSMSX101.ger.corp.intel.com>
 <CABE8wwuW3_T07h4=XzdvroXBW0HQnMhQe6CUp262HoMS+FWRuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwuW3_T07h4=XzdvroXBW0HQnMhQe6CUp262HoMS+FWRuw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Williams, Dan J [mailto:dan.j.williams@intel.com]
> Sent: Wednesday, November 30, 2011 4:38 PM
> To: Kwolek, Adam
> Cc: neilb@suse.de; linux-raid@vger.kernel.org; Ciechanowski, Ed; Labu=
n,
> Marcin
> Subject: Re: [PATCH 01/11] imsm: FIX: Return longer map for failure s=
etting
>=20
> On Tue, Nov 29, 2011 at 11:56 PM, Kwolek, Adam <adam.kwolek@intel.com=
>
> wrote:
> >> I don't understand this patch. =A0If we are setting a new degraded=
 disk
> >> migration is idle and the degraded state is set in map[0].
> >>
> >> --
> >> Dan
> >
> > This is made for future in case when =A0support for shrinking will =
be added.
>=20
> If it's for a future unimplemented case then this is not a "FIX".


Agree

>=20
> > When second map is longer than first one and degradation occurs on
> position that is not present in first map.
> > It situation should be stored in map also.
>=20
> What's wrong with using get_imsm_map(dev, 1) for this case?

If second map exists and it is shorter than first one, we will put upda=
te in not used place.
If decision about selecting longer map will be put outside, the answer =
is short: nothing.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
