From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Performance question
Date: Wed, 21 Jan 2009 14:05:42 +1300
Message-ID: <497674E6.50405@sauce.co.nz>
References: <20090117171806.GA9432@lazy.lzy> <20090117220849.GB29866@rap.rap.dk> <20090119181253.GA4290@lazy.lzy> <20090121001503.GA26587@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090121001503.GA26587@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:

> For other arrays I think one important choice is if you have an array
> greater than 2 TiB to not use 0.90 metadata, as this has a limit of 2
> TiB.

This restriction only applies if the individual members of the array ar=
e=20
larger than 2TB each.

Regards,

Richard
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
