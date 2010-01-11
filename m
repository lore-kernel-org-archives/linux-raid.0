From: "Majed B." <majedb@gmail.com>
Subject: Re: raid failure question
Date: Mon, 11 Jan 2010 21:08:57 +0300
Message-ID: <70ed7c3e1001111008y76b49b8bve2b636c90efa4a72@mail.gmail.com>
References: <1263232840.8962.193.camel@kije>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1263232840.8962.193.camel@kije>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Bock <jtbock@daylight.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Voltage spikes, disks heating (monitored by smartd) & sector
corruption (monitored by smartd) are what I can think of for the time
being.

On Mon, Jan 11, 2010 at 9:00 PM, Tim Bock <jtbock@daylight.com> wrote:
> Hello,
>
> Excluding the obvious multi-disk or bus failures, can anyone describe
> what type of disk failure a raid cannot detect/recover from?
>
> I have had two disk failures over the last three months, and in spite=
 of
> having a hot spare, manual intervention was required each time to mak=
e
> the raid usable again. =C2=A0I'm just not sure if I'm not setting som=
ething
> up right, or if there is some other issue.
>
> Thanks for any comments or suggestions.
>
> Tim
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
