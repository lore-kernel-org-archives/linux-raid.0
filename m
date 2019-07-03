From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: md-multipath: Replace a seq_printf() call by seq_putc() in
 multipath_status()
Date: Wed, 3 Jul 2019 18:28:40 +0200
Message-ID: <3ae39471-e1d2-2e2a-984a-888340e84447@web.de>
References: <ad2e4b58-268e-c9e5-8a66-8cb5dee8d91e@web.de>
 <CAPhsuW7CAfu07Y319eHUUi3Ln422-jMmpTHmy0rT+MxZnO8BBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW7CAfu07Y319eHUUi3Ln422-jMmpTHmy0rT+MxZnO8BBA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Song Liu <liu.song.a23@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
Cc: Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

>> A single character (depending on a condition check) should be put
>> into a sequence. Thus use the corresponding function =E2=80=9Cseq_putc=
=E2=80=9D.
=E2=80=A6
> Can you explain why this is necessary?

I suggest another bit of software fine-tuning.

* Pass only a relevant character instead of a string.

* Omit the format string for a function parameter.

Regards,
Markus
