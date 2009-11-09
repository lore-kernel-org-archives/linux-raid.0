From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Mon, 9 Nov 2009 09:42:11 -0600
Message-ID: <cccedfc60911090742x5ac85a5axcf93d5cb9f6f6539@mail.gmail.com>
References: <19187.50708.551325.297625@notabene.brown> <4AF829B2.5090001@redhat.com>
	<4AF836F8.5040903@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF836F8.5040903@panix.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 9, 2009 at 9:36 AM, berk walker <berk@panix.com> wrote:
> Doug Ledford wrote:
>> Although the cause for this sucks, I was actually going to suggest t=
hat
>> since 3.1 is a version bump, that we take the opportunity to change =
a
>> few defaults. =A0Like switching to version 1 superblocks instead of
>> version 0 by default. =A0And changing the default chunk size to 512k
>> instead of 64k. =A0The time has simply come for the 0->1 superblock
>> change, and I have a good deal of data showing that for SATA disks a=
t
>> least, the 512k chunk size is the typical sweet =A0spot.
>>
> =A0+1

+1 here, too.

I've been using 1.1 for everything.  What's the current wisdom
regarding 1.0 vs 1.1 or 1.2?
I used 1.1 because that's also where filesystem metadata usually goes
and therefore one might hope that the presence of the md metadata
would prevent accidental identification of a raid volume as containing
a filesystem.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
