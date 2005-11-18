From: Mike Hardy <mhardy@h3c.com>
Subject: Re: raid5 write performance
Date: Fri, 18 Nov 2005 11:23:47 -0800
Message-ID: <437E2A43.4090207@h3c.com>
References: <20051118150543.59fbdfd9.pegasus@nerv.eu.org> <1132341596.28924.10.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1132341596.28924.10.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Cc: =?ISO-8859-2?Q?Jure_Pe=E8ar?= <pegasus@nerv.eu.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Moreover, and I'm sure Neil will chime in here, isn't the clean/unclean
thing designed to prevent this exact scenario?

The array is marked unclean immediately prior to write, then the write
and parity write happens, then the array is marked clean.

If you crash during the write but before parity is correct, the array i=
s
unclean and you resync (quickly now thanks to intent logging if you hav=
e
that on)

The non-parity blocks that were partially written are then the
responsibility of your journalling filesystem, which should make sure
there is no corruption, silent or otherwise.

If I'm misunderstanding that, I'd love to be corrected. I was under the
impression that the "silent corruption" issue was mythical at this poin=
t
and if it's not I'd like to know.

-Mike

Dan Stromberg wrote:
> Would it really be that much slower to have a journal of RAID 5 write=
s?
>=20
> On Fri, 2005-11-18 at 15:05 +0100, Jure Pe=E8ar wrote:
>=20
>>Hi all,
>>
>>Currently zfs is a major news in the storage area. It is very interes=
ting to read various details about it on varios blogs of Sun employees.=
 Among the more interesting I found was this:
>>
>>http://blogs.sun.com/roller/page/bonwick?entry=3Draid_z
>>
>>The point the guy makes is that it is impossible to atomically both w=
rite data and update parity, which leaves a window of crash that would =
silently leave on-disk data+paritiy in an inconsistent state. Then he m=
entions that there are software only workarounds for that but that they=
 are very very slow.
>>
>>It's interesting that my expirience with veritas raid5 for example is=
 just that: slow to the point of being unuseable. Now, I'm wondering wh=
at kind of magic does linux md raid5 does, since its write performance =
is quite good? Or, does it actually do something regarding this? :)
>>
>>Niel?
>>
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
