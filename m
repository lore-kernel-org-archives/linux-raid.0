From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Thoughts on using SSD
Date: Sat, 4 Apr 2009 01:28:55 +0200
Message-ID: <20090403232855.GY2449@suse.de>
References: <49CC0B0D.5000904@tmr.com> <18892.22531.392563.258229@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18892.22531.392563.258229@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2009-03-27T15:37:23, Neil Brown <neilb@suse.de> wrote:

> .... I wonder if it would make sense to mirror two partitions of the
> one SSD?? It would save you from media errors and only expose you to
> total-drive-death errors.

Depends; SSDs have different failure modes. One of them is that for
performance, memory is often interleaved and heavily remapped. So if on=
e
of the cells dies, you may in fact lose random sectors in _both_ of you=
r
partitions, so they wouldn't be independent and not necessarily make fo=
r
good RAID targets ;-)


Regards,
    Lars

--=20
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wil=
de

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
