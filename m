From: "Thorsten Wolf" <T_Wolf@gmx.net>
Subject: Re: SLES 9 SP3 and mdadm 2.6.1 (via rpm)
Date: Mon, 25 Jun 2007 21:17:31 +0200
Message-ID: <20070625191731.313590@gmx.net>
References: <20070612072408.19140@gmx.net>
 <18030.19615.898281.457910@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18030.19615.898281.457910@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hello again.

I've upgraded my SLES 9 SP3 system to SLES 10 (no SP1). The raid I had =
running on my devices:
/dev/hdg1   /dev/hdi1   /dev/hdk1   /dev/hde1
doesn't work because SLES 10 does detect them as:
/dev/sda1   /dev/sdb1   /dev/sdc1   /dev/sdd1


I guess it's going to be simple, but can anyone give me the right synta=
x to fix this?

Regards,

Thorsten Wolf

--=20
Contact me on ICQ: 7656468
skype://sysfried

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt?
Der kanns mit allen: http://www.gmx.net/de/go/multimessenger
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
