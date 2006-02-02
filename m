From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: RAID 16?
Date: Thu, 2 Feb 2006 17:28:41 +0100 (MET)
Message-ID: <Pine.GSO.4.62.0602021726010.14030@shaka.acc.umu.se>
References: <43E19FAB.4000603@cogweb.net> <pan.2006.02.02.16.17.03.859560@smurf.noris.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <pan.2006.02.02.16.17.03.859560@smurf.noris.de>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2 Feb 2006, Matthias Urlichs wrote:

> Hi, David Liontooth wrote:
>
>>
>> We're wondering if it's possible to run the following --
>>
>>   * define 4 pairs of RAID 1 with an 8-port 3ware 9500S card * the OS will
>>   see these are four normal drives * use md to configure them into a RAID
>>   6 array
>>
> Hmm. You'd have eight disks, five(!) may fail at any time, giving you
> two disks of capacity.
>
> Ouch. That's not "very high" redundancy, that's "insane". ;-)
>
> In your case, I'd install the eight disks as a straight 6-disk RAID6 with
> two spares. Four disks may fail (just not within the time it takes to
> reconstruct the array...), giving you four disks of capacity.

Yes, but then you (probably) lose hotswap. A feature here was to use the 
3ware hw raid for the raid1 pairs and use the hw-raid hotswap instead of 
having to deal with linux hotswap (unless both drives in a raid1-set 
dies).

> A net win, I'd say, esp. since it's far more likely that your two power
> supplies will both die within the time you'd need to replace one.
>
> But it's your call.

If you only need reliability and can spend a few extra disks, I didn't 
find the setup so bad.

/Mattias Wadenstein
