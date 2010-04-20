From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: RAID-6 polynomial
Date: Mon, 19 Apr 2010 20:14:57 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C09376090@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C0937604B@SDCEXCHANGE01.ad.amcc.com> <v2h4877c76c1004191855xaea2f8bcv6c657d90b80843e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <v2h4877c76c1004191855xaea2f8bcv6c657d90b80843e9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I understand the RAID-6 or GF(2) math. There is a test code crypto/asyn=
c_tx/raid6test.c which make calls to async_gen_syncdrome() in turn call=
s raid6_int4_gen_syndrome(). I could not find which polynomial this cod=
e is using.
-Marri


-----Original Message-----
=46rom: Michael Evans [mailto:mjevans1983@gmail.com]=20
Sent: Monday, April 19, 2010 6:55 PM
To: Tirumala Reddy Marri
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID-6 polynomial

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
