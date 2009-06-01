From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: raid5 rebuild/resync speed.
Date: Mon, 1 Jun 2009 15:52:04 -0600
Message-ID: <200906011552.04653.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I recently read an article that claimed the default mode of --create (to start 
with a spare and rebuild it into the array) was faster than doing a full 
resync.

It turns out its not on my system. With the default --create the rebuild goes 
at 60MB/s or so, while when passing -f it goes at around 80MB/s. using the -f 
option to --create saves nearly 2 hours when building a fresh 4x2T raid array.

Is there a reason the default is still rebuilding a spare into the new array?

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
