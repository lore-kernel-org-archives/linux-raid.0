From: Chris Allen <chris@cjx.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Fri, 23 Jun 2006 16:17:15 +0100
Message-ID: <449C05FB.2010101@cjx.com>
References: <449AEB7C.6040108@cjx.com> <op.tblclqd3cigqcu@apollo13>	 <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com>	 <449BE381.6070000@cjx.com>	 <fd8d0180606230630x3f6b1ab7g444716cf8d5ab2c2@mail.gmail.com> <68c491a60606230746m5c1f0301g8e00fdd4f0e0739b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <68c491a60606230746m5c1f0301g8e00fdd4f0e0739b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Martin_Schr=F6der?= <martin@oneiros.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Martin Schr=F6der wrote:
> 2006/6/23, Francois Barre <francois.barre@gmail.com>:
>> Loosing data is worse than loosing anything else. You can buy you
>
> That's why RAID is no excuse for backups.
>
>
We have 50TB stored data now and maybe 250TB this time next year.
We mirror the most recent 20TB to a secondary array and rely on
the RAID for the rest.

I can't think of a practical tape backup strategy given tape sizes at=20
the moment...


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
