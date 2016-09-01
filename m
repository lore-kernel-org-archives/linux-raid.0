From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: bootsect replicated in p1, RAID enclosure suggestions?
Date: Thu, 1 Sep 2016 18:22:26 +0100
Message-ID: <57C863D2.2010802@youngman.org.uk>
References: <20160823050947.GL32250@subspacefield.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160823050947.GL32250@subspacefield.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/08/16 06:09, travis+ml-linux-raid@subspacefield.org wrote:
> Hello all,
> 
> So I have an Intel NUC (for low power Linux) plugged via USB into a 4
> bay enclosure doing linear (yeah I know; it's the backup server, the
> primary is raid10).
> 
> And every once in a while, this happens (*see end).  The partition 1
> that would normally contain a MD slice ends up being a replica of the
> boot cylinder.  I can't tell if it's the mdraid linear impl, the
> kernel doing something weird, the USB drivers, the enclosure firmware,
> or what.

Interesting snippet from LWN ...

The Btrfs CRC checking means that a read from a corrupted sector will
cause an I/O error rather than return garbage. Facebook had some storage
devices that would appear to store data correctly in a set of logical
block addresses (LBAs) until the next reboot, at which point reads to
those blocks would return GUID partition table (GPT) data instead. He
did not name the device maker because it turned out to actually be a
BIOS problem. In any case, the CRCs allowed the Facebook team to quickly
figure out that the problem was not in Btrfs when it affected thousands
of machines as they were rebooted for a kernel upgrade.

The article itself is

https://lwn.net/Articles/698090/

Cheers,
Wol
