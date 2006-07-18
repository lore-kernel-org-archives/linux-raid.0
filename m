From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] enable auto=yes by default when using udev
Date: Tue, 18 Jul 2006 15:19:32 +1000
Message-ID: <17596.28516.152402.395214@cse.unsw.edu.au>
References: <20060702224549.GD12733@percy.comedia.it>
	<17576.21342.685662.432117@cse.unsw.edu.au>
	<44AA42F6.8070307@tls.msk.ru>
	<e8dmd5$kek$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mario 'BitKoenig' Holbe on Tuesday July 4
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 4, Mario.Holbe@TU-Ilmenau.DE wrote:
> Michael Tokarev <mjt@tls.msk.ru> wrote:
> > Why to test for udev at all?  If the device does not exist, regardless
> > if udev is running or not, it might be a good idea to try to create it.
> > Because IT IS NEEDED, period.  Whenever the operation fails or not, and
> 
> Perhaps it was just a typo and you damage more if you just create it.
> Typical behaviour is to *not* just create device nodes because they
> don't exist but instead assume administrators know what they do.
> That's why I personally think it's better to rely on administrator's
> decision about automatic creation of device nodes.

Yes, the typo issue is a real one.  But so is the frustration with
devices not appearing where you would expect.

I think I'm leaning towards auto-creating names if they look like
standard names (or are listed in mdadm.conf?), but required
auto=whatever to create anything else.

NeilBrown
