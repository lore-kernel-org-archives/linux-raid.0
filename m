From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Home desktop/server RAID upgrade
Date: Fri, 30 May 2014 13:14:38 -0700
Message-ID: <CAK2H+efDHKGVEdNHUXcDjbHSLKBLDu-DZTTxH9aN2vt+TLHy3A@mail.gmail.com>
References: <CAK2H+ef2YNuy9aoipDjYGWJKMi=soW393dKz00iMN8cUuBd+Og@mail.gmail.com>
	<20140530212907.0b00e8a3@netstation>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140530212907.0b00e8a3@netstation>
Sender: linux-raid-owner@vger.kernel.org
To: "L.M.J" <linuxmasterjedi@free.fr>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, May 30, 2014 at 12:29 PM, L.M.J <linuxmasterjedi@free.fr> wrote=
:
> Le Fri, 30 May 2014 12:04:07 -0700,
> Mark Knecht <markknecht@gmail.com> a =C3=A9crit :
>
>> In a RAID1 would a 3-drive Red
>> RAID1 possibly be faster than the 2-drive Se RAID1 and at the same
>> time give me more safety?
>
> Just a question inside the question : how do you manager a RAID1 with=
 3 drives ? Maybe you're talking about
> RAID5 then ?

OK, I'm no RAID expert but RAID1 is just drives in parallel right. 2
drives, 3 drives, 4 drives, all holding exactly the same data. In the
case of a 3-drive RAID1 - if there is such a beast - I could safely
lose 2 drives. You ask a reasonable question though as maybe the way
this is actually done is 2 drives + a hot spare in the box that gets
sync'ed if and only if one drive fails. Not sure and maybe I'm totally
wrong about that.

A 3-drive RAID5 would be 2 drives in series - in this case making 6TB
- and then the 3rd drive being the redundancy. In the case of a
3-drive RAID5 I could safely lose 1 drive.

In my case I don't need more than 3TB, so an option would be a 3-drive
RAID5 made out of 2TB drives which would give me 4TB but I don't need
the space as much as I want the redundancy and I think RAID5 is slower
than RAID1. Additionally some more mdadm RAID knowledgeable people on
other lists say Linux mdadm RAID1 would be faster as it will get data
from more than one drive at a time. (Or possibly get data from which
ever drive returns it the fastest. Not sure.)

I believe one good option if I wanted 4 physical drives would be
RAID10 but that's getting more complicated again which I didn't really
want to do.

So maybe it is just 2 drives and the 3 drive version isn't even a
possibility? Could be.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
