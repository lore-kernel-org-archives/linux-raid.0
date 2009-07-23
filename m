From: "NeilBrown" <neilb@suse.de>
Subject: Re: Get rid of sparesmissing events
Date: Fri, 24 Jul 2009 07:55:38 +1000 (EST)
Message-ID: <d4a4a65be8c2963a6500271d6e72df71.squirrel@neil.brown.name>
References: <20090723184936.GA5905@csy.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090723184936.GA5905@csy.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Shane W <shane-kernel@csy.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, July 24, 2009 4:49 am, Shane W wrote:
> Hey all,
>
> Whenever my system boots, mdadm sends an email for a
> sparesmissing event on all of my raid5 arrays. The arrays
> are 5 disks in size with no spares. How do I tell mdadm
> that there are in fact no spares nor should there be?

Edit mdadm.conf.   Remove "spares=1".

NeilBrown

