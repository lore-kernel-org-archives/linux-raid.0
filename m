From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 0 of 12] Introduction
Date: Wed, 23 Mar 2005 02:12:36 -0800
Message-ID: <20050323021236.0d05dbc4.akpm@osdl.org>
References: <20050323164208.16240.patches@notabene>
	<20050323015254.2f2d316c.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050323015254.2f2d316c.akpm@osdl.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Morton <akpm@osdl.org> wrote:
>
> Of course it doesn't always work out that simply ;)
> 
>  In this case it's not clear that a tsort will work out right.  I'll take a
>  look.

Well it wasn't completely clean, and I forgot to rename the patches, but
this is how the tsort came out:


 md-merge-md_enter_safemode-into-md_check_recovery.patch
 md-improve-locking-on-safemode-and-move-superblock-writes.patch
 md-improve-the-interface-to-sync_request.patch
 md-optimised-resync-using-bitmap-based-intent-logging.patch
+md-a-couple-of-tidyups-relating-to-the-bitmap-file.patch
+md-call-bitmap_daemon_work-regularly.patch
+md-print-correct-pid-for-newly-created-bitmap-writeback-daemon.patch
+md-minor-code-rearrangement-in-bitmap_init_from_disk.patch
+md-make-sure-md-bitmap-is-cleared-on-a-clean-start.patch
 md-printk-fix.patch
+md-improve-debug-printing-of-bitmap-superblock.patch
+md-check-return-value-of-write_page-rather-than-ignore-it.patch
+md-enable-the-bitmap-write-back-daemon-and-wait-for-it.patch
+md-dont-skip-bitmap-pages-due-to-lack-of-bit-that-we-just-cleared.patch
 md-optimised-resync-using-bitmap-based-intent-logging-fix.patch
 md-raid1-support-for-bitmap-intent-logging.patch
+md-fix-bug-when-raid1-attempts-a-partial-reconstruct.patch
 md-raid1-support-for-bitmap-intent-logging-fix.patch
 md-optimise-reconstruction-when-re-adding-a-recently-failed-drive.patch
 md-fix-deadlock-due-to-md-thread-processing-delayed-requests.patch
+md-allow-md-intent-bitmap-to-be-stored-near-the-superblock.patch
+md-allow-md-to-update-multiple-superblocks-in-parallel.patch

So we can later work out which of these to fold into which other ones.

