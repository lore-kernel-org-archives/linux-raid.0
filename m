From: "John Stoffel" <john@stoffel.org>
Subject: Re: Best option for SSD caching on a md raid array?
Date: Mon, 8 Feb 2016 10:34:09 -0500
Message-ID: <22200.46449.482559.914441@quad.stoffel.home>
References: <1670804.QnHtKWfib8@nell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1670804.QnHtKWfib8@nell>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thomas> I'm planning on setting up a dual raid5 array for hosting vm's
Thomas> off LVM, I would like to add an ssd cache to help with typical
Thomas> server system loads, and some mixed read/write loads for game
Thomas> servers.

Thomas> I'm wondering what the "best" route for me to go is. There's a
Thomas> few options that I know of, like flashcache, dm-cache, and
Thomas> bcache. The question is which of those is better suited to my
Thomas> use case?

I looked into both bcache and lvmcache and went with lvmcache because
it made more sense to me.  But one restriction is that the cache LVs
must be in the same VGs as the volume to cache.  So you might need to
partition your SSD(s) and put the partitions into seperate VGs so that
you can cache one or more LVs.

I'm using it at home to cache a RAID1 4tb VG, with a pair of mirrored
SSDs.  I'm a big believer in mirroring, esp for critical stuff like
this.

Unfortunately, I don't have a good performance measurements of how
much help this actually gives me.  It *feels* faster, but since I
don't have before/after measurements, I could just have wasted a bunch
of money.

So I'd recommend lvmcache overall, since it does seem to help, but
push for better performance metrics and measurement.  Heh, maybe it's
time for me to start writing up lvmcachetop to help measure things.

John
