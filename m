From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Tue, 30 Mar 2010 16:47:16 -0700
Message-ID: <e9c3a7c21003301647u3b96be7eyee31a1a94ef8583c@mail.gmail.com>
References: <20100325113543.0e2124c5@notabene.brown>
	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com>
	 <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com>
	 <4BB0ED13.6020507@redhat.com>
	 <e9c3a7c21003291436lb898278i21f988fd5f76bd53@mail.gmail.com>
	 <4BB13830.8070709@redhat.com>
	 <e9c3a7c21003291746o49191295r876c7fef50fe63a5@mail.gmail.com>
	 <4BB2175C.7070201@redhat.com>
	 <905EDD02F158D948B186911EB64DB3D11C584DD2@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D11C584DD2@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On Tue, Mar 30, 2010 at 10:47 AM, Labun, Marcin <Marcin.Labun@intel.com> wrote:
> I understand that there are following defaults:
> - Platform/metadata limitations create default domains
> - metadata handler deliver default actions
> The equivalent configuration line for imsm is:
> DOMAIN path="any" metadata=imsm action=none

I would expect path=<ahci ports> when metadata=imsm

> User could additionally split default domains using spare groups and path keyword.
> For instance for imsm, the default domain area is platform controller.
> If any metadata is server by multiple controllers, each of them creates its own domain.

A single DOMAIN can span several controllers, but only if that does
not violate the 'platform' constraints for that metadata type (which
are always enforced).

> Enable spare disk sharing between containers if they belong to the same domain and have not conflicting spare group assignment. This will allow for spare sharing by default.

Yes, spare sharing by default within the domain and as Doug said
ignore any conflicts with the spare-group identifier i.e. DOMAIN
overrides/supersedes spare-group.

> Additionally, we can consult metadata handlers before moving spares between containers. We can do that by adding another metadata handler function which shall test metadata and controller dependencies (I can imagine that user can define metadata stored domains of spare sharing; controllers (OROM) dependent constrains shall be handled in this function, too).

This really is just a variation of load_super() performed on a
container with an extra disk added to report whether the device is
spare, failed, or otherwise out of sync.

In the imsm case this is load_super_imsm_all() with another disk
(outside of the current container list) to compare against.

--
Dan
