From: Anthonys Lists <antlists@youngman.org.uk>
Subject: Re: RAID1 degraded
Date: Tue, 04 Aug 2015 15:38:39 +0100
Message-ID: <55C0CE6F.20600@youngman.org.uk>
References: <AA2DC53A-A663-45CE-A8FE-DF6C8C285F37@me.com> <55BFFDD3.5000005@websitemanagers.com.au> <478DB4ED-9FAB-4035-A482-0BC11046B6C2@me.com> <55C0409E.5010004@websitemanagers.com.au> <14A646FC-54F8-4A2E-978D-49800FB534CF@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14A646FC-54F8-4A2E-978D-49800FB534CF@me.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Malissa <hmalissa@me.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/08/2015 06:55, Hans Malissa wrote:
> Thanks a lot for your help!
> Rebooting the system didn=92t solve the problem, /dev/sdc is still no=
where to be found.
> So I will have to replace /dev/sdc.
> I tried to learn a bit about SRC/ERC from list archives, and it seems=
 like my hard drives (1TB Seagate Barracuda=92s) don=92t support this o=
ption:
>
> # smartctl -l scterc /dev/sdb
> smartctl 6.0 2012-10-10 r3643 [x86_64-linux-3.7.10-1.45-desktop] (SUS=
E RPM)
> Copyright (C) 2002-12, Bruce Allen, Christian Franke,www.smartmontool=
s.org
>
> SCT Error Recovery Control command not supported
I've got Seagate Barracudas (the 3TB version) and was a bit miffed to=20
realise that they didn't support this. That said, with mirrored 1TB=20
drives, you shouldn't have any real problems with SRC/ERC - the problem=
=20
is that a drive that returns 1 error per 10TB read is within spec, if=20
your array is over that size, then "good" drives could well cause a=20
crashed array if you have any glitches. (It seems that most drives are=20
well over spec, but why run the risk).

If you're price-conscious, WD Reds are not much more expensive than=20
Barracudas, and are advertised as "good for RAID". I'm looking at them=20
for my next hard drives.

Cheers,
Wol
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
