From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: RE: [PATCH 1/2] md: raid5 return new layout in mdstat while
 reshaping
Date: Thu, 22 Jul 2010 09:43:37 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040804E2A4F90@irsmsx503.ger.corp.intel.com>
References: <AcsoxGax1b+/Kg5eR/SJirk+wfgLpw==>
	<BE2BFE91933D1B4089447C64486040804E2A4993@irsmsx503.ger.corp.intel.com>
 <AANLkTikwhea8haXm1Pdu-iQZ50Rtd5qixU2oNa7T2VZc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikwhea8haXm1Pdu-iQZ50Rtd5qixU2oNa7T2VZc@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
> Behalf Of Dan Williams
> Sent: Thursday, July 22, 2010 2:59 AM
> To: Trela, Maciej
> Cc: Neil Brown; Kwolek, Adam; linux-raid@vger.kernel.org
> Subject: Re: [PATCH 1/2] md: raid5 return new layout in mdstat while
> reshaping
> 
> On Wed, Jul 21, 2010 at 4:03 AM, Trela, Maciej <Maciej.Trela@intel.com>
> wrote:
> > From: Maciej Trela <maciej.trela@intel.com>
> >
> > While reshaping, report mdstat algorithm according to the new_layout.
> 
> It's not immediately clear to me why this is needed?  The md/layout
> attribute in sysfs shows the new_layout during reshape if userspace
> forgets what it changed (should also be recorded in the metadata).  If
> it is needed then spell that out in the commit message.
> 

Yes, you are right.
We can definitely read the new layout from sysfs.
Thanks.

