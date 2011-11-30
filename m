From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 01/11] imsm: FIX: Return longer map for failure setting
Date: Wed, 30 Nov 2011 07:37:34 -0800
Message-ID: <CABE8wwuW3_T07h4=XzdvroXBW0HQnMhQe6CUp262HoMS+FWRuw@mail.gmail.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
	<20111124121718.5254.16301.stgit@gklab-128-013.igk.intel.com>
	<CAA9_cmdeSfx6dZVwUZ-00mLfFAi+PPKcGCDLBpB8icA5BS4j6g@mail.gmail.com>
	<79556383A0E1384DB3A3903742AAC04A054C06@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A054C06@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

On Tue, Nov 29, 2011 at 11:56 PM, Kwolek, Adam <adam.kwolek@intel.com> =
wrote:
>> I don't understand this patch. =A0If we are setting a new degraded d=
isk
>> migration is idle and the degraded state is set in map[0].
>>
>> --
>> Dan
>
> This is made for future in case when =A0support for shrinking will be=
 added.

If it's for a future unimplemented case then this is not a "FIX".

> When second map is longer than first one and degradation occurs on po=
sition that is not present in first map.
> It situation should be stored in map also.

What's wrong with using get_imsm_map(dev, 1) for this case?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
