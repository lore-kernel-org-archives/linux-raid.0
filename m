From: Phil Turmel <philip@turmel.org>
Subject: Re: Found duplicate PV: using /dev/sda3 not /dev/md1
Date: Mon, 16 Jun 2014 16:15:05 -0400
Message-ID: <539F5049.2080407@turmel.org>
References: <1896515726.20140614235853@oudeis.org> <1454723160.20140615203503@oudeis.org> <539E5A90.3080207@turmel.org> <19411862.20140616155327@oudeis.org> <539F00AE.9090504@turmel.org> <1153494452.20140616202024@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1153494452.20140616202024@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UmFpbmVyIEbDvGdlbnN0ZWlu?= <rfu@oudeis.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/16/2014 02:20 PM, Rainer F=C3=BCgenstein wrote:

> [root@gateway ~]# umount /dev/md1
> umount: /dev/md1: not mounted

Yep, use mdadm --stop --force.

If LVM is the culprit, you'll want to stop that right away.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
