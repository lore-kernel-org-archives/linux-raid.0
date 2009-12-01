From: "Majed B." <majedb@gmail.com>
Subject: Re: MAX IOPS - s/w scaling issues?
Date: Tue, 1 Dec 2009 07:05:33 +0300
Message-ID: <70ed7c3e0911302005g1684e02ftc7246e805467a5e2@mail.gmail.com>
References: <7E302F0A-135C-434F-8D56-A71B625106FA@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7E302F0A-135C-434F-8D56-A71B625106FA@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arun Jagatheesan <arun.jagatheesan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keep an eye on CPU and RAM utilization. You may be hitting a bottleneck=
 there.

Have you tried changing the queue depth of each SSD?
This may be of interest to you: http://linux-raid.osdl.org/index.php/Pe=
rformance

On Tue, Dec 1, 2009 at 5:24 AM, Arun Jagatheesan
<arun.jagatheesan@gmail.com> wrote:
>
> We are trying some experiments on our linux raid. We are having bottl=
eneck in scaling the RAID after ~250K IOPS. =C2=A0Is there a known issu=
e of s/w max limit or is it simply an issue of configuration?
>
> We have (16 x 64G) SSDs on a RAID0. Our IOPS on this RAID0 stops at 2=
50K (even with lesser or more SSD drives). =C2=A0 =C2=A0Whereas we get =
540K IOPS with the same number of SSDs (RAW no RAID). We find a linear =
scale-up for each SSD we add to RAID0 until we reach ~250K IOPS limit. =
After the RAID0 reaches this limit, its just a straight line plateau wi=
th no increase in performance.
>
> Is there any known issue of the maximum IOPS the s/w can handle?
>
> Cheers,
> Arun
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml



--
=C2=A0 =C2=A0 =C2=A0 Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
