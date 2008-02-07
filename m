From: Neil Brown <neilb@suse.de>
Subject: Re: recommendations for stripe/chunk size
Date: Thu, 7 Feb 2008 16:51:22 +1100
Message-ID: <18346.40026.149635.800694@notabene.brown>
References: <47AA08E7.5000801@tmr.com>
	<20080206202536.3316124D1D@gemini.denx.de>
	<20080207003116.GA23341@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Keld Jorn Simonsen on Thursday February 7
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: Wolfgang Denk <wd@denx.de>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 7, keld@dkuug.dk wrote:
>=20
> Anyway, why does a SATA-II drive not deliver something like 300 MB/s?


Are you serious?

I high end 15000RPM enterprise grade drive such as the Seagate
Cheetah=AE 15K.6 Hard Drives only deliver 164MB/sec.

The SATA Bus might be able to deliver 300MB/s, but an individual drive
would be around 80MB/s unless it is really expensive.

(or was that yesterday?  I'm having trouble keeping up with the pace
 of improvement :-)

NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
