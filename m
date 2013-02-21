From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Thu, 21 Feb 2013 14:10:09 +1100
Message-ID: <51259011.1060600@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au> <511B4719.6060607@hardwarefreak.com> <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com> <555253fb-86d2-448b-a85b-43dae1a2a33d@email.android.com> <511CD709.6070506@hardwarefreak.com> <511E38C7.6000203@hardwarefreak.com> <c0057008-8681-4275-a6e2-e747c9711158@email.android.com> <511EDBCB.2000906@hardwarefreak.com> <bdc9707d-f948-430e-b1e6-28ad06bbe60a@email.android.com> <5120356E.8000702@hardwarefreak.com> <91cffde0-b154-477d-90d2-68b15e91518c@email.android.com> <5120789B.1080804@hardwarefreak.com> <5120979C.9030703@websitemanagers.com.au> <5120E1F6.2050906@hardwa
 refreak.com> <5120ED3F.7080904@websitemanagers.com.au> <5123351F.5030903@hardwarefreak.com> <5124FDB2.10007@websitemanagers.com.au> <51256E45.5080707@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51256E45.5080707@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/02/13 11:45, Stan Hoeppner wrote:
> On 2/20/2013 10:45 AM, Adam Goryachev wrote:
>> Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> Same ssd in both tests. fio command line was just fio test.fio
>> The fio file was the one posted in this thread by another user as follows:
>> [global]
>> bs=64k
>> ioengine=libaio
>> iodepth=32
> Try dropping the iodepth to 4 and see what that does.
>
>> size=4g
>> direct=1
>> runtime=60
>> #directory=/dev/vg0/testlv
>> filename=/tmp/testing/test
>>
>> [seq-read]
>> rw=read
>> stonewall
>>
>> [seq-write]
>> rw=write
>> stonewall
>>
>> Note, the "root ssd" is the /tmp/testing/test file, when testing MD
>> performance on the RAID5 I'm using the /dev/vg0/testlv which is an LV on
>> the DRBD on the RAID5 (md2), and I do the test with the DRBD disconnected.
> Yes, and FIO performance to a file is going to be limited by the
> filesystem, and specifically the O_DIRECT implementation in that FS.
> You may see significantly different results from EXT2/3/4, Reiser, than
> from XFS or JFS, and from different kernel and libaio versions as well.
>  There are too many layers between FIO and the block device, so it's
> difficult to get truly accurate performance data for the underlying device.
Not a problem, the root SSD is not really in question here, it is not
relevant to the system performance overall, it was just as a comparative
value...
> And in reality, all of your FIO testing should be random, not
> sequential, as your workload is completely random--this is a block IO
> server after all with 8 client hosts and I assume hundreds of users.
Is there a way to tell FIO to do random read/write tests?
> The proper way to test the capability of your iSCSI target server is to
> fire up 8 concurrent FIO tests, one on each Xen box (or VM), each
> running 8 threads and using random read/write IO, with each hitting a
> different test file residing on a different LUN, while using standard OS
> buffered IO.  Run a timed duration test of say 15 seconds.
At this point, we were trying to test the performance of the RAID5. If
the RAID5 is not performing at expected levels, then testing at a higher
level is not going to improve things. Unfortunately, testing at the LV
level is as "low" in the stack I can get without wiping the contents...
> Testing raw sequential throughput of a device (single SSD or single LUN
> atop a single LV on a big mdRAID device) is not informative at all.
Except to say that this is the maximum achievable performance we should
expect in ideal conditions. The fact is that one of the actual use cases
is a large streaming read concurrent to a large streaming write. I'd say
a single large streaming write or read (one at a time) are both relevant
tests towards that goal, given we have underlying SSD, and therefore
there are no intervening seeks between each read/write...

You can stop reading here if you are only interested in the question of
performance...

