From: Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: RAID-6 support in kernel?
Date: Mon, 3 Jun 2002 16:55:49 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020603165549.A27667@ucw.cz>
References: <Pine.LNX.4.33.0206031020290.30424-100000@mail.pronto.tv> <Pine.GSO.4.21.0206030213510.23709-100000@gecko.roadtoad.net> <20020603113128.C13204@ucw.cz> <3CFB82A0.EB2062AE@daimi.au.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3CFB82A0.EB2062AE@daimi.au.dk>; from kasperd@daimi.au.dk on Mon, Jun 03, 2002 at 04:52:16PM +0200
To: Kasper Dupont <kasperd@daimi.au.dk>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Derek Vadala <derek@cynicism.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Tedd Hansen <tedd@konge.net>, Christian Vik <christian@konge.net>, Lars Christian Nygaard <lars@snart.com>
List-Id: linux-raid.ids

On Mon, Jun 03, 2002 at 04:52:16PM +0200, Kasper Dupont wrote:

> > He was thinking "mirror", not "stripe". Mirror of 2 RAID-5 arrays (would
> > be probably called RAID-15 (when there is a RAID-10 for mirrored stripe
> > arrays)), can withstand any two disks failing anytime.
> 
> It can actually withstand any *three* disks failing anytime.

Yes, you're right.

> > Even more for
> > certain combinations. But it is terribly inefficient.

-- 
Vojtech Pavlik
SuSE Labs
