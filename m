From: hansbkk@gmail.com
Subject: Re: [linux-lvm] General Q on adding new PVs to existing striped RAID set
Date: Wed, 8 Dec 2010 10:01:14 +0700
Message-ID: <AANLkTikO7rSS8wg7ob8Bc2Zi+FORuNUnWs82P-tCDwkS@mail.gmail.com>
References: <AANLkTiktmuWTBC-s1Qi4KBjQOyhYh+TtLxiu0hPhNh+K@mail.gmail.com>
	<4CFE679D.2090702@bmsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CFE679D.2090702@bmsi.com>
Sender: linux-raid-owner@vger.kernel.org
To: LVM general discussion and development <linux-lvm@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 7, 2010 at 11:58 PM, Stuart D Gathman <stuart@bmsi.com> wro=
te:
> On 12/07/2010 04:15 AM, hansbkk@gmail.com wrote:
>> Example - if I have say 6TB of RAID10 managed by LVM, and then find =
I
>> need to add another 2TB, I might add a RAID1 mirror of 2x 2TB drives
>> and extend my VG to get more space. However it seems for optimum
>> performance and fault tolerance I should =A0consider this a somewhat
>> temporary workaround. Ultimately I would want to get back to a
>> coherent single 8TB RAID set, and take the RAID1 mirror out.
>>
>> This seems to be better from multiple POVs - more space efficient,
>> more consistently predictable performance (if not actually faster),
>> and most importantly more fault tolerant.
>
> Raid1 is just as fault tolerant as raid10. =A0Raid10 just adds stripi=
ng
> for performance. =A0You are probably thinking that with more devices,=
 the
> probability of 2 devices failing close together is larger. =A0However=
,
> going from 4 to 6 (or 8) devices does not significantly decrease
> reliability compared to the increase provided by raid1 (with or witho=
ut
> striping).

You're right of course. I wrote my first draft of the scenario with
RAID6, then realized the answer would be to grow the underlying RAID6
rather than linearly adding a disk set via LVM, so changed to RAID10
specifically because it doesn't allow for online growing, and wanted
to address the issue of linearly adding a mix of RAID sets.

<snip>

> You can grow raid1/raid10 also.

My understanding is only by replacing smaller disks with bigger ones,
but not by adding new disks.

> Consider making all your PVs raid1, and doing your striping in LVM. =A0=
That is the
> equivalent of raid10 and gives you much more flexibility in growing y=
our
> VG than raid10 underneath.

<snip>

> Look into this possibility.  I've not tried it myself, so hopefully
> others can verify if it works or not, and if there are any performanc=
e
> issues.
>
> Create multiple mdadm 2 disk mirror sets (RAID 1) with all your drive=
s
> (assuming they're the same size/rpm).  Create an LVM stripe across th=
e
> resulting md devices.  Tune/tweak/test for performance and
> functionality, specifically expanding the LVM volume while maintainin=
g
> the stripe correctly.  If everything looks good, format with your
> favorite FS, do more performance tests, then go.
>
> Poor man's RAID 10, basically.  More accurately, it's a multi-layer
> RAID, with, I think, the ability to expand via LVM without any gotcha=
s.
>  Performance probably won't be quite as good as native mdadm RAID 10,
> but if you get expansion capability like you would with RAID5/6, it m=
ay
> be worth the performance hit.

Thanks Stan, great ideas. However in the meantime I found a statement
that perfectly addresses my feelings:

>In LVM 2, striped LVs can be extended by concatenating another set of =
devices onto the end of the first set. So you can get into a situation =
where your LV is a 2 stripe set concatenated with a linear set concaten=
ated with a 4 stripe set. Are you confused yet?

Given my state of noob'ness, and the fact that I'm currently setting
up a single filer that will service dozens of hosts, virtual and
phsyical, clients and servers, without much ability to predict future
usage patterns. I'm not confident of my ability to keep the LVM
striping optimized over time, and will most likely elect to keep the
striping-for-performance at the underlying RAID level.

I also will be running some backup services whose disk space need to
be kept on a completely different set of spindles from the hosts' data
they are backing up. On the latter set, where I want maximum fault
tolerance, performance isn't such an issue but I need lots of space on
my limited budget. Therefore I believe RAID6 is the way to go. As
mentioned above, it seems this will also allow me to expand the disk
set as needed "under" the LVM level, maintaining consistent
performance and optimizing space usage and fault tolerance.

On the other, "working data" VG, I'll probably also start off using
plain RAID1, and therefore may well not run into the issue I've
raised, as adding additional disk pairs will be at least consistent.
If I keep a chunk of space empty on each set as I grow, I will then be
able to experiment with using LVM for the striping for a particular
host that needs the performance boost - or at least be able to do some
benchmarking.

If I find I generally need the extra performance of RAID10 (f2) down
the road, I do feel confirmed in the main thrust of my original
question, which is that I should treat inconsistent linear additions
of RAID1 pairs to existing RAID-striped sets as temporary, and plan to
migrate the VG back to a single coherent set when the chance comes.

Thanks very much for helping me to clarify my thinking - additional
feedback of course would be welcome (from anyone).
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
