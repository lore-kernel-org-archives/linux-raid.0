From: "NeilBrown" <neilb@suse.de>
Subject: Re: RAID-5 creation crashes when files system installed while
     recovery going on
Date: Wed, 24 Jun 2009 12:31:07 +1000 (EST)
Message-ID: <a5f578de750a09c145f5d4f50e90a4f8.squirrel@neil.brown.name>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C0797AC80@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C0797AC80@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, June 24, 2009 8:35 am, Tirumala Reddy Marri wrote:
> All,
>  I started RAID-5 creation using mdadm command. While recovery is
> happening I tried to install file system . I see intermittent crash   .
> And crash doesn't happen at fixed location. Any clue what could be the
> problem? How does the read/writes to MD driver handled while RAID-5 is
> under building.

Can you describe exactly what you mean by "crash" ??

The raid5 driver normally has no problems handling writes while
it is resyncing.  It has a 'stripe_cache' which is used to
synchronise regular IO with resync IO.

NeilBrown

