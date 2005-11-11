From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: doubts about intent-logging
Date: Fri, 11 Nov 2005 11:56:02 -0200
Message-ID: <17268.41714.819859.813819@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If I understand the Compendium (also known as mdadm manpage :-) ) the
intent-logging bitmap is stored near the superblock when the name
"internal" is specified. Does this mean that it'll be in the 128KB
area of the superblock? If so, what happens if there isn't enough
space? This is likely for medium-to-large arrays, say 500+GB with the
default chunk 4K.

About the size of the bitmap-chunk, wouldn't it be better if it were
the size of a stripe? I ask this because I thought all IO to an array
was done in multiples of the stripe size even if the write request is
smaller.

What's the influence of intent-logging in the performance of a raid5
array? It seems that it'll increase the number of writes, so a
degradation is likely, no? This is important to decide if
intent-logging is worth. I'd think that it's only worth for machines
that crash often and leave the array dirty.
