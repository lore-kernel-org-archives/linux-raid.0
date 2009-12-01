From: David Rees <drees76@gmail.com>
Subject: Re: MAX IOPS - s/w scaling issues?
Date: Mon, 30 Nov 2009 19:07:43 -0800
Message-ID: <72dbd3150911301907y6606deddh954a03dccb7d1b56@mail.gmail.com>
References: <7E302F0A-135C-434F-8D56-A71B625106FA@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7E302F0A-135C-434F-8D56-A71B625106FA@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arun Jagatheesan <arun.jagatheesan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 30, 2009 at 6:24 PM, Arun Jagatheesan
<arun.jagatheesan@gmail.com> wrote:
> We are trying some experiments on our linux raid. We are having bottl=
eneck
> in scaling the RAID after ~250K IOPS. =A0Is there a known issue of s/=
w max
> limit or is it simply an issue of configuration?
>
> We have (16 x 64G) SSDs on a RAID0. Our IOPS on this RAID0 stops at 2=
50K
> (even with lesser or more SSD drives). =A0 =A0Whereas we get 540K IOP=
S with the
> same number of SSDs (RAW no RAID). We find a linear scale-up for each=
 SSD we
> add to RAID0 until we reach ~250K IOPS limit. After the RAID0 reaches=
 this
> limit, its just a straight line plateau with no increase in performan=
ce.

What are the specs of the rest of the system, and was does top/vmstat l=
ook like?

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
