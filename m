From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: raid over ethernet
Date: Sat, 29 Jan 2011 21:54:55 +0000
Message-ID: <4D448CAF.6020409@anonymous.org.uk>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com> <alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se> <AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com> <20110129133457.GB15784@mordor.angband.thangorodrim.de> <AANLkTi=6ridRPnHpfdOC=f2_ESndSARmQRkvT_shYO3s@mail.gmail.com> <20110129210815.GC15784@mordor.angband.thangorodrim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110129210815.GC15784@mordor.angband.thangorodrim.de>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Schreiber <als@thangorodrim.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29/01/2011 21:08, Alexander Schreiber wrote:
> On Sat, Jan 29, 2011 at 12:23:14PM -0200, Denis wrote:
>> 2011/1/29 Alexander Schreiber<als@thangorodrim.de>
>>
>>>
>>> plain disk performance for writes, while reads should be reasonably
>>> close to the plain disk performance - drbd optimizes reads by just reading
>>> from the local disk if it can.
>>>
>>>
>>   However, I have not used it with active-active fashion. Have you? if yes,
>> what is your overall experience?
>
> We are using drbd to provide mirrored disks for virtual machines running
> under Xen. 99% of the time, the drbd devices run in primary/secondary
> mode (aka active/passive), but they are switched to primary/primary
> (aka active/active) for live migrations of domains, as that needs the
> disks to be available on both nodes. From our experience, if the drbd
> device is healthy, this is very reliable. No experience with running
> drbd in primary/primary config for any extended period of time, though
> (the live migrations are usually over after a few seconds to a minute at
> most, then the drbd devices go back to primary/secondary).

Now that is interesting, to me at least. More as a thought experiment 
for now, I was wondering how one would go about setting up a small 
cluster of commodity servers (maybe 8 machines) running Xen (or perhaps 
now KVM) VMs, such that if one (or potentially two) of the machines 
died, the VMs could be picked up by the other machines in the cluster, 
and only using locally-attached SATA/SAS discs in each machine.

I guess I'm talking about RAIN or RAIS rather than RAID so maybe I'd 
better start reading the Wikipedia pages on those and not talk about it 
on this list...

Cheers,

John.

