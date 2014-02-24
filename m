From: Caspar Smit <c.smit@truebit.nl>
Subject: Re: mdadm won't remove drive from array
Date: Mon, 24 Feb 2014 14:46:53 +0100
Message-ID: <CAKFseUNtuncgwF=WxLwdd0j2eYNGjG_HS3xtSXyiLjHEAhyptQ@mail.gmail.com>
References: <CAKFseUP0_Y3ZuBKKrTD6WPCRoYraKk4+3sogxmbXQwikh2Wi=g@mail.gmail.com>
	<alpine.DEB.2.02.1402241203510.747@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1402241203510.747@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mikael,

# mdadm --manage /dev/md5 --remove /dev/sde
mdadm: cannot find /dev/sde: No such file or directory

# mdadm --manage /dev/md5 --remove detached
<no output>

So this doesn't make any difference.

Kind regards,
Caspar Smit

2014-02-24 12:05 GMT+01:00 Mikael Abrahamsson <swmike@swm.pp.se>:
> On Mon, 24 Feb 2014, Caspar Smit wrote:
>
>> #mdadm --remove /dev/md5 /dev/sde
>> mdadm: cannot find /dev/sde: No such file or directory
>
>
> Accordig to mdadm manpage the syntax is:
>
> mdadm [mode] <raiddevice> [options] <component-devices>
>
> Could you please verify if "mdadm --manage /dev/md5 --remove /dev/sde"
>
> gives the same behaviour.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
