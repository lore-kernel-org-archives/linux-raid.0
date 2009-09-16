From: "Majed B." <majedb@gmail.com>
Subject: Re: Port Multipliers
Date: Wed, 16 Sep 2009 04:01:03 +0300
Message-ID: <70ed7c3e0909151801y7fe7bbcap872af6c4f9f76590@mail.gmail.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
	<70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>
	<c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>
	<70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com>
	<B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com> <87f94c370909151328j1f88ab4fi452fcbeb5f1e9172@mail.gmail.com>
	<FE87C12A-00E6-4DF6-80CF-56850AFFE656@redhat.com> <4AAFFDC4.5090806@sauce.co.nz>
	<72dbd3150909151452r38087573od156a1965dc0eba1@mail.gmail.com>
	<D88C9CE6-0F7D-4E8D-B972-75A5012B921C@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D88C9CE6-0F7D-4E8D-B972-75A5012B921C@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: David Rees <drees76@gmail.com>, Richard Scobie <richard@sauce.co.nz>, Greg Freemyer <greg.freemyer@gmail.com>, Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I think someone mentioned in the mailing list that the Linux kernel
does sort commands before sending them to the disks, so if the disk
tries to sort, and its algorithm isn't that good, the performance
drops and hence disabling them is a good idea. I believe it's also
mentioned in here: http://linux-raid.osdl.org/index.php/Performance

On Wed, Sep 16, 2009 at 3:31 AM, Doug Ledford <dledford@redhat.com> wro=
te:
> On Sep 15, 2009, at 5:52 PM, David Rees wrote:
>>
>> On Tue, Sep 15, 2009 at 1:49 PM, Richard Scobie <richard@sauce.co.nz=
>
>> wrote:
>>>
>>> Doug Ledford wrote:
>>>>
>>>> I agree with this sentiment 100%. =C2=A0I don't have a good answer=
 for why
>>>> =C2=A0it
>>>> topped out where it did, and that's one of the things I'm still =C2=
=A0trying
>>>> to
>>>> get an answer to.
>>>
>>> I can also confirm this sub par performance on the Sil 3124 - max
>>> throughput
>>> of around 120MB/s.
>>>
>>> If your motherboard is able to set the "PCIe Max Payload Size" you =
may be
>>> able to improve things.
>>>
>>> See Note 3 here:
>>>
>>>
>>> http://ata.wiki.kernel.org/index.php/Hardware,_driver_status#Silico=
n_Image_3124
>>
>> Another one here with a Sil3124 and max 120MB/s.
>>
>> With the port multiplier I've got, I've had to disable NCQ to get
>> things to behave when accessing multiple drives - otherwise access t=
o
>> the enclosure would lock up under moderate/heavy concurrent disk
>> access.
>>
>> The multipler appears to be a Sil4726. =C2=A0The array was built on =
a
>> budget so the drives in the multiplier are a mix of drives - some ar=
e
>> 1.5Mbps, some are 3.0Mbps and not all support NCQ. =C2=A0Not sure ho=
w it
>> behaves with 100% NCQ capable drives.
>
>
> My port multiplier is a Sil3726, so very similar. =C2=A0However, my d=
rives are
> all more or less identical and are all NCQ capable. =C2=A0I've been a=
ble to beat
> on them for days at a time under non-stop load and not had a problem.
>
> --
>
> Doug Ledford <dledford@redhat.com>
>
> GPG KeyID: CFBFF194
> http://people.redhat.com/dledford
>
> InfiniBand Specific RPMS
> http://people.redhat.com/dledford/Infiniband
>
>
>
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
