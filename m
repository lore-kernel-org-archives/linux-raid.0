From: mark delfman <markdelfman@googlemail.com>
Subject: =?windows-1252?Q?Re=3A_MD_performance_options=3A_More_CPU=92s_or_more_Hz?=
	=?windows-1252?Q?=92s=3F?=
Date: Wed, 4 Nov 2009 17:26:44 +0000
Message-ID: <66781b10911040926i20ebdc5x27fa113562705890@mail.gmail.com>
References: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com>
	 <4AF18A39.6010404@tmr.com>
	 <66781b10911040634mcdc3c70jec3410c09003fb6c@mail.gmail.com>
	 <4AF1A0B8.2080807@hp.com> <4AF1A1B4.2030405@hp.com>
	 <4AF1A446.700@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF1A446.700@hp.com>
Sender: linux-raid-owner@vger.kernel.org
To: jim owens <jowens@hp.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Jim,

I think this is a great point... i had not thought of the extra two
chunks of data being written... BUT, not sure if in this case it is
the limiter as we are using 12 drives.




the hardware does bottleneck at around 1.6GBs for writes (reaches this
with 8 / 9 drives).




On Wed, Nov 4, 2009 at 3:56 PM, jim owens <jowens@hp.com> wrote:
> jim owens wrote:
>>>
>>> So the proper comparison of raid6 software overhead is to
>>> run the same application writing a fixed large amount of data
>>> to 4 drives at raid0 and the same 4 drives at raid6.
>
> Actually, it is probably better to run the application with
>
> =A02 X data to raid0 and 1 X data to raid6
>
> so the amount of written disk data is the same.
>
> That way the comparison will remove the bus/disk difference
> caused by sending different amounts of data and:
>
> overhead =3D raid6_time - raid0_time;
>
> jim
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
