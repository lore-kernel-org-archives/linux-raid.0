From: David Rees <drees76@gmail.com>
Subject: Re: Port Multipliers
Date: Tue, 15 Sep 2009 14:52:52 -0700
Message-ID: <72dbd3150909151452r38087573od156a1965dc0eba1@mail.gmail.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
	<70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>
	<c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>
	<70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com>
	<B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com> <87f94c370909151328j1f88ab4fi452fcbeb5f1e9172@mail.gmail.com>
	<FE87C12A-00E6-4DF6-80CF-56850AFFE656@redhat.com> <4AAFFDC4.5090806@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AAFFDC4.5090806@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Doug Ledford <dledford@redhat.com>, Greg Freemyer <greg.freemyer@gmail.com>, "Majed B." <majedb@gmail.com>, Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Sep 15, 2009 at 1:49 PM, Richard Scobie <richard@sauce.co.nz> w=
rote:
> Doug Ledford wrote:
>> I agree with this sentiment 100%. =A0I don't have a good answer for =
why =A0it
>> topped out where it did, and that's one of the things I'm still =A0t=
rying to
>> get an answer to.
>
> I can also confirm this sub par performance on the Sil 3124 - max thr=
oughput
> of around 120MB/s.
>
> If your motherboard is able to set the "PCIe Max Payload Size" you ma=
y be
> able to improve things.
>
> See Note 3 here:
>
> http://ata.wiki.kernel.org/index.php/Hardware,_driver_status#Silicon_=
Image_3124

Another one here with a Sil3124 and max 120MB/s.

With the port multiplier I've got, I've had to disable NCQ to get
things to behave when accessing multiple drives - otherwise access to
the enclosure would lock up under moderate/heavy concurrent disk
access.

The multipler appears to be a Sil4726.  The array was built on a
budget so the drives in the multiplier are a mix of drives - some are
1.5Mbps, some are 3.0Mbps and not all support NCQ.  Not sure how it
behaves with 100% NCQ capable drives.

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
