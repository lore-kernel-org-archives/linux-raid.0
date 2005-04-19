From: David Greaves <david@dgreaves.com>
Subject: Re: waiting for recovery to complete
Date: Tue, 19 Apr 2005 12:16:30 +0100
Message-ID: <4264E88E.7020202@dgreaves.com>
References: <20050413085056.GP21278@eychenne.org> <4262A19A.9010909@nsr500.net> <20050419102810.GH3103@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050419102810.GH3103@eychenne.org>
Sender: linux-raid-owner@vger.kernel.org
To: rv@eychenne.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Herv=E9 Eychenne wrote:
> On Sun, Apr 17, 2005 at 10:49:14AM -0700, Tim Moore wrote:
>>The recovery daemon adjusts reconstruction speed dynamically accordin=
g to=20
>>available system resources.
>>Disk I/O is somewhat slower but works just fine.  You don't have to w=
ait.
>=20
>=20
> So I don't have to wait to take the disk out, as the recovery will
> continue with embedded disk battery and wireless bus connection?
> How cool... ;-)
Your original phrasing looked (to me too) like you thought you couldn't=
=20
use the raid whilst it was reconstructing (I'm still not convinced you=20
realise this so, to be clear: "whilst mdadm is rebuilding the array you=
=20
can use the array as normal with no risk of data corruption. You do=20
_not_ have to wait for resync to finish before remounting and using the=
=20
device.")
Tim's response told you you had no need to be alerted when it was OK=20
since you had no need to stop working in the first place.

(And why are you wanting to take a disk out after you just synced it? -=
=20
no, don't answer that...)

Now it looks like you just want to know when it's done for your own=20
peace of mind, so...
>=20
> Well... more seriously, I can't believe this question doesn't raise
> any interest, even if it seems like it does not. :-(
well, once recovery has started I don't *really* care when it finishes.
> Does everyone really type cat /proc/mdstat from time to time??
> How clumsy...
And yes, I do :)
(well, actually I optimise to <up arrow> <return>)

> I just want to chat about the best way to add a backend for this kind
> of feature, so we could implement that properly... (and yes, that is
> definitely _nedded_ if you want to do things right)
If you want to monitor _properly_ then use nagios (or monit)

Or since mdadm already uses -F to follow and notify on errors, then I=20
suggest you start hacking other alert options in there...

David

--=20
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
