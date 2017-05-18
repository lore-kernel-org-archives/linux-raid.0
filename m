From: Chris Worley <worleys@gmail.com>
Subject: Shouldn't the /sys/block/md*/queue/max_*sectors_kb be set to the
 chunk size?
Date: Thu, 18 May 2017 05:52:28 -1000
Message-ID: <CANWz5fiQ1O5k43QKfurd84nwdeCZL0-EOD6p_2vp+wHaJmsVEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm obviously missing something...

If chunk size is a stride, why is the
/sys/block/md*/queue/max_*sectors_kb being inherited from one of the
underlying devices rather than being set to the chunk size or the
drive multiple of their max sector settings?

Or, in other words, would the chunk size setting have a natural upper
bound/limit of one of the drives max_sectors, or the sum of all of the
constituent drives max sectors?

Thanks,

Chris
