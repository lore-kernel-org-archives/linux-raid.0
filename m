From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 000 of 2] Introduction
Date: Sun, 30 Oct 2005 23:34:32 -0800
Message-ID: <20051030233432.238d0020.akpm@osdl.org>
References: <20051031165552.8151.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051031165552.8151.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> 
>  I'd like to review the sysfs a bit more before it goes to Linus, but
>  the rest can go anytime.

umm, what does "the sysfs" refer to?

Current md patches in -mm:

md-better-handling-of-readerrors-with-raid5.patch
md-initial-sysfs-support-for-md.patch
md-extend-md-sysfs-support-to-component-devices.patch
md-add-kobject-sysfs-support-to-raid5.patch
md-allow-a-manual-resync-with-md.patch
md-teach-raid5-the-difference-between-check-and-repair.patch
md-provide-proper-rcu_dereference--rcu_assign_pointer-annotations-in-md.patch
md-fix-ref-counting-problems-with-kobjects-in-md.patch
md-minor-md-fixes.patch
md-change-raid5-sysfs-attribute-to-not-create-a-new-directory.patch
md-improvements-to-raid5-handling-of-read-errors.patch
md-convert-faulty-and-in_sync-fields-to-bits-in-flags-field.patch
md-make-md-on-disk-bitmaps-not-host-endian.patch
md-support-bio_rw_barrier-for-md-raid1.patch
drivers-md-fix-up-schedule_timeout-usage.patch

