From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Checking consistency of Linux software RAID
Date: Mon, 30 Jun 2003 15:16:33 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030630131633.GD12240@marowsky-bree.de>
References: <4D618F6493CE064A844A5D496733D667031A01@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D618F6493CE064A844A5D496733D667031A01@freedom.icomedias.com>
To: Martin Bene <martin.bene@icomedias.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-06-30T14:58:19,
   Martin Bene <martin.bene@icomedias.com> said:

> Scheduling a (weekly) complete media scan where all surfaces of all d=
rives
> get read; in case of read errors a repair is tried: the content for t=
he
> failed sector is reconstructed just as if the drive had completely fa=
iled and
> rewritten to the failed sector; if reading works afterwards, regard t=
he
> repair as successfull and continue using the drive.

This can't currently be done.

I'd suggest to start from the resync code and instead use it to check
instead; add an ioctl to trigger the consistency scan, then you can
schedule it via cron all you like.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)=
=2E"
  -- Capt. Edward A. Murphy            -- Louis Pasteur
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
