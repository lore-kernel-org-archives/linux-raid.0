From: Kerin Millar <kerframil@gmail.com>
Subject: Re: raid10 make_request failure during iozone benchmark upon btrfs
Date: Tue, 03 Jul 2012 03:13:33 +0100
Message-ID: <4FF2554D.2040300@gmail.com>
References: <4FF108A8.6090606@gmail.com> <20120702125227.179c4343@notabene.brown> <4FF10E71.2090501@gmail.com> <20120703113943.3e4c43ad@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120703113943.3e4c43ad@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On 03/07/2012 02:39, NeilBrown wrote:

[snip]

 >>> Could you please double check that you are running a kernel with
 >>>
 >>> commit aba336bd1d46d6b0404b06f6915ed76150739057
 >>> Author: NeilBrown<neilb@suse.de>
 >>> Date:   Thu May 31 15:39:11 2012 +1000
 >>>
 >>>       md: raid1/raid10: fix problem with merge_bvec_fn
 >>>
 >>> in it?
 >>
 >> I am indeed. I searched the list beforehand and noticed the patch in
 >> question. Not sure which -rc it landed in but I checked my source tree
 >> and it's definitely in there.
 >>
 >> Cheers,
 >>
 >> --Kerin
 >
 > Thanks.
 > Looking at it again I see that it is definitely a different bug, that patch
 > wouldn't affect it.
 >
 > But I cannot see what could possibly be causing the problem.
 > You have a 256K chunk size, so requests should be limited to 512 sectors
 > aligned at a 512-sector boundary.
 > However all the requests that a causing errors are 512 sectors long, but
 > aligned on a 256-sector boundary (which is not also 512-sector).  This is
 > wrong.

I see.

 >
 > It could be that btrfs is submitting bad requests, but I think it always uses
 > bio_add_page, and bio_add_page appears to do the right thing.
 > It could be that dm-linear is causing problem, but it seems to correctly after
 > the underlying device for alignment, and reports that alignment to
 > bio_add_page.
 > It could be that md/raid10 is the problem but I cannot find any fault in
 > raid10_mergeable_bvec - performs much the same tests that the
 > raid01 make_request function does.
 >
 > So it is a mystery.
 >
 > Is this failure repeatable?

Yes, it's reproducible with 100% consistency. Furthermore, I tried to
use the btrfs volume as a store for the package manager, so as to try
with a 'realistic' workload. Many of these errors were triggered
immediately upon invoking the package manager. In case it matters, the
package manager is portage (in Gentoo Linux) and the directory structure
entails a shallow directory depth with a large number of distributed
small files. I haven't been able to reproduce with xfs, ext4 or reiserfs.

 >
 > If so, could you please insert
 >     WARN_ON_ONCE(1);
 > in drivers/md/raid10.c where it prints out the message: just after the
 > "bad_map:" label.
 >
 > Also, in raid10_mergeable_bvec, insert
 >     WARN_ON_ONCE(max<  0);
 > just before
 > 		if (max<  0)
 > 			/* bio_add cannot handle a negative return */
 > 			max = 0;
 >
 > and then see if either of those generate a warning, and post the full stack
 > trace  if they do.

OK. I ran iozone again on a fresh filesystem, mounted with the default
options. Here's the trace that appears, just before the first
make_request_bug message:

WARNING: at drivers/md/raid10.c:1094 make_request+0xda5/0xe20()
Hardware name: ProLiant MicroServer
Modules linked in: btrfs zlib_deflate lzo_compress kvm_amd kvm sp5100_tco i2c_piix4
Pid: 1031, comm: btrfs-submit-1 Not tainted 3.5.0-rc5 #3
Call Trace:
[<ffffffff81031987>] ? warn_slowpath_common+0x67/0xa0
[<ffffffff81442b45>] ? make_request+0xda5/0xe20
[<ffffffff81460b34>] ? __split_and_process_bio+0x2d4/0x600
[<ffffffff81063429>] ? set_next_entity+0x29/0x60
[<ffffffff810652c3>] ? pick_next_task_fair+0x63/0x140
[<ffffffff81450b7f>] ? md_make_request+0xbf/0x1e0
[<ffffffff8123d12f>] ? generic_make_request+0xaf/0xe0
[<ffffffff8123d1c3>] ? submit_bio+0x63/0xe0
[<ffffffff81040abd>] ? try_to_del_timer_sync+0x7d/0x120
[<ffffffffa016839a>] ? run_scheduled_bios+0x23a/0x520 [btrfs]
[<ffffffffa0170e40>] ? worker_loop+0x120/0x520 [btrfs]
[<ffffffffa0170d20>] ? btrfs_queue_worker+0x2e0/0x2e0 [btrfs]
[<ffffffff810520c5>] ? kthread+0x85/0xa0
[<ffffffff815441f4>] ? kernel_thread_helper+0x4/0x10
[<ffffffff81052040>] ? kthread_freezable_should_stop+0x60/0x60
[<ffffffff815441f0>] ? gs_change+0xb/0xb

Cheers,

--Kerin
