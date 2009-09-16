From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Port Multipliers
Date: Wed, 16 Sep 2009 10:51:33 -0400
Message-ID: <87f94c370909160751i7319ca29x15198e7a5ae1a648@mail.gmail.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
	 <FE87C12A-00E6-4DF6-80CF-56850AFFE656@redhat.com>
	 <4AAFFDC4.5090806@sauce.co.nz>
	 <72dbd3150909151452r38087573od156a1965dc0eba1@mail.gmail.com>
	 <D88C9CE6-0F7D-4E8D-B972-75A5012B921C@redhat.com>
	 <70ed7c3e0909151801y7fe7bbcap872af6c4f9f76590@mail.gmail.com>
	 <4D899658-EEA4-4511-87FF-9338E681D956@redhat.com>
	 <70ed7c3e0909151845r5903f0e4w4750b406c4f5d216@mail.gmail.com>
	 <1f0f1a960909160411r3489fddcrfe1e52350245fe60@mail.gmail.com>
	 <20C809AA-01E5-4402-928C-84F46F2489B9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20C809AA-01E5-4402-928C-84F46F2489B9@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Tom Carlson <twigathy@gmail.com>, "Majed B." <majedb@gmail.com>, David Rees <drees76@gmail.com>, Richard Scobie <richard@sauce.co.nz>, Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 16, 2009 at 10:28 AM, Doug Ledford <dledford@redhat.com> wrote:
> On Sep 16, 2009, at 7:11 AM, Tom Carlson wrote:
>>
>> Hi,
>>
>> I've had a slightly bad experience with port multipliers. I have a
>> PCI-e x1 JMB362 on the host end and a SiI 3726 connected to it. (I
>> think. It's a 1-5 PM). I have 5 disks connected in raid5 and get some
>> fairly appalling write speeds, well below what I'd expect even for
>> raid5 writes. Reads too are fairly slow...
>>
>> $ dd if=/dev/zero of=./blah bs=1M count=512
>> 512+0 records in
>> 512+0 records out
>> 536870912 bytes (537 MB) copied, 47.4814 s, 11.3 MB/s
>>
>> $ dd if=./bigfile.iso of=/dev/null
>> 8474857+0 records in
>> 8474857+0 records out
>> 4339126272 bytes (4.3 GB) copied, 144.667 s, 30.0 MB/s
>>
>> Obviously this isn't the most scientific of tests... :-) but it does
>> show slowness with this particular combination.
>>
>> I'm tempted to go buy a SiI 3132 based controller and compare the results.
>
>
> I would, those numbers look *really* bad compared to what they could be.
>
> --
>
> Doug Ledford <dledford@redhat.com>
>

The wiki at <http://ata.wiki.kernel.org/index.php/Hardware,_driver_status#Hardware_support>
has at least a couple comments about PMP throughput.

If there is not a better place, maybe that wiki could have a PMP
section added and slowly start to be a good source of info for
building a PMP based solution.

Greg