>>> Definitely cheaper, and more flexible should you need to run a filer
>>> (Samba) directly on the box.  Not NEARLY as easy to setup.  Nexsan has
>>> some nice gear that's a breeze to configure, nice intuitive web GUI.
>> The breeze to configure part would be nice :)
> When you're paying that much premium it better come with some good value
> added features.
That is what I had expected from the overland device, and initially it
was easy to configure/etc... Just obviously a touch buggy, probably in
the newer versions they have fixed those bugs, but I don't think I'll be
going back there again for a while...
>> We have 10Mbps private connection. I think we can license the DRBD proxy
>> which should handle the sync over a slower network. The main issue with
>> DRBD is when you are not using the DRBD proxy.... The connection itself
>> is very reliable though, 
> 10Mbps isn't feasible for 2nd site block level replication, with DRBD
> proxy or otherwise.  It's probably not even feasible for remote file
> based backup.
>
> BTW, what is the business case driver here for off site replication, and
> what is the distance to the replication site?  What is the threat
> profile to the primary infrastructure?  Earthquake?  Tsunami?  Flash
> flooding?  Tornado?  Fire?
It's about 22KM away (13.7 miles)

I suppose it is supposed to protect against the threat of fire or theft
at the primary location, and/or other localised events (such as the
exchange burning down, or extended power outage, etc). It's may or may
not be sufficient to protect against more widespread issues such as
earthquake/etc.

The client has an office in most states in Australia, but the offices in
the remote states don't have sufficient bandwidth at this stage for this
to make sense, and there is no local IT knowledge anyway. Considering
that every remote office is dependant on the main office for all their
IT systems, it makes sense to put some sort of attempt at a disaster
recovery plan, also considering the costs of doing this are minimal
(re-use existing spare equipment). Of course, if it works, and works
well, then other things may be done in the future to move this to a site
further away (another state/etc), but initially it is better to have it
relatively close so that issues can be resolved fairly easily.
> I've worked for and done work for businesses of all sizes, the largest
> being Mastercard.  Not a one had offsite replication, and few did
> network based offsite backup.  Those doing offsite other than network
> based performed tape rotation to vault services.
>
> That said, I'm in the US midwest.  And many companies on the East and
> West coasts do replication to facilities here.  Off site
> replication/backup only makes since when the 2nd facility is immune to
> all natural disasters, and hardened against all types of man made ones.
>  If you replicate to a site in the same city or region with the same
> thread profile, you're pissing in the wind.
You can call it any number of things, including pissing in the wind, but
sometimes it just makes life easier when doing a tender/proposal for a
prospective client to tick the box "do you have a disaster recovery
plan, does it include offsite/remote computer facilities/whatever... A
lot of these are government or corporate tenders where in reality, it
would never make a difference, but they feel like they need to ask, and
saying no gives a competitor some advantage.
> Off site replication/backup exists for a singular purpose:
>
> To protect against catastrophic loss of the primary facility and the
> data contained therein.
>
> Here in the midwest, datacenters are typically built in building
> basements or annexes and are fireproofed, as fire is the only facility
> threat.  Fireproofing is much more cost effective than the myriad things
> required for site replication and rebuilding a primary site after loss
> due to fire.
The main aim would be to allow recovery from a localised disaster for
all the remote offices, while head office might get trashed, at least if
the remote offices can continue with business as usual, then there is
still an income/etc. If there was a real disaster
(earthquake/flooding/etc) then they are not likely to be doing much
business in the short term, but soon after the recovery, they would want
to be ready to provide services, whether that is by one of the remote
offices handling the workload, etc.

