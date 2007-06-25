From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: SLES 9 SP3 and mdadm 2.6.1 (via rpm)
Date: Mon, 25 Jun 2007 15:28:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706251528050.8555@p34.internal.lan>
References: <20070612072408.19140@gmx.net> <18030.19615.898281.457910@notabene.brown>
 <20070625191731.313590@gmx.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-846606467-1182799695=:8555"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070625191731.313590@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Thorsten Wolf <T_Wolf@gmx.net>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-846606467-1182799695=:8555
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 25 Jun 2007, Thorsten Wolf wrote:

> Hello again.
>
> I've upgraded my SLES 9 SP3 system to SLES 10 (no SP1). The raid I had ru=
nning on my devices:
> /dev/hdg1   /dev/hdi1   /dev/hdk1   /dev/hde1
> doesn't work because SLES 10 does detect them as:
> /dev/sda1   /dev/sdb1   /dev/sdc1   /dev/sdd1
>
>
> I guess it's going to be simple, but can anyone give me the right syntax =
to fix this?
>
> Regards,
>
> Thorsten Wolf
>
> --=20
> Contact me on ICQ: 7656468
> skype://sysfried
>
> Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt?
> Der kanns mit allen: http://www.gmx.net/de/go/multimessenger
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

mdadm --examine --scan and use that in your mdadm.conf ?
---1463747160-846606467-1182799695=:8555--
