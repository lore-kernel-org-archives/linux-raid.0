From: Mark Watts <mrwatts@fast24.co.uk>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Fri, 30 Jul 2004 08:22:50 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407300822.50156.mrwatts@fast24.co.uk>
References: <b476569a04072920533b757574@mail.gmail.com> <200407300815.18296.mrwatts@fast24.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407300815.18296.mrwatts@fast24.co.uk>
Content-Disposition: inline
To: Adam Hunt <kinema@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> > I'm looking at building what I guess you could call a budget NAS
> > array.  I'm looking to start with four 250MB SATA drives on 3ware
> > 8506-4LP controller.  I eventually want to move to eight drives in the
> > box.  Is there any reason to expect that the performance of eight
> > drives spread across two 8506-4LP controllers is going to be any worse
> > then the same eight drives all on one 8506-8?
>
> With the performance issues I'm seeing with the 8506-4LP's I have, I
> wouldn't recommend them to anyone currently...
>
> The thread on LKML from a few days ago about mke2fs -j and 8506-4LP says it
> all, but basically and reasonable amount of I/O brings a Dual Opteron
> system to its knees.
> And by reasonable I mean copying ISO images from a usb2 drive to a raid 5
> (4 x 250GB maxtor) or even just formatting a 600MB partition.

Should be 600GB but I haven't had coffee yet...

Mark.
