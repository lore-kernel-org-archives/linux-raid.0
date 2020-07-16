From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v4] md: improve io stats accounting
Date: Thu, 16 Jul 2020 10:29:59 -0700
Message-ID: <CAPhsuW6HjN0hZ8E998XBpg+WxP5uhZO0on-M-tQ45kpFO5XHqg@mail.gmail.com>
References: <20200703091309.19955-1-artur.paszkiewicz@intel.com>
 <82ac5fe5-e61d-e031-6a64-60b6e1dd408d@cloud.ionos.com> <CAPhsuW4Xc19jJyxzOUcfoE+HrKH=bogC55=-dt04z6phn0Wu5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW4Xc19jJyxzOUcfoE+HrKH=bogC55=-dt04z6phn0Wu5Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jul 3, 2020 at 5:32 PM Song Liu <song@kernel.org> wrote:
>
> On Fri, Jul 3, 2020 at 2:27 AM Guoqing Jiang
> <guoqing.jiang@cloud.ionos.com> wrote:
> >
> > Looks good, Acked-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> >
> > Thanks,
> > Guoqing
> >
> > On 7/3/20 11:13 AM, Artur Paszkiewicz wrote:
> > > Use generic io accounting functions to manage io stats. There was an
> > > attempt to do this earlier in commit 18c0b223cf99 ("md: use generic io
> > > stats accounting functions to simplify io stat accounting"), but it did
> > > not include a call to generic_end_io_acct() and caused issues with
> > > tracking in-flight IOs, so it was later removed in commit 74672d069b29
> > > ("md: fix md io stats accounting broken").
> > >
> > > This patch attempts to fix this by using both disk_start_io_acct() and
> > > disk_end_io_acct(). To make it possible, a struct md_io is allocated for
> > > every new md bio, which includes the io start_time. A new mempool is
> > > introduced for this purpose. We override bio->bi_end_io with our own
> > > callback and call disk_start_io_acct() before passing the bio to
> > > md_handle_request(). When it completes, we call disk_end_io_acct() and
> > > the original bi_end_io callback.
> > >
> > > This adds correct statistics about in-flight IOs and IO processing time,
> > > interpreted e.g. in iostat as await, svctm, aqu-sz and %util.
> > >
> > > It also fixes a situation where too many IOs where reported if a bio was
> > > re-submitted to the mddev, because io accounting is now performed only
> > > on newly arriving bios.
> > >
> > > Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>
> Applied to md-next. Thanks!

I just noticed another issue with this work on raid456, as iostat
shows something
like:

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
nvme0n1        6306.50 18248.00  636.00 1280.00    45.11    76.19
129.65     3.03    1.23    0.67    1.51   0.76 145.50
nvme1n1       11441.50 13234.00 1069.50  961.00    71.87    55.39
128.35     3.32    1.30    0.90    1.75   0.72 146.50
nvme2n1        8280.50 16352.50  971.50 1231.00    65.53    68.65
124.77     3.20    1.17    0.69    1.54   0.64 142.00
nvme3n1        6158.50 18199.50  567.00 1453.50    39.81    76.74
118.13     3.50    1.40    0.88    1.60   0.73 146.50
md0               0.00     0.00 1436.00 1411.00    89.75    88.19
128.00    22.98    8.07    0.16   16.12   0.52 147.00

md0 here is a RAID-6 array with 4 devices. %util of > 100% is clearly
wrong here.
This only doesn't happen to RAID-0 or RAID-1 in my tests.

Artur, could you please take a look at this?

Thanks,
Song
