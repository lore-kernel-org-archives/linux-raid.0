From: Mark Watts <mrwatts@fast24.co.uk>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Fri, 30 Jul 2004 17:17:36 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407301717.36583.mrwatts@fast24.co.uk>
References: <b476569a04072920533b757574@mail.gmail.com> <200407300815.18296.mrwatts@fast24.co.uk> <cedoda$qn4$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cedoda$qn4$1@sea.gmane.org>
Content-Disposition: inline
To: Marc Bevand <bevand_m@epita.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Mark Watts wrote:
> > With the performance issues I'm seeing with the 8506-4LP's I have, I
> > wouldn't recommend them to anyone currently...
> >
> > The thread on LKML from a few days ago about mke2fs -j and 8506-4LP says
> > it all, but basically and reasonable amount of I/O brings a Dual Opteron
> > system to its knees.
> > And by reasonable I mean copying ISO images from a usb2 drive to a raid 5
> > (4 x 250GB maxtor) or even just formatting a 600MB partition.
>
> I would be interested to see the output of 'vmstat 1' while your system is
> so slow.
>
> IMHO you shouldn't draw such conclusion ("reasonable amount of I/O brings a
> Dual Opteron system to its knees") from your particular case. The 3 HT
> links of the Opteron make this CPU particularly adapted to I/O operations.

Well its the only conclusion I *can* come to at this time.
When you move from a UP 1.8Ghz P4 with single EIDE disks to SMP Opteron with 4 
times the ram and a hardware raid card, you tend to assume that performance 
in all areas will go up.
When it doesn't, and you find yourself watching screen redraws while you 
format a 600GB partition (ext3) you do feel the need to blame something :)

I'm all ears for suggestions on what me be wrong or things I can try to 
improve performance.


>
> Personnaly, on a dual Opteron, I am able to read datas from 4 SATA disks at
> about 225 MB/s, with CPU time used at about 32%, awd with a system still
> reasonably responsive.

I'm seeing ~80MB/sec reading from the 3ware raid-5 according to hdparm and 
bonnie++
Write performance is around 25MB/sec according to bonnie++.

Mark.
