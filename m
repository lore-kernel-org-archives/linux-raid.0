From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Broken RAID1 boot arrays
Date: Mon, 10 May 2010 21:44:58 -0500
Message-ID: <4F.55.25297.BA4C8EB4@cdptpa-omtalb.mail.rr.com>
References: <4BE7D639.6080602@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BE7D639.6080602@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Tim Small' <tim@seoss.co.uk>, 'John Robinson' <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On 10/05/10 10:17, John Robinson wrote:
> >
> > Secondly, the idea of grub1 chain-loading grub2 sounds iffy to me; use
> > either grub1 or grub2 but not both.
> 
> This is Debian's upgrade-mechanism for Grub.  It sets up grub1 to give
> you the option of either:
> 
> 1. Chainloading grub2, so that you can verify that it works correctly,
> and then issue the command to remove grub1, an just-use grub2 if you're
> happy with it, or in case there's some problem with grub2.
> 2. Booting the kernel directly from grub1 (then you can remove grub2
> once the system has booted).
> 
> The OP should probably report this as a bug against the
> linux-image-2.6.xx package which they are using in Debian.

	I'm pretty sure it has been reported more than once.  Google brings
up a ton of responses when one searches for the error produced when udev
tries to upgrade and can't because of the old kernel.  I don't recall what
the error is, exactly, because I first ran into it several months ago.  Note
it is only encountered when trying to upgrade from "Lenny" to "Squeeze", not
when loading "Squeeze" directly, but then "Squeeze" is still a testing
distro.  It hasn't been released, yet, and probably won't be for several
more months.  I would expect the problem to be resolved by the time
"Squeeze" enters stable status.

