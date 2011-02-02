From: hansbkk@gmail.com
Subject: Re: RAID 5 - One drive dropped while replacing another
Date: Wed, 2 Feb 2011 22:28:56 +0700
Message-ID: <AANLkTi=XzwtUGYH_wz44LHTYpyQRqnSCk4MxWZiQqZ8Z@mail.gmail.com>
References: <AANLkTinXTYds442gPrs9a9vKtWTo4OcDHDEzvO0njvyv@mail.gmail.com>
	<AANLkTikSjLhoUM5f2ibqCUmo8XF-tsrhxZ7oieg08dtD@mail.gmail.com>
	<20110202043605.593f0c5c@natsu>
	<AANLkTimJC_e8=BmGj7Th_LLc=wnoNj8tRovAgTR=mmQ7@mail.gmail.com>
	<20110202192835.5d35f2d1@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110202192835.5d35f2d1@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>, Robin Hill <robin@robinhill.me.uk>
Cc: Bryan Wintermute <bryanwintermute@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 2, 2011 at 9:28 PM, Roman Mamedov <rm@romanrm.ru> wrote:

> Exactly, RAID6 would make an order of magnitude more sense.
> A 15-drive RAID5 array is just one step (one drive failure) from beco=
ming a
> 14-drive RAID0 array (reliability-wise).

> Would you also ask "what's wrong with having a 14-drive RAID0"?

Thanks Roman, I just wanted to check that's what you meant.


On Wed, Feb 2, 2011 at 9:47 PM, Robin Hill <robin@robinhill.me.uk> wrot=
e:

>> Or is there an upper limit as to the number of drives that's advisab=
le
>> for any array?
>>
> I'm sure there's advice out there on this one - probably a recommende=
d
> minimum percentage of capacity used for redundancy.  I've not looked
> though - I tend to go with gut feeling & err on the side of caution.
>
>> If so, then what do people reckon a reasonable limit should be for a
>> RAID6 made up of 2TB drives?
>>
> As the drive capacities go up, you need to be thinking more carefully
> about redundancy - with a 2TB drive, your rebuild time is probably ov=
er
> a day.  Rebuild also tends to put more load on drives than normal, so=
 is
> more likely to cause a secondary (or even tertiary) failure.  I'd be
> looking at RAID6 regardless, and throwing in a hot spare if there's m=
ore
> than 5 data drives.  If there's more than 10 then I'd be going with
> multiple arrays.

Thanks for the detailed reply Robin. I'm also sure there's advice "out
there", but I figure there's no more authoritative place to explore
this topic than here; I hope people don't mind the tangent.

So keeping the drive size fixed at 2TB for the sake of argument, do
people agree with the following as a conservative rule of thumb?
Obviously adjustable depending on financial resources available and
the importance of keeping the data online, given the fact that
restoring this much data from backups would take a loooong time. This
example is for a money-poor environment that could live with a day or
two of downtime if necessary.

less than 6 drives =3D> RAID5
6-8 drives =3D=3D> RAID6
9-12 drives =3D=3D> RAID6+spare
over 12 drives, start spanning multiple arrays (I use LVM in any case)

On Wed, Feb 2, 2011 at 9:29 PM, Mathias Bur=E9n <mathias.buren@gmail.co=
m> wrote:
> With 15 drives, where only 1 can fail (RAID5) without data loss.. it'=
s
> a quite high risk that 2 (or more) drives will fail within a short
> period of time. If you have less drives, this chance decreases. For
> large amount of drives I recommend RAID10 personally (or RAID1+0,
> whichever you prefer).
>
> RAID6 + 1 hot spare is also nice, and cheaper. (for ~10 drives)

Mathias, RAID1+0 (not talking about "mdm RAID10" here) would only
protect my data if the "right pair" of drives failed at the same time,
depending on luck, whereas RAID6 would allow **any** two (and
RAID6+spare any *three*) drives to fail without my losing data. So I
thought I'd always prefer RAID6. Or were you perhaps thinking of
something fancy using "spare pools" or whatever they're called to
allow for multiple spares to fill in for any failures at the
underlying RAID1 layer? Now that I think about it, that seems like a
good idea if it could be made to work, as the simple mirrors do repair
much faster. But of course the greatly reduced usable disk space ratio
make this pretty expensive. . .

> with a 2TB drive, your rebuild time is probably over a day.

On my lower-end systems, a RAID6 over 2TB drives takes about 10-11
hours per failed disk to rebuild, and that's using embedded bitmaps
and with nothing else going on.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
