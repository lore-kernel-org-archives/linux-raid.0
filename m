From: Mark Watts <mrwatts@fast24.co.uk>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sat, 31 Jul 2004 17:42:38 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407311742.38058.mrwatts@fast24.co.uk>
References: <Pine.LNX.4.44.0407311822460.3362-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0407311822460.3362-100000@uplift.swm.pp.se>
Content-Disposition: inline
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Jon Lewis <jlewis@lewis.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On Sat, 31 Jul 2004, Jon Lewis wrote:
> > Hardware RAID5 or software RAID5?  My experience has been that even the
> > higher end hardware RAID5 cards I've dealt with give nowhere near the
> > performace you get with software RAID5.  HW RAID5 is a good way to make
> > an IO intensive system turn into a slug.
>
> It doesn't matter. On small writes you need to do a lot of reads to get
> the parity correct. If you do a lot of sequencial writes then RAID5 is ok,
> if you do a lot of random writes, then RAID5 is bad.
>
> HW 3ware raid5 is ok if you just do "cat /dev/null > /dev/sda", you'll get
> nice write speeds, but for real life filesystem writes it needs to read a
> lot to write the correct parity and this is quite slow. The only thing
> software RAID5 solves is that it can use system memory to cache a lot more
> than the HW 3ware RAID5 card can, so it can sometimes avoid to read from
> the drives before writing parity.
>
> This doesn't change the fact that if you need to do a lot of random writes
> and you need to do it quickly, avoid RAID5:ing large number of drives.

So why are scsi raid-5 systems so much better?
