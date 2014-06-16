From: Phil Turmel <philip@turmel.org>
Subject: Re: Found duplicate PV: using /dev/sda3 not /dev/md1
Date: Mon, 16 Jun 2014 16:54:08 -0400
Message-ID: <539F5970.3060504@turmel.org>
References: <1896515726.20140614235853@oudeis.org> <1454723160.20140615203503@oudeis.org> <539E5A90.3080207@turmel.org> <19411862.20140616155327@oudeis.org> <539F00AE.9090504@turmel.org> <1153494452.20140616202024@oudeis.org> <539F5049.2080407@turmel.org> <145561825.20140616222858@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <145561825.20140616222858@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UmFpbmVyIEbDvGdlbnN0ZWlu?= <rfu@oudeis.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/16/2014 04:28 PM, Rainer F=C3=BCgenstein wrote:
>=20
> PT> Yep, use mdadm --stop --force.
>=20
> unfortunately, same result:
>=20
> [root@gateway ~]# mdadm --stop --force /dev/md1
> mdadm: fail to stop array /dev/md1: Device or resource busy
> Perhaps a running process, mounted filesystem or active volume group?

Look in /sys/block/md1/holders/

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
