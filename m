From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: Hardware versus Software
Date: Fri, 21 May 2004 11:57:26 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0405211152270.14297-100000@sweetums.bluetronic.net>
References: <40ABDFEC.9080802@serverone.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40ABDFEC.9080802@serverone.co.uk>
To: Ben Edwards <ben@serverone.co.uk>
Cc: Linux RAID List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 19 May 2004, Ben Edwards wrote:
>... I would be very suprised if software raid was
>faster and if it is I wold think the card is either broke or rubish

Negative.  HW RAID cards may have specialized hardware for doing XOR
calculations.  However, no raid card currently on the market has a 3.2GHz
xeon at it's core.  Most are ARM (up to 750MHz?) or i960 (up to 66MHz) based.
The system CPU can certainly out perform the tiny processors on the raid
card.  Of course, if it's doing raid calculations, it's not do general
computational work which is one reason to use hw raids.

--Ricky


