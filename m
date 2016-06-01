From: "Peckins, Steven E" <speckins@illinois.edu>
Subject: Re: RAID6 recovery with 6/9 drives out-of-sync
Date: Wed, 1 Jun 2016 11:32:41 +0000
Message-ID: <5D9C8773-D76E-409F-8961-41EB3ACD177A@illinois.edu>
References: <C50C72C6-FC75-4863-B743-F63F09AF93B0@illinois.edu>
 <574DE3B0.8000409@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <574DE3B0.8000409@turmel.org>
Content-Language: en-US
Content-ID: <A91A3FDE99CD8842B4FE730C65E331F8@mx.uillinois.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On May 31, 2016, at 2:19 PM, Phil Turmel <philip@turmel.org> wrote:

> On 05/30/2016 10:43 PM, Peckins, Steven E wrote:
>>=20
>> The component devices in the array are supposed to be multipath devi=
ces (dm-multipath), but for some reason, when the server was restarted,=
 md grabbed both dm-* components and raw devices.  I *think* that this =
is what caused the problem.
>=20
> Quite possible.  You probably need a DEVICES clause in your mdadm.con=
f
> to exclude the raw devices from the arrays.

I had a typo in the DEVICE glob for the system disks (/dev/sd[ab]* inst=
ead of /dev/sd[ab][12]).


>> I'm seeking advice on how to proceed at this point.  If more informa=
tion is required, please ask.
>=20
> Hmmm.  The partial success on mdadm --force suggests trying that agai=
n.
> Possible with --force twice on the command line.
>=20
> Forced assembly is precisely what you need -- don't despair and attem=
pt
> anything else.

Repeating the command was not successful; it is still reporting "/dev/m=
d10 assembled from 5 drives and 1 spare - not enough to start the array=
=2E"  Four drives are listed as =93possibly out of date."  I assume tho=
se are the four that are not being incorporated.

Output from --assemble --force 1x and 2x:  http://pastebin.com/k1dT2zYC

--steve--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
