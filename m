From: Nebojsa Trpkovic <trx.lists@gmail.com>
Subject: Re: TLER / CCTL timeout handling
Date: Thu, 25 Mar 2010 01:48:40 +0100
Message-ID: <4BAAB2E8.2040104@gmail.com>
References: <4BA93C3F.2070208@gmail.com> <4BAA8A21.8050601@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BAA8A21.8050601@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de
Cc: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?= <stefan.huebner@stud.tu-ilmenau.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/24/10 22:54, Stefan /*St0fF*/ H=FCbner wrote:
> Am 23.03.2010 23:10, schrieb Nebojsa Trpkovic:
>> Hello.
>>
>> I've found interesting text about TLER / CCTL
>> (http://en.wikipedia.org/wiki/Time-Limited_Error_Recovery )
>=20
> You might want to read on inside the ATA8-ACS, section about SCT Tran=
sport.
>>
>> on desktop class drives:
>> http://forums.storagereview.com/index.php/topic/28333-tler-cctl/
>>
>> So, the question is:
>>
>> If I make my drive report back it failed to read the requested secto=
r,
>> how that report will be handeled?
>=20
> As far as I understood in recent answers to my questions: as expected=
=2E
>>
>> Will Linux software RAID be aware of that report and start some acti=
on
>> (rebuilding affected stripe or at least whole array, reallocating ba=
d
>> sectors along the way) ?
>>
> Indeed.  Michael Tokarev answered to me on 2/9/10:
> "On failed _read_ it tries to
> reconstruct data from other disk drives and writes the reconstructed
> data back to the drive where read failed.  If the _write_ fails md wi=
ll
> drop the disk."
>=20
> This means: if read fails and the drive does not report back, the
> following reconstructing write calls will fail, too.  The disk gets
> dropped, because it (most probably) is still doing its error recovery=
 on
> the former read request and by that not responding.
>=20
> If you enable ERC read timeouts, it'll report a media error (or
> something similar), but honour the write request.  If you give the ER=
C
> write timeout a value that is not too small and also not too large (i=
=2Ee.
> it shouldn't timeout the write-operation from the view of the kernel)=
,
> it will either fix the pending sector, or reallocate it.  If the ERC
> write timeout value is too small, it'll very aggressively reallocate
> sectors - which should not be the intention, as there are very few sp=
are
> sectors (compared to the amount of sectors in total - only a few thou=
sand).
>>
>> Thank you.
>> Nebojsa Trpkovic
>=20
> You're welcome, and all the best,
> Stefan
>=20

Thank you very much!

This is great answer (explaining a lot of things) and great news
(there's nothing to worry/hack about).

So, now we (desktop drives users) just have to wait for smartmontools
5.40 or pull source from SVN and set some reasonable ERC read timeouts.

Is value of 7 seconds considered as reasonable ERC read timeout?

Nebojsa
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
