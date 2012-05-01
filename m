From: Brian Candler <B.Candler@pobox.com>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Tue, 1 May 2012 10:45:08 +0100
Message-ID: <20120501094508.GA24134@nsrc.org>
References: <4F9AFBC6.7070803@weboperative.com>
 <20120428080355.70585026@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120428080355.70585026@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Apr 28, 2012 at 08:03:55AM +1000, NeilBrown wrote:
> I'm afraid you've been bitten by a rather nasty bug which is present in 3.3
> and got back ported to some -stable kernel.  The fix has been submitted and
> should be appearing in -stable kernels soon (maybe already).

Do you happen to know if this bug was present in ubuntu 11.10, kernel
versions 3.0.0-15-server or 3.0.0-16-server ?

I saw failures to assemble RAID6 arrays after unclean shutdowns on both of
these, just in test environments.  If it happens again I'll send mdadm
--examine output. I just tried to replicate it and failed :-(

Regards,

Brian.
