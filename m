From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mdadm won't remove drive from array
Date: Mon, 24 Feb 2014 12:05:13 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1402241203510.747@uplift.swm.pp.se>
References: <CAKFseUP0_Y3ZuBKKrTD6WPCRoYraKk4+3sogxmbXQwikh2Wi=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKFseUP0_Y3ZuBKKrTD6WPCRoYraKk4+3sogxmbXQwikh2Wi=g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 24 Feb 2014, Caspar Smit wrote:

> #mdadm --remove /dev/md5 /dev/sde
> mdadm: cannot find /dev/sde: No such file or directory

Accordig to mdadm manpage the syntax is:

mdadm [mode] <raiddevice> [options] <component-devices>

Could you please verify if "mdadm --manage /dev/md5 --remove /dev/sde"

gives the same behaviour.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
