From: Nix <nix@esperi.org.uk>
Subject: Re: FailSpare event?
Date: Sat, 13 Jan 2007 18:10:59 +0000
Message-ID: <873b6ere4s.fsf@hades.wkstn.nix>
References: <eo6cn8$5se$1@sea.gmane.org>
	<17830.47341.560158.521091@notabene.brown>
	<200701121534.17618.earny@net4u.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200701121534.17618.earny@net4u.de> (Ernst Herzberg's message of "12 Jan 2007 14:52:32 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: earny@net4u.de
Cc: Neil Brown <neilb@suse.de>, Mike <mikee@mikee.ath.cx>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12 Jan 2007, Ernst Herzberg told this:
> Then every about 60 sec 4 times
>
> event=SpareActive
> mddev=/dev/md3

I see exactly this on both my RAID-5 arrays, neither of which have any
spare device --- nor have any active devices transitioned to spare
(which is what that event is actually supposed to mean).

mdadm-2.6 bug, I fear. I haven't tracked it down yet but will look
shortly: I can't afford to not run mdadm --monitor... odd, that
code hasn't changed during 2.6 development.

-- 
`He accused the FSF of being "something of a hypocrit", which
 shows that he neither understands hypocrisy nor can spell.'
   --- jimmybgood
