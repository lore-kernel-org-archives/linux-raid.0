From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Fri, 22 Feb 2013 05:19:56 -0600
Message-ID: <5127545C.9040808@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au> <511B4719.6060607@hardwarefreak.com> <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com> <555253fb-86d2-448b-a85b-43dae1a2a33d@email.android.com> <511CD709.6070506@hardwarefreak.com> <511E38C7.6000203@hardwarefreak.com> <c0057008-8681-4275-a6e2-e747c9711158@email.android.com> <511EDBCB.2000906@hardwarefreak.com> <bdc9707d-f948-430e-b1e6-28ad06bbe60a@email.android.com> <5120356E.8000702@hardwarefreak.com> <91cffde0-b154-477d-90d2-68b15e91518c@email.android.com> <5120789B.1080804@hardwarefreak.com> <5120979C.9030703@websitemanagers.com.au> <5120E1F6.2050906@hardwarefreak.com> <5120ED3F.7080904@websit
 emanagers.com.au> <5123351F.5030903@hardwarefreak.com> <5124FDB2.10007@websitemanagers.com.au> <51256E45.5080707@hardwarefreak.com> <51259011.1060600@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51259011.1060600@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/20/2013 9:10 PM, Adam Goryachev wrote:
> On 21/02/13 11:45, Stan Hoeppner wrote:

> Not a problem, the root SSD is not really in question here, it is not
> relevant to the system performance overall, it was just as a comparative
> value...

Yes, I was simply explaining one reason the results on a per drive basis
would be a little lower for the root drive.

> Is there a way to tell FIO to do random read/write tests?

Yes.  The job file in my previous email is exclusively random tests.  It
also contains things that should give results that reflect more closely
your actual workloads.

...
> You can call it any number of things, including pissing in the wind, but
> sometimes it just makes life easier when doing a tender/proposal for a
> prospective client to tick the box "do you have a disaster recovery
> plan, does it include offsite/remote computer facilities/whatever... A
> lot of these are government or corporate tenders where in reality, it
> would never make a difference, but they feel like they need to ask, and
> saying no gives a competitor some advantage.

...
> The main aim would be to allow recovery from a localised disaster for
> all the remote offices, while head office might get trashed, at least if
> the remote offices can continue with business as usual, then there is
> still an income/etc. If there was a real disaster
> (earthquake/flooding/etc) then they are not likely to be doing much
> business in the short term, but soon after the recovery, they would want
> to be ready to provide services, whether that is by one of the remote
> offices handling the workload, etc.

If you're doing real DAR planning, you're going to need more than just a
block IO mirror at the remote site, obviously.  You also need a plan in
place to get people connected with the data on it, get them working
again, which means workstations and office space, and have it all lined
up and in place before disaster strikes.  It's literally just like
football, tennis, etc.  You have to practice before the big match.

I've developed DAR plans for two former employers, implemented one.  One
decided it was too costly.  The other gave me budget for leasing office
space for a skeleton crew, not just IT but a few people from each dept.
 We had complete duplicate servers and storage, workstations, switches,
router, all pre-configured, phones, etc.  We had a DAR clause added to
our Bell contract and lines in place for phone trunk and a T1 for net.
Upon activation of our DAR plan, Bell would switch our circuits over
with 4 hours of the call, and we could pick up our tapes from the vault
immediately to start our restore from the previous night.  We performed
a test run sans the phone cutover, worked out some kinks, and everything
worked on the second go, up in 24 hours working straight through.

That's how DAR is done properly.  Or at least, one method of many.  This
is called a "warm site".  A cold site would be arranged but unallocated
office space with equipment staged in storage, no circuit arrangement.
Hot site is self evident.

> As I've discussed with other clients, especially where they only have a
> single office, and all staff live locally, having an inter-state
> disaster recovery centre is pretty useless, since with that level of
> disaster you will all be dead anyway, so who really cares :) ie, if a
> nuclear weapon is detonated in my city, my customers won't be alive to
> call me, and I won't be alive to deal with it, and their customers won't
> be alive/etc (ie, does your local butcher need offsite
> backup/replication...)

Nobody doing DAR considers nuclear war.  Earthquake, floods, tsunamis,
tornadoes, terrorism, design flaw structural failure, stuff like that.
Which are survivable, but can leave a facility in shambles, companies in
ruin, and people out of work.

> As mentioned, the business case is minimal, which is why the budget for
> it is minimal. If it can't be achieved with minimal (basically nil)
> expenditure, then it will be delayed for another day. However, having it
> will mostly benefit by adding something else for the salespeople to talk
> about more than the actual functionality/effectiveness.

Hell, if the issue is sales, they're lying if their mouth is open.  Just
tell clients you have it, regardless. ;)

> At worst, having DRBD simply re-sync each night would provide adequate
> advantage/protection.

Of that data.  As I stated above, people need to be able to get to it
and get working afterward.  That's part of the "business case" I was
referring to.

...
> I didn't know all that, but it was definitely a large part of my
> preference. I really dislike corporations that behave badly, and like to
> support the better behaved corporations where possible (ie, basic
> business sense still plays a part, but I'd rather pay 5% more for AMD
> for example).

AMD has already announced their intention to de-emphasize their x86
processor business and focus on the mobile market.  This was a result of
the Bulldozer CPUs performing lower than expected, lower than the
previous generation in many applications, and falling even further
behind Intel in performance.  And a huge loss that quarter.  I hope they
reverse course here...

> All very interesting information, thanks for sharing, I'll keep it in
> mind on my next system spec.

Not only does SuperMicro offer far more Intel server boards than Intel,
they also offer more AMD server boards than anyone.  Here's an
inexpensive server board for Opteron 3000 (AM3+) that has an integrated
8 pot LSI 2308 (9207--same as yours):
http://www.supermicro.com/Aplus/motherboard/Opteron3000/SR56x0/H8SML-7.cfm

-- 
Stan

