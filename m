From: Tim Small <tim@buttersideup.com>
Subject: Re: Controller problems during reshape -> can't continue reshape
 after reboot.
Date: Tue, 21 Aug 2012 08:51:02 +0100
Message-ID: <50333DE6.8010708@buttersideup.com>
References: <5032963A.8000908@buttersideup.com> <5032DB8F.2010101@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5032DB8F.2010101@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/08/12 01:51, John Robinson wrote:
> On 20/08/2012 20:55, Tim Small wrote:
>> I was attempting to reshape a RAID5 from 4 to 5 devices.  During the
>> reshape, I had a problem with one of the controller cards in the
>> machine
>
> Sorry this isn't very helpful, but just out of interest, what kind of
> controller card and what was the problem, do you know?

It was a Marvell 9125 AHCI card (highpoint branded), and I've had
numerous problems with them locking up (the 9123s are worse), and have
scrapped all of the Marvell 9123s already, and gone back to using a
combination of Marvell's 88SX7042 (non-AHCI) cards, and Silicon Image
3132 etc. cards.

It's a shame, as Marvell's AHCI cards are readily available, cheap and
do both 6G SATA, and PCIe 2.0, whereas the earlier Marvell cards, and
the Silicon Image cards are all 3G SATA and (more importantly for me)
PCIe 1.0, which ends up being a bottle neck for modern spinning disks...

I wish Intel, Silicon Image (or someone else) would make a reliable SATA
PCIe 2.0 card!

Intel and Silicon Image publish their errata, whereas Marvell keep
their's secret, under NDA, and don't respond to hardware bug reports in
my experience.  Avoid.

Tim.

