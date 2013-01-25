From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Failing to grow raid10 with one larger disk
Date: Fri, 25 Jan 2013 00:43:23 +0000
Message-ID: <CADNH=7H+r25QRY0RekU+ukG=s-TT9FNfMnfctj=oKniPiYL0-Q@mail.gmail.com>
References: <CAOHBbgU5Uf+eD=O7_0K1AKn_t+RcdaeAQabf9XSST8qtcbaAsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOHBbgU5Uf+eD=O7_0K1AKn_t+RcdaeAQabf9XSST8qtcbaAsw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Asif Iqbal <vadud3@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 25 January 2013 00:33, Asif Iqbal <vadud3@gmail.com> wrote:
> Replaced one of the 6 72G disks from raid10 with a 300G disk.
>
> But failing to grow the md10
>
> # mdadm --grow /dev/md10 --size max
> mdadm: raid10 array /dev/md10 cannot be reshaped.
>
> What gives?
>
> --
> Asif Iqbal
> PGP Key: 0xE62693C5 KeyServer: pgp.mit.edu
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

What did you expect?

Mathias
