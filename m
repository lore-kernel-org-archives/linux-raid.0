From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: [RFC] Process requests instead of bios to use a scheduler
Date: Mon, 02 Jun 2014 13:12:18 +0200
Message-ID: <538C5C12.8060407@profitbricks.com>
References: <5385DECE.5060507@profitbricks.com>	<20140602093258.22aa2c05@notabene.brown>	<538C4938.6010704@profitbricks.com> <20140602202050.14903534@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140602202050.14903534@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>, =?ISO-8859-1?Q?Florian-Ewald?= =?ISO-8859-1?Q?_M=FCller?= <florian-ewald.mueller@profitbricks.com>
List-Id: linux-raid.ids

On 02.06.2014 12:20, NeilBrown wrote:
> On Mon, 02 Jun 2014 11:51:52 +0200 Sebastian Parschauer 
> <sebastian.riemer@profitbricks.com> wrote:
>> 
>> Nope, we have our RAID-1+0. So it is more or less a RAID-10 and
>> putting the scheduler to this RAID-0 layer makes sense for us.
> 
> I still cannot imagine how this would work.  RAID-0 has no
> decisions to make, so no where for a scheduler to fit.
> 
> Just to clarify: is this md/raid0 over md/raid1 or md/raid0 over 
> hardware/raid1?

We have both variants but tested the scheduler with servers without HW
RAID and only 4 HDDs. On the production servers there are 24 HDDs,
every 2 HDDs are in md/raid1 or HW RAID-1 and these 12 RAID-1 devices
form an md/raid0 device.

This is the only PV for LVM and LVs are the customer volumes exported
via SCST/SRP. These are used by virtual machines on other servers. So
the scheduler has to bring some fairness to the customer volumes so
that a streaming customer can't block a database customer completely
with his big sequential IOs as these would have priority. But our goal
with a scheduler is to reduce latency for everyone.

I hope this is clear, now. Just tell me if not. ;-)
