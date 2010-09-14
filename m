From: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Subject: =?iso-8859-1?B?cmFpZDYgYW5kIHBhcml0eSBjYWxjdWxhdGlvbnM=?=
Date: Tue, 14 Sep 2010 14:45:40 +0000
Message-ID: <20100914144540.25913.qmail@s217.sureserver.com>
Reply-To: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've been looking through the drivers/md code, and I've got a few questions about the RAID6 parity calculations that have me stumped.

I can see that when recovering 1 or 2 data sections, it calls functions based on the content that we're recovering (eg. async_gen_syndrome, async_xor, async_raid6_datap_recov, etc.) However, the length parameter is always given as STRIPE_SIZE, which from what I can tell is the same as PAGE_SIZE, which for vanilla systems like the one I'm playing with is 4096 bytes.

The thing that I can't figure out is how this interacts with the RAID6 chunk size; the array I'm playing with has a default chunk size (64kb), which I understand means that there's 64kb of data striped across each disk (bar two), then 64kb of P, then 64kb of Q for the first stripe, correct? If so, I can't figure out where the whole parity calculation is done for all 64kb. There's no loops, no recursion, or anything that would process it that I can find. I'm obviously missing something here, can anyone enlighten me?

Thanks for any advice or pointers!

Cheers,
Michael


(as a side note: I'm playing with all this as I've managed to royally screw up an array which had 2 dropped drives, by readding them back in (in what appears to be the wrong order). That would have been fine if thr rebuild finished completely, however the rebuild failed a few percent in, so now I have 2 drives with "swapped" data. That is, drive A contains the data for raid member 4 for the first x%, and raid member 5 for the rest, and drive B contains the data for raid member 5 for the first x% and raid member 4 for the rest. So I'm trying to write a userspace program to manually go through the array members, inspecting each stripe, and manually doing parity calculations for a range of drive permutations to try and see what looks sensible, hence I'm trying to understand what's ON the driv
 e to reverse engineer it.)

