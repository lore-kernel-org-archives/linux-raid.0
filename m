From: Daniel Sanabria <sanabria.d@gmail.com>
Subject: Re: help please, can't mount/recover raid 5 array
Date: Mon, 11 Feb 2013 16:39:52 +0000
Message-ID: <CAHscji03f0aFu_Or_vgeWJX7pN4JMnw_+9nNABOUo3OrWV3KSA@mail.gmail.com>
References: <CAHscji2-8KaKOA041VykHeA+jCEka5afgEoH=EHVGDak-D4UFg@mail.gmail.com>
	<alpine.DEB.2.00.1302100728130.32644@uplift.swm.pp.se>
	<CAHscji0h5nHUssKi23BMfR=Ek+jSH+vK0odYNWkzrVDf6t18mw@mail.gmail.com>
	<CAHscji1enS+Crp23kMX_6pX-bhrDNZ3-7Lbg2dAOPRtJc_nEhw@mail.gmail.com>
	<51180B96.9020500@turmel.org>
	<CAKHEz2ZKL54iuiDiJiVG8Ec-cJGRnjO_qYM7nF13KQPdKUYikQ@mail.gmail.com>
	<CAHscji0+gvKgWGynAS4XhVeSpJ8AdR95ezLHvcP-wTacce=OXQ@mail.gmail.com>
	<alpine.DEB.2.00.1302111724410.32644@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1302111724410.32644@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sure,

Thanks again Mikael.

Daniel

On 11 February 2013 16:30, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Mon, 11 Feb 2013, Daniel Sanabria wrote:
>
>> Thanks a million Guys !!! I re-created the RAID and fsck it and it's
>> mounting fine now. The array is my /home partition and I can't see any
>> significant losses. But I'm still not sure what happened, I mean what
>> consideration should I take next time I upgrade?
>
>
> First of all: --create --assume-clean is a huge big enormous hammer. It
> shouldn't be used unless absolutely necessary, when all other options are
> exhausted.
>
> I am not aware of any gotchas when upgrading, I have done it numerous times,
> even moved array drives between machines, and it's worked well so far. From
> your information there isn't really any way to tell what happened.
>
> So best way before next upgrade is to save mdadm --examine and hope it works
> properly (it should). If it doesn't, please send an email to the list with
> as much information as possible (mdadm --examine, dmesg etc) and see where
> that leads before using the big hammer.
>
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
