From: Song Liu <song@kernel.org>
Subject: Re: some questions about uploading a Linux kernel driver
Date: Wed, 8 Apr 2020 23:22:38 -0700
Message-ID: <CAPhsuW46BnFeVtnoRX9eqYL+RRfioaQYQ6q=v4W48FPA7bGVtQ@mail.gmail.com>
References: <57f88946.237df.17159c91b12.Coremail.ty-jiang18@mails.tsinghua.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57f88946.237df.17159c91b12.Coremail.ty-jiang18@mails.tsinghua.edu.cn>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?5aec5aSp5rSL?= <ty-jiang18@mails.tsinghua.edu.cn>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Apr 8, 2020 at 5:41 AM =E5=A7=9C=E5=A4=A9=E6=B4=8B <ty-jiang18@mail=
s.tsinghua.edu.cn> wrote:
>
> Hello
> I am Tianyang JIANG, a PhD student from Tsinghua U. We finish a study whi=
ch focuses on achieving consistent low latency for SSD arrays, especially t=
iming tail latency in RAID level. We implement a Linux kernel driver called=
 FusionRAID and we are interested in uploading codes to Linux upstream.
> I notice that I should seperate my changes and style-check my codes befor=
e submitting. Are there any other issues I need to be aware of? Thank you f=
or your time.

Hi,

Welcome to kernel development (I assume you are new here).

Please refer to https://kernelnewbies.org/ for information about
kernel development. Basically,
we take changes in patches. So please follow the directions on this
website. Once you are
familiar with the basic work flow, you can think about how to
integrate your work into the kernel.
If you can share some details (code, paper) about the work, the
community may give you
some hint on which direction to go.

I don't want to discourage you, but it is helpful to set the
expectation. This sounds like a lot of
work. And it is possible that we decide not to include it in upstream
kernel. However, I am sure
you can learn a lot from doing these work. :)

I hope this helps.

Thanks,
Song
