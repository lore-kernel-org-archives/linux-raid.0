From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: RAID6 issues
Date: Tue, 27 Sep 2011 15:04:02 -0600
Message-ID: <201109271504.02642.thomas@fjellstrom.ca>
References: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com> <201109271246.10137.thomas@fjellstrom.ca> <4E822079.9020901@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E822079.9020901@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Andriano <chief000@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Stan Hoeppner <stan@hardwarefreak.com> wrote:
> >On 9/27/2011 1:46 PM, Thomas Fjellstrom wrote:

>> Stan Hoeppner suggested the LSI SAS1068E card, which looks to be very nice.
>> Only slightly more expensive than the SASLP and well supported under linux.
>>
>> I'll hopefully be getting my hands on a LSI 9210-8i soon. Shortly there-
after
>> I'll be selling my SASLP.
>
> The 9210-8i is a newer generation card using the SAS2008 chip.  IOPS 
> potential is over double that of the 1068E cards, 320M vs 140M, and 
> you'll have support for drives larger than 2TB.  It also supports SATA3 
> link speed whereas the 1068E chips only support SATA2.  It has a PCIe x8 
> 2.0 interface for 8GB/s b/w, whereas the 1068E has a PCIe x8 1.0 
> interface for only 4GB/s.
>
> In short, it's has quite a bit more capability than the 1068E based cards.


Yeah, i was impressed by the claimed specs. I bet if i knew how much it sells 
for, i'd be shocked. I did a little searching but didn't have much luck.

> -- 
> Stan

p.s. Sory for the duplicate Stan, I couldn't figure out how to disable html on 
my android mail client, and linux-raid bounced it.

--
Thomas Fjellstrom
thomas@fjellstrom.ca
