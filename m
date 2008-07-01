From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 001 of 29] md: Ensure interrupted recovery completed
 properly (v1 metadata plus bitmap)
Date: Tue, 1 Jul 2008 09:20:29 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807010918070.26892@fbirervta.pbzchgretzou.qr>
References: <20080627164503.9671.patches@notabene> <1080627064923.10270@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1080627064923.10270@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids


On Friday 2008-06-27 08:49, NeilBrown wrote:
>
>[...] In this case it tells recovery to ignore the bitmap
>and recovery all blocks.
>
>So without this fix, a raid1 ir raid4/5/6 array with version 1.x
>metadata and a write intent bitmaps, that is stopped in the middle
>of a recovery, will appear to complete the recovery instantly
>after it is reassembled, but the recovery will not be correct.

If the array is stopped in the middle of a recovery, should not
it restart recovery where it left off when reassembled?
That's what the write intent bitmap is for, is not it? Like..

wait_for(assemble)
for_all('1' bits in bitmap)
    if (resync == success)
        bitmap[pos] = '0';
    if (signalled)
        break;

and stopping the resync in the middle, the bitmap should still
have '1' bits left to be processed on the next assemble.
Or, where did I go wrong?
