From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 01/11] imsm: FIX: Return longer map for failure setting
Date: Wed, 30 Nov 2011 07:56:01 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A054C06@IRSMSX101.ger.corp.intel.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
	<20111124121718.5254.16301.stgit@gklab-128-013.igk.intel.com>
 <CAA9_cmdeSfx6dZVwUZ-00mLfFAi+PPKcGCDLBpB8icA5BS4j6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmdeSfx6dZVwUZ-00mLfFAi+PPKcGCDLBpB8icA5BS4j6g@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
> Behalf Of Dan Williams
> Sent: Wednesday, November 30, 2011 3:31 AM
> To: Kwolek, Adam
> Cc: neilb@suse.de; linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun,
> Marcin
> Subject: Re: [PATCH 01/11] imsm: FIX: Return longer map for failure setting
> 
> On Thu, Nov 24, 2011 at 4:17 AM, Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> > When 2 maps are present, IMSM can use shorter map for setting disk in
> > to degraded state. It can happen that degraded disk can be not present
> > in shorter map.
> > We should use longer map for setting disk in to degraded state.
> 
> I don't understand this patch.  If we are setting a new degraded disk
> migration is idle and the degraded state is set in map[0].
> 
> --
> Dan

This is made for future in case when  support for shrinking will be added.
When second map is longer than first one and degradation occurs on position that is not present in first map. 
It situation should be stored in map also.

BR
Adam
