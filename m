From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: Known-good LSI PCIe SAS HBAs?
Date: Fri, 13 Nov 2009 18:03:28 +0000
Message-ID: <73e903670911131003i26f25b01xb6671684419d5c51@mail.gmail.com>
References: <73e903670911100854o1b48380apb5b0a86c44ae9dcb@mail.gmail.com>
	<200911110004.31238.tfjellstrom@shaw.ca> <4AFAFC75.3070307@sauce.co.nz>
	<200911111151.09021.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200911111151.09021.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: Richard Scobie <richard@sauce.co.nz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 11, 2009 at 6:51 PM, Thomas Fjellstrom <tfjellstrom@shaw.ca> wrote:
>
> On Wed November 11 2009, Richard Scobie wrote:
> > Thomas Fjellstrom wrote:
> > > Thats the problem he was trying to get away from. the MV8 controller
> > > likes to offline disks when a few smart commands arrive. at least with
> > > the main kernel drivers. But then the main kernel mvsas drivers decide
> > > to give up if you even attempt to start a raid array on them. The
> > > controller locks up and you have to reboot. Most of the time a reboot
> > > even fails when it tries to sync the block devices, so a hard reset is
> > > in order.
> >
> > OK, I did not know the Marvell controller also has a problem with
> > smartmontools.
>
> Given the state of the in kernel drivers, its probably a driver issue.
>

Thanks for the replies, all.

I'll bet it's the driver - it doesn't feel quite right that a random
external command can easily drop drives off the controller, be it
smartmontools or mdadm.

Thomas, I tried sending a private email to Andy Yan. I haven't got a
reply, which kind of isn't surprising in this world of spam. Can I ask
you for a referral - could you send him an email asking him if I can
have the patch and how to test it?

Also, to list-dwellers: I'd greatly appreciate further tips on PCIe SAS HBAs.

Thanks!
