From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: some IDE trays are bad (was Re: SW-RAID 1 and kernel
  2.4.18)
Date: Tue, 03 Dec 2002 14:06:30 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.1.6.2.20021203135305.06fa94e0@mail.harddata.com>
References: <984305F1827DD5118FEA0000D1105F0A01BDC029@HW_MAIL>
 <984305F1827DD5118FEA0000D1105F0A01BDC029@HW_MAIL>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021203160141.GA7990@apartia.org>
To: Louis-David Mitterrand <vindex@apartia.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With regards to your message at 09:01 AM 12/3/02, Louis-David Mitterrand. 
Where you stated:
>On Tue, Nov 26, 2002 at 02:56:41PM +0100, SCHEP. - Schepke, Arnt wrote:
> > Hi, i have a running software raid 1. This consist of two ide devices hda
> > and hdc. The root filesystem is running on this raid array. The harddiscs
> > are installed in removable frames.
>                    ^^^^^^^^^^^^^^^^^
>
>That is the issue.
>
><<snip>>
>I've just had the same problem. My setup: 4 Maxtor 160G connected to a
>Promise 133TX2 card, one of them was in an Icy Dock removable rack, the
>three remaining were directly connected to the IDE cable.
>
>The tray-connected disk would always give us the BadCRC error upon
>resynching with the raid5 array. That kind of error is typical of bad
>cabling.
That type of error is also typical of Promise and other inferior IDE cards.
using IDE ports on motherboards, and using 3Ware cards we rarely see this 
issue.
Using Promise we frequently see it.
Also, cables are important, I agree. Yellow Teflon/TPE cables make a big 
difference.
The cheap grey ones are not suitable for this type of use.



With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

Ask me about NAS and near-line storage

