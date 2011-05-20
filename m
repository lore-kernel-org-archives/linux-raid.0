From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 15:58:04 -0500
Message-ID: <4DD6D5DC.4010209@hardwarefreak.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD65C18.5090804@gmail.com> <20110520200100.GF4759@bitfolk.com> <BANLkTimP_5HHAq3Fq2sAkasZKH85gJFtYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimP_5HHAq3Fq2sAkasZKH85gJFtYw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/20/2011 3:24 PM, Drew wrote:
>> It's a shame; maybe there will be disks with battery-backed cache
>> one day.
> 
> There's already hybrid drives which pack a small SSD onboard to act as
> a large cache.

These hybrid drives still have a small 32-64MB cache DRAM, in front of
the SSD.  The DRAM loses its contents when the power goes out.  The on
board SSD doesn't prevent this cache data loss.

It may be worth noting that most, if not all, pure SSDs also have cache
DRAM in front of the flash array, and thus will lose data in the cache
when the power fails.  Some models have what has been termed "super
capacitors" on board to power the device long enough to flush pending
writes in cache to the flash cells, but few, if any, of the
manufacturers advertise that their drives have this feature, or even
bother to put it on the spec sheet.  So there's no easy/consistent way,
at present, to really know if your SSD has this feature or not.

As always, a good data persistence strategy starts with a good UPS.
Laptop users have an advantage as they get a free built in UPS, and
typically, good software integration to automatically and safely
shutdown when the battery is about out of juice.

-- 
Stan
