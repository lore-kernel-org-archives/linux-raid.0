From: Song Liu <song@kernel.org>
Subject: Re: [RFC PATCH V3 02/10] md: remove __clear_page_buffers and use attach/detach_page_private
Date: Thu, 7 May 2020 17:47:35 -0700
Message-ID: <CAPhsuW5Z9MfS_yFbPaC7Mc8+rMkL3e_m5N_P=6bq28TLXYQpuw@mail.gmail.com>
References: <20200507214400.15785-1-guoqing.jiang@cloud.ionos.com> <20200507214400.15785-3-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200507214400.15785-3-guoqing.jiang@cloud.ionos.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, david@fromorbit.com, hch@infradead.org, Matthew Wilcox <willy@infradead.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 7, 2020 at 2:44 PM Guoqing Jiang
<guoqing.jiang@cloud.ionos.com> wrote:
>
> After introduce attach/detach_page_private in pagemap.h, we can remove
> the duplicat code and call the new functions.
>
> Cc: Song Liu <song@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

Acked-by: Song Liu <song@kernel.org>
