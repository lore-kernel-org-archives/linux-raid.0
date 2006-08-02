From: Luca Berra <bluca@comedia.it>
Subject: Re: let md auto-detect 128+ raid members, fix potential race condition
Date: Wed, 2 Aug 2006 08:47:42 +0200
Message-ID: <20060802064742.GD28815@percy.comedia.it>
References: <ork65veg2y.fsf@free.oliva.athome.lsd.ic.unicamp.br> <20060730124139.45861b47.akpm@osdl.org> <orac6qerr4.fsf@free.oliva.athome.lsd.ic.unicamp.br> <17613.16090.470524.736889@cse.unsw.edu.au> <44CF9221.90902@tmr.com> <orlkq8f8ge.fsf@free.oliva.athome.lsd.ic.unicamp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <orlkq8f8ge.fsf@free.oliva.athome.lsd.ic.unicamp.br>
Sender: linux-raid-owner@vger.kernel.org
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Aug 01, 2006 at 06:32:33PM -0300, Alexandre Oliva wrote:
>Sure enough the LVM subsystem could make things better for one to not
>need all of the PVs in the root-containing VG in order to be able to
>mount root read-write, or at all, but if you think about it, if initrd
it shouldn't need all of the PVs you just need all the pv where the
rootfs is.

>is set up such that you only bring up the devices that hold the actual
>root device within the VG and then you change that, say by taking a
>snapshot of root, moving it around, growing it, etc, you'd be better
>off if you could still boot.  So you do want all of the VG members to
>be around, just in case.
in this case just regenerate the initramfs after modifying the vg that
contains root. I am fairly sure that kernel upgrades are far more
frequent than the addirion of PVs to the root VG.

>Yes, this is an argument against root on LVM, but there are arguments
>*for* root on LVM as well, and there's no reason to not support both
>behaviors equally well and let people figure out what works best for
>them.

No, this is just an argument against misusing root on lvm.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
