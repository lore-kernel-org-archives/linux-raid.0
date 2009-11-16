From: Kasper Sandberg <postmaster@metanurb.dk>
Subject: raid10 layout for 2xSSDs
Date: Mon, 16 Nov 2009 15:29:05 +0100
Message-ID: <1258381745.31633.35.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I've been wanting to create a raid10 array of two SSDs, and I am
currently considering the layout.

As i understand it, near layout is similar to raid1, and will only
provide a speedup if theres 2 reads at the same time, not a single
sequential read.

so the choice is really between far and offset. As i see it, the
difference is, that offset tries to reduce the seeking for writing
compared to far, but that if you dont consider the seeking penalty,
average sequential write speed across the entire array should be roughly
the same with offset and far, with offset perhaps being a tad more
"stable", is this a correct assumption? if it is, that would mean offset
provides a higher "garantueed" speed than far, but with a lower maximum
speed.

mvh.
Kasper Sandberg

