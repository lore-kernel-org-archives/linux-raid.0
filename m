From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: -G to smaller doesn't move superblock... is there _any_ way to
	shrink?
Date: Fri, 6 Nov 2009 14:37:59 -0800
Message-ID: <4877c76c0911061437y1b699720q8f599b606d65b740@mail.gmail.com>
References: <20091106125334.GC6212@Toms.NET>
	 <4182ad6bf659bcbda858b59fc54aba1a.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4182ad6bf659bcbda858b59fc54aba1a.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Thomas Arthur Oehser <tom@toms.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Other than using --create, which isn't much of a risk, the only
> way to do what you want is to fail and remove each device
> from the array, resize the device, add it back to the array, then
> when recovery completes, move on to the next device.
>
> NeilBrown

That's one more reason to use the 1.1 or 1.2 format for everything
except /boot .
