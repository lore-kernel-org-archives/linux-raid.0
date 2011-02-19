From: Larry Schwerzler <larry@schwerzler.com>
Subject: Re: Raid selection questions (10 vs 6, n2 vs f2) on an 8 drive array
Date: Fri, 18 Feb 2011 17:53:06 -0800
Message-ID: <AANLkTimpDXmRLxCQp6=BRJqf_EFbTEgZujQU9EyweywS@mail.gmail.com>
References: <AANLkTi=2xjjuvT3tTs1Y9Qfrn6HxWS3hwzF-Q0ZhPFVM@mail.gmail.com>
 <4D5F0458.3060403@hardwarefreak.com> <20110219005439.GA3251@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110219005439.GA3251@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2011/2/18 Keld J=F8rn Simonsen <keld@keldix.com>:
> On Fri, Feb 18, 2011 at 05:44:24PM -0600, Stan Hoeppner wrote:
>> Larry Schwerzler put forth on 2/18/2011 2:55 PM:
>>
>> > 1. In my research of raid10 I very seldom hear of drive configurat=
ions
>> > with more drives then 4, are there special considerations with hav=
ing
>> > an 8 drive raid10 array? I understand that I'll be loosing 2TB of
>> > space from my current setup, but i'm not too worried about that.
>>
>> This is because Linux mdraid is most popular with the hobby crowd, n=
ot
>> business, and most folks in this segment aren't running more than 4
>> drives in a RAID 10. =A0For business solutions using embedded Linux =
and
>> mdraid, mdraid is typically hidden from the user who isn't going to =
be
>> writing posts on the net about mdraid. =A0He calls his vendor for su=
pport.
>> =A0In a nutshell, that's why you see little or no posts about mdraid=
 10
>> arrays larger than 4 drives.
>
> well on https://raid.wiki.kernel.org/index.php/Performance
> there are several performance reports with 6 or 10 spindles, so there=
=2E..
>
> For an 8 drive Linux MD raid10 maybe you should consider a motherboar=
d
> with 8 sata ports.
>
While I have considered getting a new case that can hold 8 drives +
system drive + cd rom I always had trouble finding them. There are no
doubt better setups then mine, but Im trying to not buy new hardware
if I can get away with it.
> Best regards
> keld
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
