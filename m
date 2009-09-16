From: Tom Carlson <twigathy@gmail.com>
Subject: Re: Port Multipliers
Date: Wed, 16 Sep 2009 12:11:10 +0100
Message-ID: <1f0f1a960909160411r3489fddcrfe1e52350245fe60@mail.gmail.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
	 <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com>
	 <87f94c370909151328j1f88ab4fi452fcbeb5f1e9172@mail.gmail.com>
	 <FE87C12A-00E6-4DF6-80CF-56850AFFE656@redhat.com>
	 <4AAFFDC4.5090806@sauce.co.nz>
	 <72dbd3150909151452r38087573od156a1965dc0eba1@mail.gmail.com>
	 <D88C9CE6-0F7D-4E8D-B972-75A5012B921C@redhat.com>
	 <70ed7c3e0909151801y7fe7bbcap872af6c4f9f76590@mail.gmail.com>
	 <4D899658-EEA4-4511-87FF-9338E681D956@redhat.com>
	 <70ed7c3e0909151845r5903f0e4w4750b406c4f5d216@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909151845r5903f0e4w4750b406c4f5d216@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, David Rees <drees76@gmail.com>, Richard Scobie <richard@sauce.co.nz>, Greg Freemyer <greg.freemyer@gmail.com>, Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I've had a slightly bad experience with port multipliers. I have a
PCI-e x1 JMB362 on the host end and a SiI 3726 connected to it. (I
think. It's a 1-5 PM). I have 5 disks connected in raid5 and get some
fairly appalling write speeds, well below what I'd expect even for
raid5 writes. Reads too are fairly slow...

$ dd if=3D/dev/zero of=3D./blah bs=3D1M count=3D512
512+0 records in
512+0 records out
536870912 bytes (537 MB) copied, 47.4814 s, 11.3 MB/s

$ dd if=3D./bigfile.iso of=3D/dev/null
8474857+0 records in
8474857+0 records out
4339126272 bytes (4.3 GB) copied, 144.667 s, 30.0 MB/s

Obviously this isn't the most scientific of tests... :-) but it does
show slowness with this particular combination.

I'm tempted to go buy a SiI 3132 based controller and compare the resul=
ts.

T


2009/9/16 Majed B. <majedb@gmail.com>:
> Regarding payloads, I've recently bought an EVGA motherboard off
> newegg for $120 and it supports upping the payload to 4096 bytes.
>
> Newegg link: http://www.newegg.com/Product/Product.aspx?Item=3DN82E16=
813188035
> Manual guide: http://www.evga.com/support/manuals/files/113-YW-E115.p=
df
>
> The motherboard above has 8 SATA ports, built-in VGA (256MB, if you
> care), 1x Gbit LAN, 4x RAM DIMMs and a few more options. I use it for
> my primary array: 8x1TB disks.
>
> ASUS gaming motherboards allow changing the payload as well.
>
> On Wed, Sep 16, 2009 at 4:28 AM, Doug Ledford <dledford@redhat.com> w=
rote:
>> On Sep 15, 2009, at 9:01 PM, Majed B. wrote:
>>>
>>> I think someone mentioned in the mailing list that the Linux kernel
>>> does sort commands before sending them to the disks, so if the disk
>>> tries to sort, and its algorithm isn't that good, the performance
>>> drops and hence disabling them is a good idea. I believe it's also
>>> mentioned in here: http://linux-raid.osdl.org/index.php/Performance
>>
>>
>> It depends on the elevator in use. =C2=A0And regardless, I have yet =
to see a
>> raid5 array ever perform better with queueing turned off instead of =
on.
>> =C2=A0Although, in many cases, very large queue depths don't help mu=
ch. =C2=A0Testing
>> I've done showed that only a 4 to 8 queue depth is sufficient to get=
 95% or
>> better of the performance benefit of queueing.
>>
>> --
>>
>> Doug Ledford <dledford@redhat.com>
>>
>> GPG KeyID: CFBFF194
>> http://people.redhat.com/dledford
>>
>> InfiniBand Specific RPMS
>> http://people.redhat.com/dledford/Infiniband
>>
>>
>>
>>
>>
>
>
>
> --
> =C2=A0 =C2=A0 =C2=A0 Majed B.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
