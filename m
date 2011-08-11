From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: single cpu thread performance limit?
Date: Thu, 11 Aug 2011 21:04:12 +0200
Message-ID: <4E4427AC.6070005@fastmail.fm>
References: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/11/2011 05:58 PM, mark delfman wrote:
> I seem to have hit a significant hard stop in MD RAID1/10 performance
> which seems to be linked to a single CPU thread.
>
> I am using extremely high speed (IOPS) internal block devices =96 8 i=
n
> total.  They are capable of achieving>  1million iops.
>
> However if I use RAID1 / 10 then MD seems to use a single thread whic=
h
> will reach 100% CPU utilisation (single core) at around 200K IOPS.
> Limiting the entire performance to around 200K.
>

Out of interest, could you please run "perf top" to let us see where th=
e=20
kernel is busy?

Thanks,
Bernd
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
