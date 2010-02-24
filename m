From: Neil Brown <neilb@suse.de>
Subject: Re: Bug#567468: md homehost
Date: Thu, 25 Feb 2010 09:23:38 +1100
Message-ID: <20100225092338.5e20f8df@notabene.brown>
References: <20100219004237.GC25162@lapse.rw.madduck.net>
	<20100219091619.GA2964@lazy.lzy>
	<20100221174007.GB19058@lapse.rw.madduck.net>
	<20100221201304.GB2570@lazy.lzy>
	<20100222091632.GE2641@lapse.rw.madduck.net>
	<20100223133028.279e0174@notabene.brown>
	<20100223062700.GB19666@lapse.rw.madduck.net>
	<87635opfwb.fsf@frosties.localdomain>
	<20100223081636.GD19730@lapse.rw.madduck.net>
	<87y6iilqsu.fsf@frosties.localdomain>
	<20100224175257.GA7470@darkside.12.kls.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100224175257.GA7470@darkside.12.kls.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, 567468@bugs.debian.org, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 24 Feb 2010 18:52:57 +0100
"Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE> wrote:

> On Wed, Feb 24, 2010 at 02:13:53PM +0100, Goswin von Brederlow wrote:
> > grub.cfg (grub2) uses UUID for grub itself. But the kernel can be bootet
> > with root=/dev/md0. But in that case where does it get the homehost from
> > and since when does kernel raid autoconfig have a homehost?
> 
> The homehost attribute does only exist with v1 superblocks. And there is
> no in-kernel auto-assembly for v1 superblocks.
> v0.9 superblocks (for which in-kernel auto-assembly is deprecated but
> still provided) have no homehost.
>

Not entirely correct.  The 'homehost' is encoded in the uuid of v0.90
metadata, so it does affect them too.

in-kernel autodetect does not make use of 'homehost' and so does not protect
you from the potential confusions that homehost tries to protect you from.

NeilBrown