As I've discussed with other clients, especially where they only have a
single office, and all staff live locally, having an inter-state
disaster recovery centre is pretty useless, since with that level of
disaster you will all be dead anyway, so who really cares :) ie, if a
nuclear weapon is detonated in my city, my customers won't be alive to
call me, and I won't be alive to deal with it, and their customers won't
be alive/etc (ie, does your local butcher need offsite
backup/replication...)
>> just a matter of the bandwidth and whether it
>> will be sufficient. I'll test beforehand by using either the switch or
>> linux to configure a slower connection (maybe 7M or something), and see
>> if it will work reasonably.
> I highly recommend you work through the business case for off site
> replication/DR before embarking down this path.
As mentioned, the business case is minimal, which is why the budget for
it is minimal. If it can't be achieved with minimal (basically nil)
expenditure, then it will be delayed for another day. However, having it
will mostly benefit by adding something else for the salespeople to talk
about more than the actual functionality/effectiveness.

At worst, having DRBD simply re-sync each night would provide adequate
advantage/protection.

I think a 10M connection should be capable of re-syncing around 40G of
data per night, and in a day the DRBD only needs to write a max of 20G,
so hopefully this will be feasible. I'm hoping that some of those writes
are caused by me doing testing/etc, so real world writes will be even
less. (Note, on the year to date stats, max needed to write is 442G, but
that would include system migrations/etc). At the end of the day, you
may be right and the 10M is insufficient to get this done, in which case
we will need to make the business case to either upgrade the bandwidth
further (possibly all the way to 100M), or else to forget the idea
entirely. (Sure all this could be helped if we get rid of MS Outlook,
and it's 3 to 10 GB pst files, but that is probably just a dream).
>> I've preferred AMD for years, but my supplier always prefers Intel, and
> Of course, they're an IPD - Intel Product Dealer.  They get kickbacks
> and freebies from the IPD program, including free product samples,
> advance prototype products, promotional materials, and, the big one, 50%
> of the cost of print, radio, and television ads that include Intel
> product and the logo/jingle.  You also get tiered pricing depending on
> volume, no matter how small your shop is.  And of course Intel holds IPD
> events in major cities, with free food, drawings, door prizes, etc.  I
> won a free CPU (worth $200 retail at the time) at the first one I
> attended.  I know all of this in detail because I was the technician of
> record when the small company I was working for signed up for the IPD
> program.  Intel sells every part needed to built a server or workstation
> but for the HDD and memory.  If a shop stocks/sells all Intel parts
> program points add up more quickly.  In summary, once you're an IPD,
> there is disincentive to sell anything else, especially if you're a
> small shop.
I didn't know all that, but it was definitely a large part of my
preference. I really dislike corporations that behave badly, and like to
support the better behaved corporations where possible (ie, basic
business sense still plays a part, but I'd rather pay 5% more for AMD
for example).
>> for systems like this they get much better warranty support for Intel
>> compared to almost any other brand, so I generally end up with Intel
>> boards and CPU's for "important" servers... Always heard good things
>> about Intel NIC's ...
> So you're at the mercy of your supplier.
>
> FYI.  Intel has a tighter relationship with SuperMicro than any mobo
> manufacturer.  For well over a decade Intel has tapped SM to build all
> Intel prototype boards as Intel doesn't have a prototyping facility.
> And SM contract manufacturers over 50% of all Intel motherboards.  Mobo
> mf'ing is a low margin business compared to chip fab'ing, which is why
> Intel never built up a large mobo mf'ing capability.  The capital cost
> for the robots used in mobo making is as high as CPU building equipment,
> but the profit per unit is much lower.
>
> This relationship is the reason Intel was so upset when SM started
> offering AMD server boards some years ago, and why at that time one had
> to know the exact web server subdir in which to find the AMD
> products--SM was hiding them for fear of Chipzilla's wrath.  Intel's
> last $1.25B antitrust loss to AMD in '09 emboldened SM to bring their
> AMD gear out of hiding and actually promote it.
>
> In short, when you purchase a SuperMicro AMD based server board the
> quality and compatibility is just as high as when buying a board with
> Intel's sticker on it.  And until Sandy Bridge CPUs hit, you got far
> more performance from the AMD solution as well.
All very interesting information, thanks for sharing, I'll keep it in
mind on my next system spec.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

