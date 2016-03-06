From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] raid1: include bio_end_io_list in nr_queued to prevent
 freeze_array hang
Date: Sun, 6 Mar 2016 15:33:04 -0800
Message-ID: <20160306233304.GA3200@kernel.org>
References: <1456760638-23936-1-git-send-email-nate.dailey@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456760638-23936-1-git-send-email-nate.dailey@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 29, 2016 at 10:43:58AM -0500, Nate Dailey wrote:
> If raid1d is handling a mix of read and write errors, handle_read_error's
> call to freeze_array can get stuck.
> 
> This can happen because, though the bio_end_io_list is initially drained,
> writes can be added to it via handle_write_finished as the retry_list
> is processed. These writes contribute to nr_pending but are not included
> in nr_queued.
> 
> If a later entry on the retry_list triggers a call to handle_read_error,
> freeze array hangs waiting for nr_pending == nr_queued+extra. The writes
> on the bio_end_io_list aren't included in nr_queued so the condition will
> never be satisfied.
> 
> To prevent the hang, include bio_end_io_list writes in nr_queued.
> 
> There's probably a better way to handle decrementing nr_queued, but this
> seemed like the safest way to avoid breaking surrounding code.
> 
> I'm happy to supply the script I used to repro this hang.

Looks good. Could you please also fix raid10?

Thanks,
Shaohua
