From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: DPT SmartRAID IV question...
Date: Fri, 30 Jul 2004 10:31:13 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01152A33@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: michael@insulin-pumpers.org, Mark Watts <mrwatts@fast24.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am biased.

I have bashed these cards as hard as I can; they have remained
bulletproof for me. Their only problem is a maximum throughput of
10MB/sec to the host, and they support more operating systems than
almost anything else on the planet (IDE interface notwithstanding).

What F/W version do you have on the cards?

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Michael
Sent: Thursday, July 29, 2004 7:03 PM
To: Mark Watts
Cc: linux-raid@vger.kernel.org
Subject: Re: DPT SmartRAID IV question...

> I've managed to acquire a DPT SmartRAID IV 3334W card with the
SX4030/1UW 
> daughterboard and 32MB of cache ram...
> 

I have two different models of the DPT SmartRAID board -- both are buggy

and cause data loss (software raid corruption) on high disk loads such
as 
copying large files. I'm still using them for $$ reasons, and on 
relatively low loads they seem to be OK. There are some notes floating 
around the net that some of these boards have bugs in the microcode.
I've 
confirmed that for one type of board I have. Sorry, don't know the model

numbers offhand, they are buttoned up in the machines. I have a spare 
daughterboard that is a 4050.

If I had the option, I would make boat anchors of the cards and the
scsii 
disks that go with them. They've been nothing but trouble. We have a 
dozen Linux raid 1 and 5 hosts and these are the only ones that ever 
fault. We run very low duty cycle on the disk IO so it's not a problem 
for us at the moment.

Michael

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
