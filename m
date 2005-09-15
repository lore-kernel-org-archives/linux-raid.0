From: hpa@zytor.com (H. Peter Anvin)
Subject: RAID6 on PowerPC is faulty
Date: Thu, 15 Sep 2005 04:31:54 +0000 (UTC)
Message-ID: <dgatfq$mrq$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you have been running RAID6 on a PowerPC with Altivec, your RAID is
not two-disk redundant, due to bad Q syndrome computation.

It *is* one-disk redundant, however.

The following patch will fix it:

http://www.kernel.org/pub/linux/kernel/people/hpa/raid6-altivec-fix.patch

.. however, it will not correct an existing array without rewriting
every stripe.

Neil, is there any way to force md to recompute all the syndromes?

	-hpa
