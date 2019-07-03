From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH] md-multipath: Replace a seq_printf() call by seq_putc()
 in multipath_status()
Date: Wed, 3 Jul 2019 05:17:54 -0700
Message-ID: <CAPhsuW7CAfu07Y319eHUUi3Ln422-jMmpTHmy0rT+MxZnO8BBA@mail.gmail.com>
References: <ad2e4b58-268e-c9e5-8a66-8cb5dee8d91e@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ad2e4b58-268e-c9e5-8a66-8cb5dee8d91e@web.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 1, 2019 at 5:25 AM Markus Elfring <Markus.Elfring@web.de> wrote=
:
>
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 1 Jul 2019 13:07:55 +0200
>
> A single character (depending on a condition check) should be put
> into a sequence. Thus use the corresponding function =E2=80=9Cseq_putc=E2=
=80=9D.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Can you explain why this is necessary?

Thanks,
Song
