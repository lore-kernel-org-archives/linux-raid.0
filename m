From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: A policy frame work for mdadm (incorporating domains and
 hotplug and such)
Date: Thu, 12 Aug 2010 14:53:36 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D16C253F33@irsmsx503.ger.corp.intel.com>
References: <66C59AD0932712458090B447266D638CD69A3E95@irsmsx504.ger.corp.intel.com>
	<20100512070231.17342f29@notabene.brown>	<4BE9D7DC.6000306@intel.com>
	<20100512132624.7a189995@notabene.brown>	<4BEAF416.5050509@intel.com>
	<66C59AD0932712458090B447266D638CD6A81248@irsmsx504.ger.corp.intel.com>
	<4BEC941A.8070508@intel.com>
	<905EDD02F158D948B186911EB64DB3D11E33E9DE@irsmsx503.ger.corp.intel.com>
	<66C59AD0932712458090B447266D638CD6D80FFF@irsmsx504.ger.corp.intel.com>
	<A9DE54D0CD747C4CB06DCE5B6FA2246FDA55FA48@irsmsx504.ger.corp.intel.com>
	<20100629113727.197a2002@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D11F5235D9@irsmsx503.ger.corp.intel.com>
	<4C2B97E3.2080309@intel.com>	<20100701165007.4d0d51f7@notabene.brown>
	<20100708175839.4b3b349e@notabene.brown>
	<66C59AD0932712458090B447266D638CFF927ADD@irsmsx504.ger.corp.intel.com>
 <20100728081805.62d55a67@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100728081805.62d55a67@notabene>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Healey, Douglas D" <douglas.d.healey@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Hi Neil,
We have made most changes in the auto-rebuild and hot-(un)plug code as you suggested.
And we are eager to port our code to your new policy framework.
What is the actual plan about policy framework release? 
Thanks,
Marcin



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Neil Brown
> Sent: Wednesday, July 28, 2010 12:18 AM
> To: Hawrylewicz Czarnowski, Przemyslaw
> Cc: linux-raid@vger.kernel.org; Labun, Marcin; Czarnowska, Anna;
> Ciechanowski, Ed; Healey, Douglas D; Neubauer, Wojciech
> Subject: Re: A policy frame work for mdadm (incorporating domains and
> hotplug and such)
> 
> On Tue, 27 Jul 2010 17:17:46 +0100
> "Hawrylewicz Czarnowski, Przemyslaw"
> <przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> 
> > Hi Neil,
> >
> > I was wondering if there is anything new in this area?
> > Please share your ideas and/or a new code :)
> 
> No, other things have taken priority.  I might get back to it next
> week.
> 
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
