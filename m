From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Linux mdadm superblock question.
Date: Fri, 19 Feb 2010 01:04:02 -0800
Message-ID: <4877c76c1002190104x3c801023x3ba2e3c7a11fcdf7@mail.gmail.com>
References: <201002141940.35716.volkerarmin@googlemail.com>
	 <alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
	 <20100217130103.3ca65ef3@notabene.brown>
	 <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com>
	 <4B7BB927.5000305@grumpydevil.homelinux.org>
	 <f73f7ab81002170822j7e61455o6bee33d95c9648a1@mail.gmail.com>
	 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
	 <20100217181016.GA14983@emergent.ellipticsemi.com>
	 <87sk8z9q0h.fsf@frosties.localdomain>
	 <20100218141230.GA26473@emergent.ellipticsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100218141230.GA26473@emergent.ellipticsemi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>, david@lang.hm, Kyle Moffett <kyle@moffetthome.net>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Neil Brown <neilb@suse.de>, Mr. James W
List-Id: linux-raid.ids

I actually much prefer building my own kernel for servers and
higher-end workstations.  I like having all the core drivers needed to
'get running' in there; even if the more delicate but static logic of
how to track down and assemble/unlock the drives is in the initramfs
image.

The only really annoying issue I've had with my custom initramfs
creator is getting it 'chained' by various distros auto-initramfs
update triggers so that it can grab the version of modules that match
a given kernel.  I have several ways in mind to work around that issue
at various steps, but no known userbase to support besides my self and
thus less motivation to work on that task.

Everything else of course works exactly the same as long as the
configuration hasn't changed on the host system.
