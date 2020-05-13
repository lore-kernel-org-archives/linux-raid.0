From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: remove a few uses of ->queuedata
Date: Wed, 13 May 2020 15:26:45 -0700
Message-ID: <CAPcyv4iWB=ZMmpc1aWfpJabSbCdvB28dCeSp_xj7AZMfbF_rjg@mail.gmail.com>
References: <20200508161517.252308-1-hch@lst.de>
	<CAPcyv4j3gVqrZWCCc2Q-6JizGAQXW0b+R1BcvWCZOvzaukGLQg@mail.gmail.com>
	<20200509082352.GB21834@lst.de>
	<CAPcyv4ggb7_rwzGbhHNXSHd+jjSpZC=+DMEztY6Cu8Bc=ZNzag@mail.gmail.com>
	<20200512080820.GA2336@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20200512080820.GA2336-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, linux-raid <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-m68k-cunTk1MwBs8S/qaLPR03pWD2FQJk+8+b@public.gmane.org, Philip Kelleher <pjk1939-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, Joshua Morris <josh.h.morris-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-raid.ids

On Tue, May 12, 2020 at 1:08 AM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
> On Sat, May 09, 2020 at 08:07:14AM -0700, Dan Williams wrote:
> > > which are all used in the I/O submission path (generic_make_request /
> > > generic_make_request_checks).  This is mostly a prep cleanup patch to
> > > also remove the pointless queue argument from ->make_request - then
> > > ->queue is an extra dereference and extra churn.
> >
> > Ah ok. If the changelogs had been filled in with something like "In
> > preparation for removing @q from make_request_fn, stop using
> > ->queuedata", I probably wouldn't have looked twice.
> >
> > For the nvdimm/ driver updates you can add:
> >
> >     Reviewed-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > ...or just let me know if you want me to pick those up through the nvdimm tree.
>
> I'd love you to pick them up through the nvdimm tree.  Do you want
> to fix up the commit message yourself?

Will do, thanks.
