From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Linux 5.5 Breaks Raid1 on Device instead of Partition, Unusable
 I/O
Date: Mon, 2 Mar 2020 15:21:16 -0600
Message-ID: <eb7083d2-4bd6-975c-07ea-d5a432606d32@suddenlinkmail.com>
References: <e46b2ae7-3b88-05f2-58d7-94ee3df449e4@suddenlinkmail.com>
 <20200302102542.309e2d19@natsu>
 <920df583-1d9e-6037-1d61-cbd5e1133d4d@suddenlinkmail.com>
 <20200302115141.1e796b7c@natsu>
 <c5d8e6d2-a572-5602-6562-795ea52168ac@suddenlinkmail.com>
 <CAJCQCtTOJrvm7BnyqSSuCUa82ehZbtHgSGaQo1bzcepgdtazSw@mail.gmail.com>
 <9e31d56a-a35d-2413-b6c7-4a97445d487d@suddenlinkmail.com>
 <9b1ceff4-1299-8e8a-cbc9-da717c72bba3@turmel.org>
 <5E5D0AFA.1030701@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E5D0AFA.1030701@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/02/2020 07:32 AM, Wols Lists wrote:
> It's a Seagate Barracuda ... nuff said
> 
> (For David, Barracudas don't support SCT/ERC - they are not recommended
> for raid. Okay for 1 but definitely not anything else. Get an Ironwolf
> to replace it.)

That's a good model!

  It's a shame that drive manufacturers have stripped functionality from most
of the drives over the past 20 years. 20+ years ago when you when you bought a
drive, it had all the drive features standard. Even back to the RLL/MFM days,
all features were supported. Now with the 4 flavors of drives from every
manufacturer it seems to be a race to put out the cheapest stripped down
drives they can make.

  Then don't make 'em like they used to. Just checking the collection of old
boxes still spinning, there is an ancient data drive hanging off one probably
from the mid 2005 timeframe:

 === START OF INFORMATION SECTION ===
Model Family:     Maxtor DiamondMax 10 (ATA/133 and SATA/150)
Device Model:     Maxtor 6L300R0
Serial Number:    L604P3MH
Firmware Version: BAH41E00
User Capacity:    300,090,728,448 bytes [300 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 0
Local Time is:    Mon Mar  2 15:14:20 2020 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

  It has probably been spinning continually for 12-15 years. So long the
power-on hours are reported only as "17h+26m",

  I'll update the thread when the new drives come in and the raid is rebuilt
and let you know how it goes.


-- 
David C. Rankin, J.D.,P.E.
