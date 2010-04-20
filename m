From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID-6 polynomial
Date: Mon, 19 Apr 2010 21:39:33 -0700
Message-ID: <s2n4877c76c1004192139ibe81aefbjfb934a0330dc8236@mail.gmail.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C0937604B@SDCEXCHANGE01.ad.amcc.com>
	 <v2h4877c76c1004191855xaea2f8bcv6c657d90b80843e9@mail.gmail.com>
	 <AC5E1C3367E37D44970B81A6ADD1DA2C09376090@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C09376090@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 19, 2010 at 8:14 PM, Tirumala Reddy Marri <tmarri@amcc.com>=
 wrote:
> I understand the RAID-6 or GF(2) math. There is a test code crypto/as=
ync_tx/raid6test.c which make calls to async_gen_syncdrome() in turn ca=
lls raid6_int4_gen_syndrome(). I could not find which polynomial this c=
ode is using.
> -Marri
>
>
> -----Original Message-----
> From: Michael Evans [mailto:mjevans1983@gmail.com]
> Sent: Monday, April 19, 2010 6:55 PM
> To: Tirumala Reddy Marri
> Cc: linux-raid@vger.kernel.org
> Subject: Re: RAID-6 polynomial
>
> On Mon, Apr 19, 2010 at 4:44 PM, Tirumala Reddy Marri <tmarri@amcc.co=
m> wrote:
>> What is the default polynomial to calculate RAID-6 syndrome in
>> async_pq.c? Is it 0x11d ?
>> Thanks in Advance,
>> Marri
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> If you google "raid6 math" you'll get a result like this as the first=
 result:
>
> http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf The
> Mathematics of Raid 6
>

Please bottom-reply for kernel.org lists.

Would the hex you stated match the polynomial described in the 12 page
(IIRC) PDF I linked?
0x11d would be, in binary, (h)100011101(l); I'm not sure if it
presumes the 0th power being set or not.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
