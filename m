From: "Majed B." <majedb@gmail.com>
Subject: Re: Port Multipliers
Date: Tue, 15 Sep 2009 23:08:30 +0300
Message-ID: <70ed7c3e0909151308u21705523ya65f28b5d737d61c@mail.gmail.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
	<70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>
	<c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>
	<70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com>
	<B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com> <70ed7c3e0909151112m14f5f3a5ge3b3ff20425cc427@mail.gmail.com>
	<57DEE3F6-E4FF-4D96-901E-7DF5BF232700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57DEE3F6-E4FF-4D96-901E-7DF5BF232700@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My bad :)

On Tue, Sep 15, 2009 at 10:55 PM, Doug Ledford <dledford@redhat.com> wr=
ote:
> On Sep 15, 2009, at 2:12 PM, Majed B. wrote:
>>
>> Well, just because the PCI-e 1x bus can do 250 MB/s, it doesn't mean
>> that the Port Multiplier (PM) can reach that speed, hence me telling
>> you to test the card itself with 1 disk to see its max speed, then a=
dd
>> another and so on.
>
> You didn't tell me, you told Drew. =C2=A0And I wasn't reporting test =
results I
> got in response to your instructions, these tests have already been d=
one
> (and well more in fact). =C2=A0I was just relaying what I found on th=
is card and
> this setup for Drew's benefit.
>
>> Some PMs can communicate with each other. Check the specification
>> sheet to see if your PM can do that. If that's the case, keep your
>> disks of one array connected to PMs of the same chip, and use the
>> built-in ports of the motherboard for another array or just normal
>> disks.
>
> This is a test machine I built specifically for testing bare ports ve=
rsus pm
> setups. =C2=A0I destroy and create new raid arrays on it all the time=
, and none
> of them are for real use, just benchmarking.
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
