From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: raid5: coding style cleanup / refactor
Date: Tue, 12 Jun 2007 14:25:32 -0700
Message-ID: <20070612142532.b45ee9bf.akpm@linux-foundation.org>
References: <1181670063.12913.5.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1181670063.12913.5.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 12 Jun 2007 10:41:03 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Most of the raid5 code predates git so the coding style violations have
> been present for a long time.  However, now that major new patches are
> arriving, checkpatch.pl complains about these old violations.  Instead of
> attempting to justify the warnings as "this is what raid5 used to do", this
> patch brings the code in line with the current style.
> 
> Note that this is more than a simple reformatting.  The majority of the
> 80-column violations were in the handle_stripe5 and handle_stripe6
> routines.  By introducing the 'stripe_head_state' and 'r6_state' objects
> large portions of the logic could be moved to sub-routines, reclaiming a
> column's worth of indentation.
> 
> 'stripe_head_state' consumes all of the automatic variables that previously
> stood alone in handle_stripe.  'r6_state' contains the handle_stripe6
> specific variables like p_failed and q_failed.  
> 
> One of the nice side effects of the 'stripe_head_state' change is that it
> allows for further reductions in code duplication between raid5 and raid6
> (note: unfortunately the other 80-column violations hide the code
> duplication-removal effect in the diffstat).  The following new routines
> are shared between raid5 and raid6:
> 
> 	handle_completed_write_requests
> 	handle_requests_to_failed_array
> 	handle_stripe_expansion
> 
> Trivia:
> * PRINTK and RAID5_DEBUG is replaced with pr_debug
> * struct field comments moved to the top (kernel-doc format)

Unfortunately these cleanups get into a huge fight with your very own
git-md-accel.patch:

patching file drivers/md/raid5.c
Hunk #1 succeeded at 58 (offset 1 line).
Hunk #2 succeeded at 78 (offset 1 line).
Hunk #3 succeeded at 91 (offset 1 line).
Hunk #4 FAILED at 127.
Hunk #5 succeeded at 157 (offset 2 lines).
Hunk #6 succeeded at 167 (offset 2 lines).
Hunk #7 succeeded at 211 (offset 2 lines).
Hunk #8 succeeded at 224 (offset 2 lines).
Hunk #9 succeeded at 235 with fuzz 1 (offset 3 lines).
Hunk #10 succeeded at 263 (offset 3 lines).
Hunk #11 succeeded at 304 (offset 3 lines).
Hunk #12 succeeded at 943 (offset 578 lines).
Hunk #13 succeeded at 995 (offset 578 lines).
Hunk #14 succeeded at 1015 (offset 578 lines).
Hunk #15 succeeded at 1124 (offset 578 lines).
Hunk #16 succeeded at 1136 (offset 578 lines).
Hunk #17 succeeded at 1155 (offset 578 lines).
Hunk #18 succeeded at 1206 (offset 578 lines).
Hunk #19 succeeded at 1251 (offset 578 lines).
Hunk #20 succeeded at 1269 (offset 578 lines).
Hunk #21 succeeded at 1278 (offset 578 lines).
Hunk #22 FAILED at 1524.
Hunk #23 FAILED at 1555.
Hunk #24 succeeded at 1541 (offset 547 lines).
Hunk #25 succeeded at 1989 with fuzz 2 (offset 978 lines).
Hunk #26 FAILED at 2009.
Hunk #27 FAILED at 2056.
Hunk #28 FAILED at 2064.
Hunk #29 FAILED at 2084.
Hunk #30 FAILED at 2094.
Hunk #31 FAILED at 2135.
Hunk #32 FAILED at 2182.
Hunk #33 FAILED at 2193.
Hunk #34 FAILED at 2215.
Hunk #35 FAILED at 2225.
Hunk #36 FAILED at 2242.
Hunk #37 FAILED at 2278.
Hunk #38 succeeded at 3381 with fuzz 1 (offset 2026 lines).
Hunk #39 FAILED at 4002.
Hunk #40 FAILED at 4016.
Hunk #41 FAILED at 4054.
Hunk #42 FAILED at 4216.
Hunk #43 FAILED at 4235.
Hunk #44 FAILED at 4253.
Hunk #45 FAILED at 4282.
Hunk #46 FAILED at 4309.
Hunk #47 FAILED at 4330.
Hunk #48 FAILED at 4358.
Hunk #49 FAILED at 4400.
Hunk #50 FAILED at 4419.
Hunk #51 FAILED at 4427.
Hunk #52 FAILED at 4482.
Hunk #53 FAILED at 4501.
Hunk #54 FAILED at 4534.
Hunk #55 FAILED at 4564.
Hunk #56 FAILED at 4619.
Hunk #57 FAILED at 4663.
Hunk #58 succeeded at 3377 (offset 648 lines).
Hunk #59 succeeded at 3415 (offset 648 lines).
Hunk #60 succeeded at 3503 (offset 648 lines).
Hunk #61 succeeded at 3538 (offset 648 lines).
Hunk #62 succeeded at 3580 (offset 648 lines).
Hunk #63 succeeded at 3617 (offset 648 lines).
Hunk #64 succeeded at 3814 (offset 648 lines).
Hunk #65 succeeded at 3865 (offset 648 lines).
Hunk #66 succeeded at 3918 (offset 648 lines).
Hunk #67 succeeded at 3972 (offset 650 lines).
Hunk #68 succeeded at 4032 (offset 650 lines).
Hunk #69 succeeded at 4123 (offset 650 lines).
Hunk #70 succeeded at 4157 (offset 650 lines).
Hunk #71 succeeded at 4197 (offset 650 lines).
Hunk #72 succeeded at 4228 (offset 650 lines).
Hunk #73 succeeded at 4340 (offset 650 lines).
Hunk #74 succeeded at 4375 (offset 650 lines).
Hunk #75 succeeded at 4514 (offset 650 lines).
Hunk #76 succeeded at 4549 (offset 650 lines).
Hunk #77 succeeded at 4633 (offset 650 lines).
Hunk #78 succeeded at 4652 (offset 650 lines).
Hunk #79 succeeded at 4670 (offset 650 lines).
Hunk #80 succeeded at 4699 (offset 650 lines).
34 out of 80 hunks FAILED -- saving rejects to file drivers/md/raid5.c.rej
patching file include/linux/raid/raid5.h
Hunk #2 FAILED at 118.
Hunk #3 FAILED at 192.
Hunk #4 succeeded at 302 (offset 57 lines).
Hunk #5 succeeded at 335 (offset 57 lines).
Hunk #6 succeeded at 370 (offset 57 lines).
2 out of 6 hunks FAILED -- saving rejects to file include/linux/raid/raid5.h.rej

I assume that you're prepared to repair all that damage to your tree, but
it seems a bit masochistic?

