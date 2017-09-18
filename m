From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Mon, 18 Sep 2017 14:57:51 +0100
Message-ID: <59BFD0DF.7070006@youngman.org.uk>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org>
 <871sn78pzt.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/09/17 08:04, Mikael Abrahamsson wrote:
> If we could disable writing to the drives/partitions from regular
> userspace when they're handled by md, that could be some kind of middle
> ground. I guess most tools don't use O_EXCL.

It would make sense to set permissions to read-only, but of course on
Unix root just ignores permissions :-(

Oh for Pr1mos where the only right that couldn't be taken away from the
super-user was the right to set rights :-)

Cheers,
Wol
