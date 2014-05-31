From: David Brown <david.brown@hesbynett.no>
Subject: Re: Home desktop/server RAID upgrade
Date: Sat, 31 May 2014 12:52:19 +0200
Message-ID: <5389B463.5020100@hesbynett.no>
References: <CAK2H+ef2YNuy9aoipDjYGWJKMi=soW393dKz00iMN8cUuBd+Og@mail.gmail.com>	<20140530212907.0b00e8a3@netstation> <CAK2H+efDHKGVEdNHUXcDjbHSLKBLDu-DZTTxH9aN2vt+TLHy3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+efDHKGVEdNHUXcDjbHSLKBLDu-DZTTxH9aN2vt+TLHy3A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>, "L.M.J" <linuxmasterjedi@free.fr>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/05/14 22:14, Mark Knecht wrote:
> On Fri, May 30, 2014 at 12:29 PM, L.M.J <linuxmasterjedi@free.fr>
> wrote:
>> Le Fri, 30 May 2014 12:04:07 -0700, Mark Knecht
>> <markknecht@gmail.com> a =C3=A9crit :
>>
>>> In a RAID1 would a 3-drive Red RAID1 possibly be faster than the
>>> 2-drive Se RAID1 and at the same time give me more safety?
>>
>> Just a question inside the question : how do you manager a RAID1
>> with 3 drives ? Maybe you're talking about RAID5 then ?
>
> OK, I'm no RAID expert but RAID1 is just drives in parallel right. 2
> drives, 3 drives, 4 drives, all holding exactly the same data. In
> the case of a 3-drive RAID1 - if there is such a beast - I could
> safely lose 2 drives. You ask a reasonable question though as maybe
> the way this is actually done is 2 drives + a hot spare in the box
> that gets sync'ed if and only if one drive fails. Not sure and maybe
> I'm totally wrong about that.
>
> A 3-drive RAID5 would be 2 drives in series - in this case making
> 6TB - and then the 3rd drive being the redundancy. In the case of a
> 3-drive RAID5 I could safely lose 1 drive.
>
> In my case I don't need more than 3TB, so an option would be a
> 3-drive RAID5 made out of 2TB drives which would give me 4TB but I
> don't need the space as much as I want the redundancy and I think
> RAID5 is slower than RAID1. Additionally some more mdadm RAID
> knowledgeable people on other lists say Linux mdadm RAID1 would be
> faster as it will get data from more than one drive at a time. (Or
> possibly get data from which ever drive returns it the fastest. Not
> sure.)
>
> I believe one good option if I wanted 4 physical drives would be
> RAID10 but that's getting more complicated again which I didn't
> really want to do.
>
> So maybe it is just 2 drives and the 3 drive version isn't even a
> possibility? Could be.

With 3 drives, you have several possibilities.

Raid5 makes "stripes" across the three drives, with 2 parts holding dat=
a=20
and one part holding parity to provide redundancy.

Raid1 is commonly called "mirroring", because you get the same data on=20
each disk.  md raid has no problem making a 3-way mirror, so that each=20
disk is identical.  This gives you excellent redundancy, and you can=20
make three different reads in parallel - but writes have to go to each=20
disk, which can be a little slower than using 2 disks.  It's not often=20
that people need that level of redundancy.

Another option with md raid is the raid10 setups.  For many uses, the=20
fastest arrangement is raid10,f2.  This means there is two copies of al=
l=20
your data (f3 would be three copies), with a "far" layout.

<http://en.wikipedia.org/wiki/Linux_MD_RAID_10#LINUX-MD-RAID-10>

With this arrangement, reads are striped across all three disks, which=20
is fast for large reads.  Small reads can be handled in parallel.  Most=
=20
reads while be handled from the outer half of the disk, which is faster=
=20
and needs less head movement - so reading is on average faster than a=20
raid0 on the same disks.  Small writes are fast, but large writes=20
require quite a bit of head movement to get everything written twice to=
=20
different parts of the disks.

The "best" option always depends on your needs - how you want to access=
=20
your files.  A layout geared to fast striped reads of large files will=20
be poorer for parallel small writes, and vice versa.  raid10,f2 is ofte=
n=20
the best choice for a desktop or small system - but it is not very=20
flexible if you later want to add new disks or replace the disks with=20
bigger ones.

md raid is flexible enough that it will even let you make a 3 disk raid=
6=20
array if you want - but a 3-way raid1 mirror will give you the same dis=
k=20
space and much better performance.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
