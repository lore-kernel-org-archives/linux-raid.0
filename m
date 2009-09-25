From: Chris Webb <chris@arachsys.com>
Subject: Re: RAID1 assembled broken array
Date: Fri, 25 Sep 2009 11:42:19 +0100
Message-ID: <20090925104219.GG26094@arachsys.com>
References: <h8ophd$n8p$6@ger.gmane.org>
 <9F2F4760-DF0C-4416-89AC-C689177AD4ED@redhat.com>
 <65549e07fd6559855af68b60783213c3.squirrel@neil.brown.name>
 <20090917082528.GO5174@skl-net.de>
 <19132.31575.349988.442763@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19132.31575.349988.442763@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>, Doug Ledford <dledford@redhat.com>, Matthias Urlichs <matthias@urlichs.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Thursday September 17, maan@systemlinux.org wrote:
>
> > BTW: Why are new arrays still created with 0.90 metadata format by
> > default?
> 
> Because I'm a chicken....
> 
> I guess it probably is time ... but to we make the default 1.0, which
> is compatible with people's expectations, to 1.1 which is generally a
> safer approach (you cannot mount a bare device by mistake).

One problem with 1.x metadata formats is that you can't assemble them at
boot time without building an initrd/initramfs containing userspace to put
them together. An md=0,xxx kernel argument only appears to work for 0.90
superblocks. (Would you accept a patch to fix this; it doesn't feel like it
should be particularly hard?)

Another issue with 1.1 and 1.2 metadata is that you can't make a mirror out
of sd*, install a bootloader (e.g. extlinux) on the md, and then boot the
corresponding system. That said, I guess it wouldn't be hard to make a
little 'mbr' that understands the data offset in the md 1.2 container, so if
I'm honest, it's just laziness that keeps me using 0.90 where it works out
of the box without the need to hack any bootloader code or create untidy
partitions just for booting.

Best wishes,

Chris.
