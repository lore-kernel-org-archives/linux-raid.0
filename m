From: "Jeff Breidenbach" <jeff@jab.org>
Subject: Re: split off + mount a partitionless RAID1 device?
Date: Mon, 26 May 2008 22:28:42 -0700
Message-ID: <e03b90ae0805262228w62a9eacaj1786fc57af7f21b@mail.gmail.com>
References: <e03b90ae0805262100h9eb16cfq31fe9e0430154007@mail.gmail.com>
	 <40607.192.168.1.70.1211863756.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40607.192.168.1.70.1211863756.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid list <linux-raid@vger.kernel.org>, Jeff Marshall <marshman@frozenbear.com>
List-Id: linux-raid.ids

> Why not just leave the resync going in the background using whatever
> bandwidth happens to be available?

Well, 32 thousand minutes is a long time. I figure sequestering
all those seeks from Apache would cut resync to a mere 8 hours.
Which would be nice because I'm trying to baby the array until
it is complete by holding off on writes.

However, for some unknown reason the array has recently sped up
a lot and is right now chugging along at speed=24485K/sec. So
I guess I'll just offer general thanks to the strange and mysterious
kernel gods and let things progress as is.

General thanks!
