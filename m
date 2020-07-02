From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v3] md: improve io stats accounting
Date: Thu, 2 Jul 2020 14:25:26 -0700
Message-ID: <CAPhsuW5eMPMH1HcMXi67Ci0rbWhVyiuLodVZB_oaGbrR7abTJQ@mail.gmail.com>
References: <20200702142926.4419-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200702142926.4419-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

On Thu, Jul 2, 2020 at 7:29 AM Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:
>
> Use generic io accounting functions to manage io stats. There was an
> attempt to do this earlier in commit 18c0b223cf99 ("md: use generic io
> stats accounting functions to simplify io stat accounting"), but it did
> not include a call to generic_end_io_acct() and caused issues with
> tracking in-flight IOs, so it was later removed in commit 74672d069b29
> ("md: fix md io stats accounting broken").
>
> This patch attempts to fix this by using both bio_start_io_acct() and
> bio_end_io_acct(). To make it possible, a struct md_io is allocated for
> every new md bio, which includes the io start_time. A new mempool is
> introduced for this purpose. We override bio->bi_end_io with our own
> callback and call bio_start_io_acct() before passing the bio to
> md_handle_request(). When it completes, we call bio_end_io_acct() and
> the original bi_end_io callback.
>
> This adds correct statistics about in-flight IOs and IO processing time,
> interpreted e.g. in iostat as await, svctm, aqu-sz and %util.
>
> It also fixes a situation where too many IOs where reported if a bio was
> re-submitted to the mddev, because io accounting is now performed only
> on newly arriving bios.
>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Thanks Artur and Guoqing!

I run quick test with this. Seems it only adds proper statistics to
raid5 array, but
not to raid0 array. Is this expected?

Song

[...]
