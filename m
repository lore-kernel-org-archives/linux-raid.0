From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: RE: [PATCH 0/2] md: migrations for external metadata
Date: Thu, 22 Jul 2010 09:30:22 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040804E2A4F50@irsmsx503.ger.corp.intel.com>
References: <AcsoxEzgiDLRi6q6TBaV0DSWmACMtg==>
	<BE2BFE91933D1B4089447C64486040804E2A498E@irsmsx503.ger.corp.intel.com>
 <AANLkTikYzfhHb2eWenDurV9_NueHSTquJuspeUx8A-fi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikYzfhHb2eWenDurV9_NueHSTquJuspeUx8A-fi@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
> Behalf Of Dan Williams
> Sent: Wednesday, July 21, 2010 6:37 PM
> To: Trela, Maciej
> Cc: Neil Brown; Kwolek, Adam; linux-raid@vger.kernel.org
> Subject: Re: [PATCH 0/2] md: migrations for external metadata
> 
> Hi Maciej,
> 
> On Wed, Jul 21, 2010 at 4:03 AM, Trela, Maciej <Maciej.Trela@intel.com>
> wrote:
> > Hello Neil,
> > I'm sending the patches for external metadata migrations.
> > Both md/mdadm patches are based on OLCE patches sent by
> > Adam Kwolek some time ago.
> 
> ...which Adam and I are still in the process of reworking.  I'll take
> a look at these but just note that the baseline may yet change.
> 

Hello Dan,

Yes, I'm aware of that but I hope those changes in takeover and OLCE
will not cause any dramatic changes to checkpointing patches.

I wanted to make sure that the code is heading in the right direction
and will not require serious architectural changes in the future.
(especially mdadm-mdmon-md communication for backups)

I appreciate any feedback as usual! :))

Thanks,
Maciek.

