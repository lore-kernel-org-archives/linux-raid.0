From: "Michael" <michael@insulin-pumpers.org>
Subject: Re: DPT SmartRAID IV question...
Date: Thu, 29 Jul 2004 15:02:35 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4109118B.381.12E9DDD@localhost>
References: <200407292202.51602.mrwatts@fast24.co.uk>
Reply-To: michael@insulin-pumpers.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <200407292202.51602.mrwatts@fast24.co.uk>
Content-description: Mail message body
To: Mark Watts <mrwatts@fast24.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I've managed to acquire a DPT SmartRAID IV 3334W card with the SX4030/1UW 
> daughterboard and 32MB of cache ram...
> 

I have two different models of the DPT SmartRAID board -- both are buggy 
and cause data loss (software raid corruption) on high disk loads such as 
copying large files. I'm still using them for $$ reasons, and on 
relatively low loads they seem to be OK. There are some notes floating 
around the net that some of these boards have bugs in the microcode. I've 
confirmed that for one type of board I have. Sorry, don't know the model 
numbers offhand, they are buttoned up in the machines. I have a spare 
daughterboard that is a 4050.

If I had the option, I would make boat anchors of the cards and the scsii 
disks that go with them. They've been nothing but trouble. We have a 
dozen Linux raid 1 and 5 hosts and these are the only ones that ever 
fault. We run very low duty cycle on the disk IO so it's not a problem 
for us at the moment.

Michael

