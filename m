From: Nix <nix@esperi.org.uk>
Subject: Re: FailSpare event?
Date: Mon, 15 Jan 2007 20:08:40 +0000
Message-ID: <878xg4dpdj.fsf@hades.wkstn.nix>
References: <eo6cn8$5se$1@sea.gmane.org>
	<17830.47341.560158.521091@notabene.brown>
	<200701121534.17618.earny@net4u.de> <873b6ere4s.fsf@hades.wkstn.nix>
	<87y7o5lkjx.fsf@hades.wkstn.nix>
	<17834.40586.985089.343283@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17834.40586.985089.343283@notabene.brown> (Neil Brown's message of "Mon, 15 Jan 2007 08:20:10 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: earny@net4u.de, Mike <mikee@mikee.ath.cx>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14 Jan 2007, Neil Brown told this:
> A quick look suggests that the following patch might make a
> difference, but there is more to it than that.  I think there are
> subtle differences due to the use of version-1 superblocks.  That
> might be just another one-line change, but I want to make sure first.

Well, that certainly made that warning go away. I don't have any
actually-failed disks, so I can't tell if it would *ever* warn anymore ;)

... actually, it just picked up some monthly array check activity:

Jan 15 20:03:17 loki daemon warning: mdadm: Rebuild20 event detected on md device /dev/md2

So it looks like it works perfectly well now.

(Looking at the code, yeah, without that change it'll never remember
state changes at all!)

One bit of residue from the state before this patch remains on line 352,
where you initialize disc.state and then never use it for anything...

-- 
`He accused the FSF of being "something of a hypocrit", which
 shows that he neither understands hypocrisy nor can spell.'
   --- jimmybgood
