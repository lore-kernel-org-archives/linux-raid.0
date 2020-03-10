From: Song Liu <song@kernel.org>
Subject: Re: [PATCH][next] md: Replace zero-length array with flexible-array member
Date: Tue, 10 Mar 2020 14:44:45 -0700
Message-ID: <CAPhsuW7tP3qfiY_kppSBBPXtNs27uGKcTsR9mZGULtQSCaNbQg@mail.gmail.com>
References: <20200226221804.GA8564@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200226221804.GA8564@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, open list <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Feb 26, 2020 at 2:16 PM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
>
> struct foo {
>         int stuff;
>         struct boo array[];
> };
>
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
>
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
>
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
>
> This issue was found with the help of Coccinelle.
>
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

For md part: Acked-by: Song Liu <song@kernel.org>

Alasdair and Mike, would you like to route the patch via dm tree?

Thanks,
Song
