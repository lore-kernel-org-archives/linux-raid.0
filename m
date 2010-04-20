From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID-6 polynomial
Date: Mon, 19 Apr 2010 18:55:06 -0700
Message-ID: <v2h4877c76c1004191855xaea2f8bcv6c657d90b80843e9@mail.gmail.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C0937604B@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C0937604B@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 19, 2010 at 4:44 PM, Tirumala Reddy Marri <tmarri@amcc.com>=
 wrote:
> What is the default polynomial to calculate RAID-6 syndrome in
> async_pq.c? Is it 0x11d ?
> Thanks in Advance,
> Marri
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

If you google "raid6 math" you'll get a result like this as the first r=
esult:

http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf The
Mathematics of Raid 6
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
