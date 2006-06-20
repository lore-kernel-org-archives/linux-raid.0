From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH*2] mdadm works with uClibc from SVN
Date: Wed, 21 Jun 2006 00:03:16 +0100
Message-ID: <87u06fmnuz.fsf@hades.wkstn.nix>
References: <87wtbbjxd4.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wtbbjxd4.fsf@hades.wkstn.nix> (nix@esperi.org.uk's message of "20 Jun 2006 23:06:22 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20 Jun 2006, nix@esperi.org.uk suggested tentatively:
> Imagine my surprise when I found that it was effectively guaranteed to
> crash: map_dev() in util.c is stubbed out for uClibc builds, and
> returns -1 at all times.

Um, that is, returns NULL. Obviously.

-- 
`NB: Anyone suggesting that we should say "Tibibytes" instead of
 Terabytes there will be hunted down and brutally slain.
 That is all.' --- Matthew Wilcox
