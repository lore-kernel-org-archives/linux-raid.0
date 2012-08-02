From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: OT: silent data corruption reading from hard drives
Date: Thu, 02 Aug 2012 04:29:13 -0500
Message-ID: <501A4869.1000501@hardwarefreak.com>
References: <50191ADE.10809@fastmail.fm> <5019D052.4000409@hardwarefreak.com> <20120802091917.32fb0ca5@natsu> <501A316C.3020305@hardwarefreak.com> <20120802140634.6f729d07@natsu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120802140634.6f729d07@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: matt <listy@fastmail.fm>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/2/2012 3:06 AM, Roman Mamedov wrote:
> On Thu, 02 Aug 2012 02:51:08 -0500
> Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> I didn't say, nor imply such a thing.  You missed my point entirely
>> about dollar amount.  It had two aspects:
>>
>> 1.  Some people are willing to spend hundreds or thousands on drives,
>> then hook them to $15 controllers without giving that ratio a thought,
>> no reflection upon the sanity of it.
> 
> Why should there be any reflection? There is no no automatic "Hmm, this thing
> costs $XXX, so the other thing should also cost $XXX" rule.

You're Russian.  In the U.S. there has been an axiom for generations
that says "You get what you pay for".  This isn't always true, but more
often than not.

> $15 is simply the right price for a perfectly working 2 port SATA controller
> (based on some of those chip models I named) on the market.

If it works out of the box, or after a month, yes.  But many of these
$15 cards are DOA or fail shortly after entering service, due to poor
QC.  This is one of the many problems one avoids with higher quality
boards, which are usually more expensive.  A twist on the above axiom,
"pay more, get more".

> The rule is not "buy expensive", 

Of course not.

> it's "avoid buying (known-)broken". Maybe

This is not knowable but for compatibility.  All the $15 cards have a
higher DOA/failure rate than the high quality cards.  By that logic one
should always avoid the cheap cards.  Coincidentally, this is one of the
reasons I recommend against them.  One is gambling whether his new Syba
is going to be DOA.  You can be pretty damn sure your new LSI won't be
DOA or fail after one week.

> it's more difficult to come across a broken card in the expensive segment.
> Maybe it's not. In any case my suggestion is to just do some research before
> you buy, identify broken chips and cards, avoid those, and save yourself those
> $185 or whatever.

With hundreds of SAS/SATA HBAs on the market, as with just about any
product, most people do not have the time to research every small
purchase.  Again, the axiom comes into play: "You get what you pay for".

>> First, there are not "enterprise" controllers that use the Marvell SAS
>> chip, period.  It's a low/mid cost, entry level 8 port SAS ASIC.  The
>> cards based on it a not crappy, but actually pretty decent.  They run
>> very well with Windows, *BSD, SCO, NetWare, and other OSes.  It just
>> happens that the Linux driver, yes mv_sas, totally sucks
> 
> The end result for the user is the same, they accidentally buy that card, they
> use GNU/Linux, they have to use that sucky driver. The best choice is to avoid
> buying the card in the first place, but how do you know you should, if you
> didn't do the research (see above) and just looked at the price tag.

You ask around, which smart people do, on various lists.  Or they suffer.

You stated the ASIC itself was junk.  I was simply correcting that
point.  Note what I recently stated on the linux-ide list:

On 7/29/2012 4:24 AM, Stan Hoeppner wrote:
> Speaking of which, don't even look at the $110 8 port Supermicro
> SAS/SATA controller.  It uses the Marvell SAS chip.  Although the chip
> itself is fine and works with Windows, the Linux driver *will* eat
> your data

I've made the same statement dozens of times on the various LKML sub lists.

>>> Also, if you only use the mdadm software RAID, getting an enterprise hardware
>>> RAID controller is truly a waste of money, unless you really need the extra
>>> port density.
>>
>> That logic is flawed.  If you have an enterprise hardware RAID
>> controller you're not going to use md/RAID, unless you're stitching LUNs
>> together with linear or RAID0, as I often do.  In fact that's my most
>> frequent use of md/RAID--concatenation of hardware RAID or SAN LUNs.
> 
> I do not recommend using hardware RAID. It locks you into one card/vendor,
> usually is much less flexible than mdadm, and often even provides lower
> performance. See http://linux.yyz.us/why-software-raid.html

Of course not.  You don't work in or support an environment that
benefits from it.  Tell me how well md/RAID works for you the next time
you need to setup 4 IBM Bladecenters each w/14 dual socket blades
booting ESX from FC SAN, and hosting hundreds of Linux guests.

I can have a Nexsan E60+E60x w/120 SAS drives configured into 6x 20
drive RAID10 volumes, carve up all my LUNs and export them, booting the
nodes within a few hours, including racking the two chassis and
inserting all the drives.

How many days (or weeks) would it take you part spec and order, build,
test, verify, and put into production a roughly equivalent 120 SAS drive
self built FC LUN serving SAN array, using md/RAID with DAS
controllers/drives on the back end?  A long damn time, if you could even
do it.  There are no guides out there for this scenario, though there
are a few for iSCSI.

This is precisely why proprietary hardware RAID sells, and precisely why
md/RAID isn't the solution for everything, but quite the opposite.  In
fact, md/RAID sees almost zero use in the business/corporate world in
the U.S., probably the same in other countries.  md/RAID is great for
what it does, but there is so much it simply cannot do, from the storage
network standpoint, or simply can't do without a boat load of custom
development.

-- 
Stan

