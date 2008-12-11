From: Michael Brancato <mike@mikebrancato.com>
Subject: Re: status of raid 4/5 disk reduce
Date: Thu, 11 Dec 2008 11:13:08 -0500
Message-ID: <10B57D9F-CC19-41E6-8941-0153CA6CC42D@mikebrancato.com>
References: <493D8A95.2020700@mikebrancato.com> <493EDF02.5090500@redwax.co.uk>  <A20315AE59B5C34585629E258D76A97C02F476F7@34093-C3-EVS3.exchange.rackspace.com>  <20081209215149.GA21523@cthulhu.home.robinhill.me.uk> <7d86ddb90812091515m1e0ee2f9w95a86ca2b56a98fe@mail.gmail.com> <493FB2AC.7000902@redwax.co.uk> <494059A4.8050702@mikebrancato.com> <A20315AE59B5C34585629E258D76A97C02FA1D78@34093-C3-EVS3.exchange.rackspace.com> <4940FCCA.1060703@anonymous.org.uk> <alpine.DEB.1.10.0812111544480.7856@uplift.swm.pp.se> <A20315AE59B5C34585629E258D76A97C02FA211E@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0 (iPhone Mail 5G77)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C02FA211E@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Dec 11, 2008, at 10:24 AM, "David Lethe" <david@santools.com> wrote:

>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Mikael Abrahamsson
>> Sent: Thursday, December 11, 2008 8:47 AM
>> To: John Robinson
>> Cc: Linux RAID
>> Subject: Re: status of raid 4/5 disk reduce
>>
>> On Thu, 11 Dec 2008, John Robinson wrote:
>>
>>> But my 1U server only physically has room for 4 drives. It doesn't
>>> matter how many extra controllers I buy, I can't attach more drives.
>>
>> You can use a temporary external eSATA enclosure, pvmove the data if
>> you're using LVM, then take downtime when you exchange your new  
>> drives
>> into the internal drive bays (or you could even move them one by one
> by
>> hotremoving one drive from the eSATA enclosure into the internal  
>> drive
>> bays.
>>
>> --
>> Mikael Abrahamsson    email: swmike@swm.pp.se
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Or you can crack open another PC and get power from that via long  
> power
> cables. Since you have a rack-mounted system, chances are good you  
> have
> more rack-mounted systems.   Of course this is still all moot, because
> John insists that the RAID reduce function doesn't need to address
> reducing mounted file systems  ... and your 1U system is booted to the
> very file system that needs to be reduced.
>
> So we have come full circle.  A md reduce isn't practical unless it
> includes on-line file system support, which is a deal-killer as it not
> only requires massive development efforts outside of the LINUX RAID
> group, but has to be done in conjunction with the developers in this
> group.
>
> Just suck it up and mount all the disks somehow (or use backup).   
> Either
> give up on resizing, or install Solaris with ZFS boot, then you can
> resize all  you want.
>
>
> David

David,
I must correct your statements. You are the only person here who  
insists on online FS shrinking.  You are the only person with the  
misconception that the ability for a FS to shrink and the ability to  
reshape an array are interdependent. You also cannot shrink ZFS via  
vdev removal / replacement.  I think you meant VxFS, which can  
evacuate data from disks to shrink.

What about a 2U, 8 drive server with a RAID1 boot array and a 6 drive  
RAID5?  I'm sure no matter the situation, there is a labor-intensive,  
risky, power-cord-snaking alternative that involves additional  
hardware. But providing a way to reshape via unmount, resize, remount,  
reshape is a practical alternative no matter whether or not it is the  
only possible way to acheieve the same results.  In-place expansion  
and shrinks offer numerous benefits in administration.

You can continue your Rube Goldberg array shrinks to your heart's  
content. But it comes off as rude to think you have the only solution  
to array shrinking by excluding an in-place reshape reduce. 
