From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v4] md: improve io stats accounting
Date: Fri, 3 Jul 2020 17:32:40 -0700
Message-ID: <CAPhsuW4Xc19jJyxzOUcfoE+HrKH=bogC55=-dt04z6phn0Wu5Q@mail.gmail.com>
References: <20200703091309.19955-1-artur.paszkiewicz@intel.com> <82ac5fe5-e61d-e031-6a64-60b6e1dd408d@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <82ac5fe5-e61d-e031-6a64-60b6e1dd408d@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jul 3, 2020 at 2:27 AM Guoqing Jiang
<guoqing.jiang@cloud.ionos.com> wrote:
>
> Looks good, Acked-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>
> Thanks,
> Guoqing
>
> On 7/3/20 11:13 AM, Artur Paszkiewicz wrote:
> > Use generic io accounting functions to manage io stats. There was an
> > attempt to do this earlier in commit 18c0b223cf99 ("md: use generic io
> > stats accounting functions to simplify io stat accounting"), but it did
> > not include a call to generic_end_io_acct() and caused issues with
> > tracking in-flight IOs, so it was later removed in commit 74672d069b29
> > ("md: fix md io stats accounting broken").
> >
> > This patch attempts to fix this by using both disk_start_io_acct() and
> > disk_end_io_acct(). To make it possible, a struct md_io is allocated for
> > every new md bio, which includes the io start_time. A new mempool is
> > introduced for this purpose. We override bio->bi_end_io with our own
> > callback and call disk_start_io_acct() before passing the bio to
> > md_handle_request(). When it completes, we call disk_end_io_acct() and
> > the original bi_end_io callback.
> >
> > This adds correct statistics about in-flight IOs and IO processing time,
> > interpreted e.g. in iostat as await, svctm, aqu-sz and %util.
> >
> > It also fixes a situation where too many IOs where reported if a bio was
> > re-submitted to the mddev, because io accounting is now performed only
> > on newly arriving bios.
> >
> > Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Applied to md-next. Thanks!
