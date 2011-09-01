From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: raid array with 3T disks and GPT partition
Date: Thu, 1 Sep 2011 17:47:59 +0200
Message-ID: <20110901154759.GA32649@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm trying to create a raid6 array from 10x3T disks. Since disks > 2T
must use the GPT partion table I used parted to created a single
partition on each drive with the correct GPT partion type.

Now how do I make sure that these partitions have the correct "raid
autodetect" (fd) id? Is it even still needed? I didn't find any way to
set that flag in (g)parted.

Thanks,
