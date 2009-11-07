From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Raid Degradation best practices
Date: Sat, 7 Nov 2009 06:51:06 -0500 (EST)
Message-ID: <alpine.DEB.2.00.0911070650380.4559@p34.internal.lan>
References: <4AF41AFB.3000302@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF41AFB.3000302@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: linux-raid@vger.kernel.org, nfbrown@novell.com
List-Id: linux-raid.ids



On Fri, 6 Nov 2009, Andrew Dunn wrote:

> This morning my array lost a drive, then another. This was not due to
> drive failures of hardware issues.
>
> I did not have any data on the array so I wiped the drives and
> re-created it. So far everything seems fine.
>
> I would like to know what some of your practices are for the scenario
> where you loose a drive or more on a mission critical array. I chose the
> newbish route because I didn't have enough time or expertise to diagnose
> the problems further. Typically this means it will happen again, and I
> will still be unprepared.
>
> Would appreciate your input, thanks.
>
> -- 
> Andrew Dunn
> http://agdunn.net
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

How did you lose the drives then?

If it is a mission-critical array, what RAID type are you using?

Are you backing up the data regularly, since it is mission-critical?

Justin.
