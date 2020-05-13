From: Song Liu <song@kernel.org>
Subject: Re: [PATCH] md/raid1: Replace zero-length array with flexible-array
Date: Wed, 13 May 2020 12:07:03 -0700
Message-ID: <CAPhsuW5auRH2K5YyxGL6P4sy7hugF1N2s3AVj7GYOj_9EWKmFA@mail.gmail.com>
References: <20200507192209.GA16290@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200507192209.GA16290@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 7, 2020 at 12:17 PM Gustavo A. R. Silva
<gustavoars@kernel.org> wrote:
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

[...]

>
> This issue was found with the help of Coccinelle.
>
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied to md-next. Thanks!
