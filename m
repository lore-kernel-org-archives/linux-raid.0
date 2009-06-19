From: Fredrik Pettersson <freppe@deimos.nu>
Subject: Re: Why is my raid 1 boot/root not working with autodetect?
Date: Fri, 19 Jun 2009 11:34:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0906191132270.10362@deimos.nu>
References: <Pine.LNX.4.64.0906101828150.10333@deimos.nu>
 <Pine.LNX.4.64.0906111019350.9820@deimos.nu> <19002.62328.200010.484984@notabene.brown>
 <Pine.LNX.4.64.0906191110330.9419@deimos.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0906191110330.9419@deimos.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 19 Jun 2009, Fredrik Pettersson wrote:
> On Fri, 19 Jun 2009, Neil Brown wrote:
>>  However I recommend and you only use autodetect for the boot device,
>>  and allow mdadm to assemble all the rest.
>>  So change the partition type of sdc2 and sdb2 to something else
>>  e.g. 0xDA.
>>  Then auto-detect will ignore them, mdadm will find and assemble them,
>>  and all with be happy.
>>
>>  NeilBrown
>> 
>
> Now this sounds promising. So what you say is that if I just go with 
> autodetect for the boot device (in my case md0, sdb1 + sdc1), then later in 
> the boot process when mdadm is started it will create the other raid devices 
> even though they are not set as 0xFD? I will test that, thanks for the 
> advice.

That worked great, and achieved what I was looking for which was to reduce 
the kernel boot parameters (one less place to remember to keep up to date 
when adding new partitions and raid devices).

Thanks again,

/Fredrik Pettersson
