From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: Re-adding disks to RAID6 in a Fujitsu NAS: old mdadm?
Date: Thu, 28 Jun 2012 11:42:15 +0200
Message-ID: <4FEC26F7.5020006@xunil.at>
References: <4FE9BFC1.5070607@xunil.at> <20120628163205.2c6a1122@notabene.brown> <4FEC1CE7.5010709@xunil.at> <20120628193905.1049b243@notabene.brown>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120628193905.1049b243@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 28.06.2012 11:39, schrieb NeilBrown:

> You just need a 32 bit build environment (not 64 bit).  It doesn't
> matter what the kernel is. You might manage it with
> 
> make mdadm.static CWFLAGS=-m32 LDFLAGS=-m32
> 
> depending on what you have installed.
> 
> BTW, I got the command a bit wrong.  This works.
> 
> git clone git://neil.brown.name/mdadm ; cd mdadm; git checkout
> mdadm-2.6.5 ; make mdadm.static CWFLAGS=-Wall
> 
> I happen to have a 32bit machine, so I'll send you the resulting
> binary in private email (don't want to clog up the list).

Thanks a lot for the offer, but as mentioned in my other mails, I
managed to build and use it already!


