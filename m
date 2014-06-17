From: Phil Turmel <philip@turmel.org>
Subject: Re: Found duplicate PV: using /dev/sda3 not /dev/md1
Date: Tue, 17 Jun 2014 07:57:00 -0400
Message-ID: <53A02D0C.90409@turmel.org>
References: <1896515726.20140614235853@oudeis.org> <1454723160.20140615203503@oudeis.org> <539E5A90.3080207@turmel.org> <19411862.20140616155327@oudeis.org> <539F00AE.9090504@turmel.org> <1153494452.20140616202024@oudeis.org> <539F5049.2080407@turmel.org> <145561825.20140616222858@oudeis.org> <539F5970.3060504@turmel.org> <1353040832.20140617032748@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1353040832.20140617032748@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UmFpbmVyIEbDvGdlbnN0ZWlu?= <rfu@oudeis.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/16/2014 09:27 PM, Rainer F=C3=BCgenstein wrote:
> phil,
>=20
> PT> Look in /sys/block/md1/holders/
>=20
> [root@gateway md1]# cd holders/
> [root@gateway holders]# ls -lh
> total 0
> lrwxrwxrwx 1 root root 0 Jun 16 23:11 dm-0 -> ../../../block/dm-0
> lrwxrwxrwx 1 root root 0 Jun 16 23:11 dm-1 -> ../../../block/dm-1
> lrwxrwxrwx 1 root root 0 Jun 16 23:11 dm-2 -> ../../../block/dm-2
> [root@gateway holders]#
>=20
> not sure what that means?

It means that LVM is indeed using the scrambled array for those devices=
=2E
 Use "dmsetup ls" to identify them.

That also means my previous advice is wrong--you can't just shut it off=
=2E
 It would be helpful if you could run "lsdrv" [1] on your system and
report the results here.

Phil

[1] http://github.com/pturmel/lsdrv
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
