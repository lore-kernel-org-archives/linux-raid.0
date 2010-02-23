From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md homehost
Date: Tue, 23 Feb 2010 08:29:32 +0100
Message-ID: <87aav0pfz7.fsf@frosties.localdomain>
References: <20100218032610.GB1991@lapse.rw.madduck.net>
	<1266465801.11568.183.camel@localhost.localdomain>
	<20100218044004.GC5136@lapse.rw.madduck.net>
	<20100218161012.704b43a6@notabene.brown>
	<20100218052145.GA7178@lapse.rw.madduck.net>
	<20100218163448.0d3f3107@notabene.brown>
	<20100219004237.GC25162@lapse.rw.madduck.net>
	<20100219091619.GA2964@lazy.lzy>
	<20100221174007.GB19058@lapse.rw.madduck.net>
	<20100221201304.GB2570@lazy.lzy>
	<20100222091632.GE2641@lapse.rw.madduck.net>
	<1266837111.24834.365.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1266837111.24834.365.camel@localhost.localdomain> (Daniel
	Reurich's message of "Tue, 23 Feb 2010 00:11:51 +1300")
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: martin f krafft <madduck@madduck.net>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, 567468@bugs.debian.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Daniel Reurich <daniel@centurion.net.nz> writes:

>> Could you please put forth the argument for why the homehost must
>> match, and why unconditional auto-assembly is not desirable?
>> Realistically, what problems are we protecting against?
>
> I can think of one or two.  
>
> In the case of network boot, where the kernel and initrd served up via
> tftp, but the required filesystems are per host raid volumes served up
> ala ATAoverEthernet, iSCSI etc storage network.  This could use the boot
> network device MAC or dhcp assigned hostname to as the homehost search
> paramater.  This would of course require someway to tell mdadm how to
> obtain this homehost parameter.  This could work well where different
> groups of hosts using different raid volumes for the root (or other)
> filesystems, each with a MAC group (first 3 or 4 MAC fields) is used to
> identify that groups homehost search parameter.  

To get AoE or iSCSI working you need networking. That means dhcp will
already have run and the hostname be set.

> Another scenario, is a dual boot system that has separate raid volumes
> for the respective root filesystems, along with a separate initrd image
> for each OS.  A system uuid stored in the initrd would work in this case
> for the homehost search parameter.

Or virtualization with raid in the virtual hosts. The host system will
see all the raids of the virtual systems but none of them should be
started.

MfG
        Goswin
