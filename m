From: "NeilBrown" <neilb@suse.de>
Subject: Re: split off + mount a partitionless RAID1 device?
Date: Tue, 27 May 2008 14:49:16 +1000 (EST)
Message-ID: <40607.192.168.1.70.1211863756.squirrel@neil.brown.name>
References: <e03b90ae0805262100h9eb16cfq31fe9e0430154007@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e03b90ae0805262100h9eb16cfq31fe9e0430154007@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid list <linux-raid@vger.kernel.org>, Jeff Marshall <marshman@frozenbear.com>
List-Id: linux-raid.ids

On Tue, May 27, 2008 2:00 pm, Jeff Breidenbach wrote:
> Ok, let's say that a um... hypothetical friend of mine had a power
> outage this morning. This many disk RAID1 happily assembled and
> mounted (with only mild persuasion) but is now caught up in a
> monumentally slow resync. The resync is slow because /dev/md0 is
> getting hammered with read requests by a webserver. If I turn off
> Apache then resysnc speed shoots up to a respectable level, but I'd
> rather not do that.

Why not just leave the resync going in the background using whatever
bandwidth happens to be available?
It isn't as though your data is much at risk.

>
> I'd love to split one of the drives off of the RAID1 and mount it
> directly. Then it can feed the ravenous Apache monster while the
> other five drives resync in peace. But foolishly and somewhat
> accidentally, this RAID is made up of devices (sdb, sdbf, etc..)
> instead of paritions (sdb1, sdf1, etc...). And I don't know how to
> mount a partitionless device. Do you?

The traditional method is to use the "mount" command.
whole-devices are no different from partitions when it comes to
mounting them.

NeilBrown

