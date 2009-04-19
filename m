From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: RAID without superblock
Date: Sun, 19 Apr 2009 13:47:43 +0200
Message-ID: <20090419114743.GA29195@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

what is the proper way to assemble a two disk,
RAID-1, without superblock.
That is, created with "-B" instead of "-C".

I noticed that re-using "-B", will start an
array sync/repair, but it is not clear to me
which disk is source and which is destination.

Using a bitmap file, seems to be safer option,
but I'm not sure if this is just a workaround
or it is the proper way.

Thanks a lot in advance,

bye,

-- 

piergiorgio
