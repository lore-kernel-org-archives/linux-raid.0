From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 12/15] md: stop using ->queuedata
Date: Wed, 13 May 2020 11:45:26 -0700
Message-ID: <CAPhsuW6pG+-EAa-FW96r+LEP=j1nWEK0Zqk_fJeaAu2Hn9AqeA@mail.gmail.com>
References: <20200508161517.252308-1-hch@lst.de> <20200508161517.252308-13-hch@lst.de>
 <CAPhsuW6_Y53_XLFeVxhTDpTi_PKNLqqnrXLn+M2fJW268eE6_w@mail.gmail.com> <20200513183304.GA29895@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200513183304.GA29895@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, linux-m68k@lists.linux-m68k.org, open list <linux-kernel@vger.kernel.org>, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, linux-nvdimm@lists.01.org
List-Id: linux-raid.ids

On Wed, May 13, 2020 at 11:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, May 13, 2020 at 11:29:17AM -0700, Song Liu wrote:
> > On Fri, May 8, 2020 at 9:17 AM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> >
> > Thanks for the cleanup. IIUC, you want this go through md tree?
>
> Yes, please pick it up though the md tree.

Thanks for the clarification. Applied to md-next.
