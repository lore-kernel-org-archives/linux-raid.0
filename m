From: <me@heyjay.com>
Subject: Re: Which raid card to buy for Sarge
Date: Wed, 31 Mar 2004 22:24:19 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <006401c417a1$36a45790$6405a8c0@a30>
References: <008f01c41737$8b57be40$6405a8c0@a30>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'd like to thank everyone who responded, and I didn't mean to start a
software vs hardware war.  But now that I did I'm sort of happy, because
it's made me question if my direction is proper for my goals.

My goal is reliability, not really performance.  I'd like to build a new box
with a mirror (raid 1), and migrate an existing box onto the new box with
the mirror.
Really the new box is an old box (450 Mhz PIII).  I figured I could get a
raid card and be done with it.  But now I'm wondering if I shouldn't skip
getting a raid card and do it with software raid.

Being totally new to Raid, I really don't know the criteria I should be
considering that would lead me down one path or the other.

- I'm using a (fairly) old machine, I have to figure processor speed has to
be an issue with software raid
- When the box is being stressed most of the work is computational, the
process I run puts the CPU% at 98% (according to top).
- Most of the disk activity is read (the disks aren't very active in
general)
- I'm going to use WD 7200 rpm drives
- going to do raid 1
- I'm going to want to do backups onto a tape drive

Thanks
Jay
----- Original Message ----- 
From: <me@heyjay.com>
To: <linux-raid@vger.kernel.org>
Sent: Wednesday, March 31, 2004 9:47 AM
Subject: Which raid card to buy for Sarge


> Hi,
>
> I wanted to buy an IDE raid card, to run inside a stock debian Sarge box.
I
> was hoping someone could point me to a card that will play nice with Sarge
> out of the box.  Seems like all the cards support the usual distros (RH,
> Suse...) but none seem to mention debian (and more specifically Sarge).
I'd
> like a card that can run raid 1 and 5.
>
> If it doesn't run right out of the box, how about one that isn't too hard
to
> get working (I know "too hard" is subjective)
>
> Any suggestions would be very appreciated
>
> Thanks
> Jay
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

