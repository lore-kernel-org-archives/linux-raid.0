From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: miscount in md_p.h
Date: Tue, 28 Dec 2004 08:21:30 +0100 (MET)
Message-ID: <200412280721.iBS7LUW25590@inv.it.uc3m.es>
Reply-To: ptb@inv.it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Isn't this a miscount in md_p.h, in struct mdp_superblock_1:

        ...
        __u8    pad2[64-56];    /* set to 0 when writing */

        /* array state information - 64 bytes */
        __u64   utime;          /* 40 bits second, 24 btes microseconds */
        __u64   events;         /* incremented when superblock updated */
        __u64   resync_offset;  /* data before this offset (from data_offset) known to be in sync */
        __u32   sb_csum;        /* checksum upto devs[max_dev] */
        __u32   max_dev;        /* size of devs[] array to consider */
        __u8    pad3[64-40];    /* set to 0 when writing */


I count 3 * 64b + 2 * 32b = 3 * 8B + 2 * 4B = 32B, not 40B, before the
padding for this section starts. It looks like somebody counted 5 * 64b
= 5 * 8B = 40B.

Peter
