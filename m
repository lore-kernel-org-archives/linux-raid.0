From: "Rob Bray" <raid@bymeinc.com>
Subject: Re: ATA cables and drives
Date: Thu, 21 Sep 2006 14:38:15 -0400 (EDT)
Message-ID: <48204.192.168.0.1.1158863895.squirrel@bymeinc.com>
References: <62b0912f0609160616k3b79ded9la2c918df057daef0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0609160616k3b79ded9la2c918df057daef0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I'm looking for new harddrives.
>
> This is my experience so far.
>
>
> SATA cables:
> =============
>
> I have zero good experiences with any SATA cables.
> They've all been crap so far.
>
>
> 3.5" ATA harddrives buyable where I live:
> ==========================================
>
> (All drives are 7200rpm, for some reason.)
>
> Hitachi "DeskStar"              500 GB / 16 MB /  8.5 ms / SATA or PATA
> Maxtor "DiamondMax 11"          500 GB / 16 MB /  8.5 ms / SATA or PATA
> Maxtor "MaXLine Pro"            500 GB / 16 MB /  8.5 ms / SATA or PATA
> Seagate "Barracuda 7200.10"     500 GB / 16 MB /    ?    / SATA or PATA
> Seagate "Barracuda 7200.10"     750 GB / 16 MB /    ?    / SATA or PATA
> Seagate "Barracuda 7200.9"      500 GB / 16 MB / 11   ms / SATA or PATA
> Seagate "Barracuda 7200.9"      500 GB /  8 MB / 11   ms / SATA or PATA
> Seagate "Barracuda ES"          500 GB / 16 MB /  8.5 ms / SATA
> Seagate "Barracuda ES"          750 GB / 16 MB /  8.5 ms / SATA
> Seagate "ESATA"                 500 GB / 16 MB /    ?    / SATA (external)
> Seagate "NL35.2 ST3500641NS"    500 GB / 16 MB /  8   ms / ? / SATA
> Seagate "NL35.2 ST3500841NS"    500 GB /  8 MB /  8   ms / ? / SATA
> Western Digital "SE16 WD5000KS" 500 GB / 16 MB /  8.9 ms / SATA
> Western Digital "RE2 WD5000YS"  500 GB / 16 MB /  8.7 ms / SATA
>
> I've tried Maxtor and IBM (now Hitachi) harddrives.
> Both makes have failed on me, but most of the time due to horrible
> packaging.
>
> I don't care a split-second whether one kind is marginally faster than
> the other, so all the reviews on AnandTech etc. are utterly useless to
> me.  There's an infinite number of more effective ways to get better
> performance than to buy a slightly faster harddrive.
>
> I DO care about quality, namely:
> * How often the drives has catastrophic failure,
> * How they handle heat (dissipation & acceptance - how hot before it
> fails?),
> * How big the spare area is,
> * How often they have single-sector failures,
> * How long the manufacturer warranty lasts,
> * How easy the manufacturer is to work with wrt. warranty.
>
> I haven't been able to figure the spare area size, heat properties,
> etc. for any drives.
> Thus my only criteria so far has been manufacturer warranty: How much
> bitching do I get when I tell them my drive doesn't work.
>
> My main experience is with Maxtor.
> Maxtor has been none less than superb wrt. warranty!
> Download an ISO with a diag tool, burn the CD, boot the CD, type in
> the fault code it prints on Maxtor's site, and a day or two later
> you've got a new drive in the mail and packaging to ship the old one
> back in.  If something odd happens, call them up and they're extremely
> helpful.
>
> Unfortunately, I lack thorough experience with the other brands.
>
>
> Questions:
> ===========
>
> A.) Does anyone have experience with returning Hitachi, Seagate or WD
> drives to the manufacturer?
>     Do they have manufacturer warranty at all?
>     How much/little trouble did you have with Hitachi, Seagate or WD?
>
> B.) Can anyone *prove* (to a reasonable degree) that drives from
> manufacturer H, M, S or WD is of better quality?
>     Has anyone seen a review that heat/shock/stress test drives?
>
> C.) Does good SATA cables exist?
>     Eg. cables that lock on to the drives, or backplanes which lock
> the entire disk in place?
>
>
> Thanks for reading, and thanks in advance for answers (if any) :-).
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I've experienced consumer-class drive failures with Seagate, Western
Digital, and Maxtor. WD is the only one I've had catastrophically fail on
me -- the rest developed bad sectors slowly enough to catch. I have yet to
have a Hitachi drive fail. WD got a bad name with me when they sold drives
under the same model number while changing to different drives (assembled
in Thailand) that performend considerably slower than the originals (from
Malaysia).

Warranty experiences with Western Digital, Maxtor, and Seagate have been
pleasant and quick (although WD and Maxtor sent me refurbished disks).
I've never been refused a drive replacement. Maxtor required me to
generate a code with their proprietary tool before the website would even
talk about a replacement; a way around this was to select "Drive doesn't
spin up" as the symptom :-P

Consumer-level drives are made primarily with volume and profit margin in
mind. If reliability is a chief concern, most server-class drives are
designed with longer service life and higher reliability in mind. If price
is paramount, as you said, go for the most inexpensive disk with the
longest warranty.

