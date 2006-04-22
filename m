From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: data recovery on raid5
Date: Sat, 22 Apr 2006 21:48:04 +0200
Message-ID: <62b0912f0604221248s653843bfx363f346c7ef31a94@mail.gmail.com>
References: <444A7C99.80006@abhost.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <444A7C99.80006@abhost.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan <jrs@abhost.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jonathan wrote:
> # mdadm -C /dev/md0 -n 4 -l 5 missing /dev/etherd/e0.[023]

I think you should have tried "mdadm --assemble --force" first, as I
proposed earlier.

By doing the above, you have effectively replaced your version 0.9.0
superblocks with version 0.9.2.  I don't know if version 0.9.2
superblocks are larger than 0.9.0, Neil hasn't responded to that yet. 
Potentially hazardous, who knows.

Anyway.
This is from your old superblock as described by Sam Hopkins:

> /dev/etherd/<blah>:
>      Chunk Size : 32K

This is from what you've just posted:
> /dev/etherd/<blah>:
>      Chunk Size : 64K

If I were you, I'd recreate your superblocks now, but with the correct
chunk size (use -c).

> We'll be happy to pay you for your services.

I'll be modest and charge you a penny per byte of data recovered, ho hum.
