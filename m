From: wilsonjonathan <piercing_male@hotmail.com>
Subject: linear raid, is partial recovery possible?
Date: Mon, 28 Nov 2011 20:06:35 +0000
Message-ID: <BLU0-SMTP248DE7134BCABFEB83181BD98B20@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quick question regarding linear raid.

If a disk fails on a linear raid I understand how the raid is
non-recoverable, as a whole, as it has lost a chunk of data.

However is it possible to recover the data from the non-failed portion
of the raid as I assume linear works by starting at one end of the array
and slowly progresses to the other?

Or perhaps it is dependent on the file system on the array, eg. ext
works by trying to place files distant to each other to help reduce the
possibility of fragmentation?

Perhaps the filesystem meta data, or some portion, may span between two
physical drives which would corrupt its table?

And obviously if a file spans two disks it would be missing part of its
data?

Does the raid underlying a file system do its own things, re-space,
physical data layout, etc; or does/can a file system impact on the
workings of an array?

The more I look into software raid the more fasinated I become with it
and its inner workings. While its way beyond me in some of the maths and
the fact I am un-proficient in C it has really caught my intrigue, and
all because I wanted to set up a small home server ;-)


