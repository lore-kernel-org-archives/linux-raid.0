From: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: raid 1 vs raid 0+1
Date: Tue, 29 Oct 2002 13:08:35 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210291248490.1104-100000@grace.speakeasy.net>
References: <20021029153930.GA21099@smeagol>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021029153930.GA21099@smeagol>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> If everyone else is going to start squirting testosterone around, then
> I'll add my share:
> 
> The above code, made an average time of about 3.7s .  This is with
> raid-5 (soft) 2.4.20pre8 with 4 IDE drives (Ibm 120 gig 7200rpm)
> running at/on a Promise ATA/100 card (so 2 drives per bus).  Also, the
> filesystem is reiserfs, and running at medium-light load.

Oh me too!


dual P3 1Ghz, 1GB ram, 2.2.20RAID, ext2, Mylex extremeraid 2000 hardware
RAID5, six IBM 36LZX 10k RPM 36GB U160 SCSI drives.

1.89 seconds

same system, but mylex hardware RAID0 instead of raid5, still 1.89 seconds.

same system, but with a 3ware 7850 with six maxtor 160GB drives....  1.89
seconds.

same system, but with two IBM 18LZX 18GB 10k RPM SCSI drives on an onboard
adaptec U160 controller and linux software RAID0...  1.88 seconds.

It seems disk+controller doesn't matter one bit for this test.

Now a new system:

dual AthlonXP1800, 1GB ram, 2.4.16, ext3, 3ware 7410 RAID0, two maxtor 160GB
drives...  2.38 seconds

Conclusion:  either ext3 or the 2.4 kernel are slow, as the second machine as
has PC2100 RAM vs PC133 and 1.5Ghz athlons vs 1Ghz pentiumIIIs.  It should
be faster, not slower.


