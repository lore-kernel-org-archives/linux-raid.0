From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 000 of 5] md: Assorted minor fixes for mainline
Date: Fri, 8 Dec 2006 16:04:55 -0800
Message-ID: <20061208160455.05a81359.akpm@osdl.org>
References: <20061208120132.21203.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061208120132.21203.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 8 Dec 2006 12:05:24 +1100
NeilBrown <neilb@suse.de> wrote:

> Following are 5 patches for md in 2.6.19-rc6-mm2 that are suitable for 2.6.20.
> 
> Patch 4 might fix an outstanding bug against md which manifests as an
> oops early in boot, but I don't have test results yet.
> 
> NeilBrown
> 
>  [PATCH 001 of 5] md: Remove some old ifdefed-out code from raid5.c
>  [PATCH 002 of 5] md: Return a non-zero error to bi_end_io as appropriate in raid5.
>  [PATCH 003 of 5] md: Assorted md and raid1 one-liners
>  [PATCH 004 of 5] md: Close a race between destroying and recreating an md device.
>  [PATCH 005 of 5] md: Allow mddevs to live a bit longer to avoid a loop with udev.

md-change-lifetime-rules-for-md-devices.patch still has a cloud over its
head (Jiri Kosina <jikos@jikos.cz>'s repeatable failure), so I staged these
new patches as below:


 md-fix-innocuous-bug-in-raid6-stripe_to_pdidx.patch
 #
 md-conditionalize-some-code.patch
+md-remove-some-old-ifdefed-out-code-from-raid5c.patch
+md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5.patch
+md-assorted-md-and-raid1-one-liners.patch
 md-change-lifetime-rules-for-md-devices.patch
+md-close-a-race-between-destroying-and-recreating-an-md-device.patch
+md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch

So the last three are maybe-not-for-2.6.20.

Does that sounds sane?
