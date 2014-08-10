From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: add vs. re-add
Date: Sun, 10 Aug 2014 23:50:11 +0200
Message-ID: <20140810215011.GA16750@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

maybe this was already explained, but I could not
find something specific.

Given a parity array (RAID-456) with bitmap, when
add HDD accidentally disconnects, it can be re-added.
That is, only the bitmapped changes are synchronized.
Now, sometimes this is not possible, that is the
disk *must* be added, with full synchronization.

Questions:
1) What's the criteria used by "mdadm" to decide if
an HDD can be re-added or it must be added?
2) Knowing that the HDD can be re-added, can be this
forced? (I did *not* try --force).

Thanks,

bye,

-- 

piergiorgio
