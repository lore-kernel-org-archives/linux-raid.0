From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: mdadm --assemble weirdness?
Date: Tue, 28 Nov 2006 20:06:41 -0800
Message-ID: <456D0751.80507@ucolick.org>
References: <1162293818.32109.113.camel@kenny>	<17735.14472.835153.186432@cse.unsw.edu.au>	<456CE109.7000202@ucolick.org> <17772.60765.661612.780701@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17772.60765.661612.780701@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
>
> Weird...
>
> What version of mdadm?
>
> Can you show us "mdadm --examine" of a couple of devices?
>
> Any kernel logs while this is happening?
>   
I just got the LATEST off of your website, whatever the number was. I
got the array running, i noticed that in the dmesg from booting it said
something about "kicking non-fresh drive sdxyz" so I did a --assemble
--scan --force and then re-added the final drive which got the array
back to syncing. I would have prefered not to resync but whatever. The
strange thing is how they came to be non-fresh, these were the drives
that had changed controller. They were always there and I never did
anything to the array apart from trying to assemble it.

If I try to assemble an array and it can only find part of the devices,
do those devices that are found have their superblocks updated before
the assemble is rejected? If that's the case and I try again, the
missing drives will be "non-fresh" even though nothing was ever done.
That's the only cause I can imagine...

cheers,

/Patrik

