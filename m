From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: /dev/md* Device Files
Date: Thu, 27 Jan 2005 10:21:51 +1100
Message-ID: <16888.9743.543953.61504@cse.unsw.edu.au>
References: <Pine.LNX.4.61.0501251445420.6553@electra.rsc.raytheon.com>
	<Pine.LNX.4.56.0501260726100.12589@lion.drogon.net>
	<200501260841.59090.andrew@walrond.org>
	<Pine.LNX.4.61.0501261059490.13740@electra.rsc.raytheon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Steve Witt on Wednesday January 26
Sender: linux-raid-owner@vger.kernel.org
To: Steve Witt <sawitt@electra.rsc.raytheon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 26, sawitt@electra.rsc.raytheon.com wrote:
> > A useful trick I discovered yesterday: Add --auto to your mdadm commandline
> > and it will create the device for you if it is missing :)
> >
> 
> Well, it seems that this machine is using the udev scheme for managing 
> device files. I didn't realize this as udev is new to me, but I probably 
> should have mentioned the kernel version (2.6.8) I was using. So I need to 
> research udev and how one causes devices to be created, etc.

Beware.... udev has an understanding of how device files are meant to
work which is quite different from how md actually works.

udev thinks that devices should appear in /dev after the device is
actually known to exist in the kernel.  md needs a device to exist in
/dev before the kernel can be told that it exists.

This is one of the reasons that --auto was added to mdadm - to bypass
udev.

NeilBrown
