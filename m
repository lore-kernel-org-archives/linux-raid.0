From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 17:18:46 +1200
Message-ID: <487D84B6.60908@sauce.co.nz>
References: <1216130769.5633.318.camel@sam.localdomain> <20080715163932.GA23164@rap.rap.dk> <8CAB4B2168C7183-B68-AD2@webmail-ng19.sysops.aol.com> <20080715173927.GA24745@rap.rap.dk> <487D3A44.7000008@sauce.co.nz> <20080716042336.GB7148@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080716042336.GB7148@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:

> My understanding tho, is that the IO output and input figures are on
> sequential IO. There are no figures on random IO,

If you look at some results Justin posted:

http://home.comcast.net/~jpiszcz/20080707/veliciraptors_with_x4.html

The column "Random Create" shows performance for randomly creating,=20
reading and deleting 16384 files sized between 16bytes and 1MB=20
distributed randomly through 64 directories (this is the -n parameter=20
and is shown in the "Num Files" column.)

Regards,

Richard
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
