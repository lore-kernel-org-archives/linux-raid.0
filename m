From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: some IDE trays are bad (was Re: SW-RAID 1 and kernel
  2.4.18)
Date: Tue, 03 Dec 2002 15:50:43 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.1.6.2.20021203155007.06f55450@mail.harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With regards to your message at 03:10 PM 12/3/02, Gregory Leblanc. Where 
you stated:
>It's probably far more the quality of the connectors and such than the
>length of the cables.
Actually in my experience it is both.
Also the fact that adding more connectors does attenuate a signal.
However we have used the "Icy Dock" trays on occasion,  and I found the 
order of importance for success and failure, in order of impact were:
1) RAID card. HPT were worst, Promise 2nd, and 3Ware best.
2) Cables. The inexpensive grey 80 wire cables are not adequate for this use.
3) Canisters. Icy dock are about typical of any of them. The circuit board 
used to manage the hot-swap does have some impact on the connection, but it 
simply seems to be mostly a matter of more connectors and/or longer cabling 
makes it more sensitive.
Timing issues also creep up.
I have seen a case where a Promise ATA133 card would not negotiate full 
speed with the drives when in a 32 bit, 5V slot, but would succeed when in 
a 64 bit 3.3V slot on the same motherboard.
Even though the cards are only 32 bit.

> > hdparm -t /dev/md1 gives me over 100MB/s on IDE raid5. Incredible! Over
> > twice what a top-of-the-line 15k scsi drive gives me.
I would not consider hdparm to be a reliable test for this type of situation.
bonnie++, using a file size at least 2X real system memory is more 
representative of reality.



With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

Ask me about NAS and near-line storage

