From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: Do I understand my RAID6 correctly?
Date: Tue, 12 Apr 2011 12:42:26 +0200
Message-ID: <4DA42C92.8010704@xunil.at>
References: <4DA40FA4.80605@xunil.at> <4DA41A18.9030602@web.de>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA41A18.9030602@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: Yann Ormanns <yann-ormanns@web.de>
List-Id: linux-raid.ids

Am 12.04.2011 11:23, schrieb Yann Ormanns:

> You now have 9 devices in this Array (750GB*8 = 6 TB, 6 TB - (2*750GB) =
> 4.5 TB). One of them is the failed spare disk. That means, that this
> array can "lose" two disks without losing data, as you already wrote.

Yep, fine.

> Of course you can re-use /dev/sdk as a spare disk, but before, you
> should check, why it failed (SMART data for example).

I already exported the controller-logs and will look through for SMART
info. Unfortunately the controller does not allow the use of
smartmontools, I can only use the specific ICP Storage Manager.

> You should also have a look at the used drive models. E.g. if this array
> uses 9x model XYZ from manucaturer ABC, perhaps more drives will fail in
> the next time.

uuuh

> If the array uses mixed models, it should not be THAT urgent - but that
> depends on the importance of the data...
> I've read several times of people losing their RAID6, because they did
> not mix the hard drive models. Then, a manufacturing fault have very bad
> consequences.

Scary. Yes, the server uses the same model for all 9 devices.
From your domain I see that you seem to be located in germany, so you
might know the manufacturer of the server: transtec.

I already opened a support ticket there, we still have a valid support
contract. Last time they sent a new drive, we'll see.

Thanks, Stefan
