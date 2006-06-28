From: "bart@ardistech.com" <bart@ardistech.com>
Subject: Re: Ok to go ahead with this setup?
Date: Wed, 28 Jun 2006 08:23:09 +0200
Message-ID: <44A2204D.D21130B7@ardistech.com>
References: <bb145bd20606221008p131d4daem289a6b9300757c66@mail.gmail.com>
	 <62b0912f0606221104q2f47f574i86441efed5831957@mail.gmail.com>
	 <bb145bd20606221250y147d0a0bk1e371a3078adc09e@mail.gmail.com>
	 <62b0912f0606221511p74a78ca5id4b5d3f870258815@mail.gmail.com> <Pine.LNX.4.64.0606272241040.26384@router.windsormachine.com>
Reply-To: bart@ardistech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Dresser <mdresser_l@windsormachine.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Dresser wrote:
> 
> On Fri, 23 Jun 2006, Molle Bestefich wrote:
> 
> > Christian Pernegger wrote:
> >> Anything specific wrong with the Maxtors?
> >
> > I'd watch out regarding the Western Digital disks, apparently they
> > have a bad habit of turning themselves off when used in RAID mode, for
> > some reason:
> > http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/1980/
> 
> The MaxLine III's (7V300F0) with VA111630/670 firmware currently timeout
> on a weekly or less basis.. I'm still testing VA111680 on a 15x300 gig
> array
> 
We also see similar problem on Maxtor 6V250F0 drives: they 'crash' randomly at
a weeks timescale. Only way to get them back is by power cycling. Tried both
SuperMicro SATA card (Marvell chip) and Promise Fastrak, firmware updates from
Maxtor did not fix it yet. We were already forced to exchange all drives at
a customer because he does not want to use Maxtor's anymore. Neither do we :(

	Bart
