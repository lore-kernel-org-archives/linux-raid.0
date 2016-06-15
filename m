From: "John Stoffel" <john@stoffel.org>
Subject: Re: Failure propagation of concatenated raids ?
Date: Wed, 15 Jun 2016 10:56:09 -0400
Message-ID: <22369.27785.674766.167045@quad.stoffel.home>
References: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com>
	<22368.45414.256389.605050@quad.stoffel.home>
	<CAAkR8+vfXJOtYUBvkZXxQhXwh-e2t6yGuarLW4MGS8B+YKtUZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAkR8+vfXJOtYUBvkZXxQhXwh-e2t6yGuarLW4MGS8B+YKtUZg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Noble <nicolas@nobis-crew.org>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Nicolas" == Nicolas Noble <nicolas@nobis-crew.org> writes:

>> it
>> *might* make sense to look at ceph or some other distributed
>> filesystem.

Nicolas> I was trying to avoid that, mainly because that doesn't seem
Nicolas> to be as supported as a more straightforward raids+lvm2
Nicolas> scenario. But I might be willing to reconsider my position in
Nicolas> light of such data losses.

If you are building multiple RAID sets, and then stripping across them
using LVM and then putting filesystems on top of them, you should be
ok if your underlying RAID is robust.

By that I mean splitting members across controllers, so as to avoid
single points of failure.  You would also use RAID6 with hot spares as
well.  Once you have a robust foundation, then the filesystem layered
on top doesn't have to worry as much about part of the storage going
away.

But if you're not willing, or can't afford the cost of true no single
point of failure, then you have to take your chances.  This is why I
tend to mirror my system at home and even do triple mirrors at points
for data I really care about.

>> no filesystem I know handles that without either going
>> readonly, or totally locking up.

Nicolas> Which, to be fair, is exactly what I'm looking for. I'd
Nicolas> rather see the filesystem lock itself up, until a human tries
Nicolas> to restore the failed raid back online. But my recent
Nicolas> experience and experiments show me that the filesystems
Nicolas> actually don't lock themselves up, and don't go read only for
Nicolas> quite some time, and heavy heavy data corruption will then
Nicolas> happen. I'd be much more happy if the behavior was that the
Nicolas> filesystem locks itself up instead of self destroying over
Nicolas> time.

Part of the problem is that if the filesystem isn't writing to that
section of the device, it might not know about the failure in time,
esp if they're seperate devices.  Now I would think that LVM would
notice that a PV in a VG has gone away, but it then needs to
percolate up to check the LV(s) on that PV which then needs to notify
the filesystem.

I agree it should work, and should be more robust, and it might
actually be possible to tweak the system to be more hair trigger about
going into lock down mode.


Of course the other option is for you to shard your data across
multiple filesystems, and pot the resiliency into your application, so
that if some of the data can't be found, it just keeps going.  But
that's a different sort of complexity as well.

John
