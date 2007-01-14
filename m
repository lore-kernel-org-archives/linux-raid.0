From: Nix <nix@esperi.org.uk>
Subject: Re: FailSpare event?
Date: Sun, 14 Jan 2007 15:01:06 +0000
Message-ID: <87y7o5lkjx.fsf@hades.wkstn.nix>
References: <eo6cn8$5se$1@sea.gmane.org>
	<17830.47341.560158.521091@notabene.brown>
	<200701121534.17618.earny@net4u.de> <873b6ere4s.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <873b6ere4s.fsf@hades.wkstn.nix> (nix@esperi.org.uk's message of "13 Jan 2007 18:25:19 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: earny@net4u.de
Cc: Neil Brown <neilb@suse.de>, Mike <mikee@mikee.ath.cx>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13 Jan 2007, nix@esperi.org.uk uttered the following:
> mdadm-2.6 bug, I fear. I haven't tracked it down yet but will look
> shortly: I can't afford to not run mdadm --monitor... odd, that
> code hasn't changed during 2.6 development.

Whoo! Compile Monitor.c without optimization and the problem goes away.

Hunting: maybe it's a compiler bug (anyone not using GCC 4.1.1 seeing
this?), maybe mdadm is tripping undefined behaviour somewhere...

-- 
`He accused the FSF of being "something of a hypocrit", which
 shows that he neither understands hypocrisy nor can spell.'
   --- jimmybgood
