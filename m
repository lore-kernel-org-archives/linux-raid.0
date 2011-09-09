From: David Brown <david@westcontrol.com>
Subject: Re: Best strategy to incrementally replace smaller HDDs
Date: Fri, 09 Sep 2011 14:34:46 +0200
Message-ID: <j4d19g$1r4$1@dough.gmane.org>
References: <1315565285.2291.25.camel@michal-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1315565285.2291.25.camel@michal-laptop>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/09/2011 12:48, Micha=C5=82 Sawicz wrote:
> Hi all, given the configuration below:
>        * 8 x 1TB HDDs
>        * 2 x 2TB HDDs
>
> On which I currently have:
>        * (10 x 1TB) RAID6 - persistent storage
>        * (2 x 1TB) system / temporary storage etc.
>

By this do you mean that you have 8 x 1TB drives with a 1 TB partition=20
on each, and 2 x 2T drives with 2 x 1TB partition on each?  So that the=
=20
two big disks are shared with both raids?

> I want to replace the 1TB drives for 2TB ones on an as-needed basis,
> what strategy would you recommend?

This sounds like you are thinking that you can replace a single disk in=
=20
your RAID6 array and get more storage - changing 10 x 1 TB raid6 =3D 8T=
B=20
into 9 x 1TB + 1 x 2TB raid6 =3D 9 TB.  It doesn't work like that.  You=
=20
will have to replace /all/ your 1 TB devices with 2 TB devices (and mov=
e=20
the second raid off the two existing 2TB devices) - all members of the=20
raid6 must be the same size.

To help you plan your upgrades, it is also useful to know your=20
partitioning scheme (for example, do you use LVM?), whether you have th=
e=20
space to put lots more drives in the system or must do it one drive at =
a=20
time, whether you can take the system off-line during the process, and=20
whether you need to do the upgrade quickly or can spend a week or so at=
=20
it (some of these are conflicting requirements).

Before you think about upgrading, however, make sure you have a solid=20
backup.  Then make sure you have a backup of that backup - and a plan=20
for how to restore everything if something goes horribly wrong.


>
>       1. If I moved to 2TB RAID6 members (using RAID0 on the 1TB driv=
es),
>          I would need to replace two of the drives just to match curr=
ent
>          capacity. Each next 2TB drive would get me 1TB additional
>          capacity (but actually I'd need to replace two to gain
>          anything). That sounds to be most future-proof, but most
>          expensive.
>       2. If I moved to 2TB RAID5 members, that would reduce redundanc=
y
>          but replacing just two would gain me 2TB capacity. Most of t=
he
>          above still applies.
>       3. If I kept to 1TB RAID6 (two on the 2TB drives), I would redu=
ce
>          the redundancy to just one drive if it was the 2TB drive tha=
t
>          failed, but each new drive would gain me 1TB capacity and I =
only
>          need to replace one-by-one. This sounds like the cheapest, b=
ut
>          worst possible approach.
>
> So, am I missing something? What do you think?



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
