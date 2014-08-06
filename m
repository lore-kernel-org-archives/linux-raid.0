From: Chris Murphy <lists@colorremedies.com>
Subject: Re: On URE and RAID rebuild - again!
Date: Wed, 6 Aug 2014 11:05:35 -0600
Message-ID: <4B848DDA-8DC8-4629-BC16-9325E61ADE2F@colorremedies.com>
References: <53D8ACF0.1070202@assyoma.it> <alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se> <53D8ED99.90606@assyoma.it> <20140731073121.38cd1773@notabene.brown> <53D9ED48.9000307@assyoma.it> <1370eb7a35b628323646a86094a26912@assyoma.it> <20140803134834.7773b0ab@notabene.brown> <53DF8A31.8060609@assyoma.it> <alpine.DEB.2.02.1408042037470.7929@uplift.swm.pp.se> <35916d10dab6084e6f28da2e0975fce7@assyoma.it> <20140805190159.GA2897@lazy.lzy> <228fa3bd137e034e9ec974094f37b368@assyoma.it>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <228fa3bd137e034e9ec974094f37b368@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Aug 5, 2014, at 1:42 PM, Gionatan Danti <g.danti@assyoma.it> wrote:
> 
> I am trying to imagine _how_ the various vendors arrive at the claimed number and _how much_ we have confidence in URE rate.

I'd say it's next to useless, and a different question needs to be asked which is how much redundancy is a good value relative to the value of the data; and then coming up with a strategy that meets the uptime and redundancy preference for a given budget.

>> Furthermore, as already again stated, very likely
>> an "average" HDD has much lower URE probability.
> 
> This is reassuring :)

The spec only accounts for the drive itself. Not the cables, the controller, the computer's non-ECC memory, and notably one of the greatest sources of data loss: user error. It also doesn't account for the complete implosion of the drive, for any number of reasons, head impacts the spinning surface and either destroys the data on the surface or the read/write head; actuator death; spindle motor death, logic board death, power supply death, etc.

So to mitigate drive and cable problems we use RAID. For controller, logic board, power supply failure concerns, we use clusters. More than a handful of URE's, even if they were to bust the manufacturer spec, is the loss of a single drive represents hours or days of rebuild because one drive holds so much more data today.

Right now, md RAID 6 + XFS + Gluster clusters is a rather straightforward setup. For volume snapshots to mitigate user induced data loss, LVM2 thinly provisioned LV's can be used. I haven't tested it yet but I think the LVM2 integrated RAID does work with thinp LV's, so it's possible to remove a layer if you're OK with the different LVM raid management tools compared to mdadm.

Chris Murphy

