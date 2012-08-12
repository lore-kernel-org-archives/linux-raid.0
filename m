From: Phil Turmel <philip@turmel.org>
Subject: Re: Disk Order
Date: Sun, 12 Aug 2012 19:57:11 -0400
Message-ID: <502842D7.40005@turmel.org>
References: <50281BB1.6030309@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50281BB1.6030309@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Tripathy <jonnyt@abpni.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jonathan,

On 08/12/2012 05:10 PM, Jonathan Tripathy wrote:
> Hi Everyone,
> 
> Our server currently has 6 SATA ports on the motherboard filled with 6
> drives in RAID10. I have a need to install an additional PCIe SATA
> controller in a server in order to obtain 2 more SATA ports to install
> an additional 2 new drives (As I want a new RAID1 array). However I
> would like to move one of the current drives onto the new controller,
> and one of the new drives onto the motherboard. This should give me a
> little redundancy in case the new controller card were to fail (I don't
> want the new controller to bring down 2 drives).

Reasonable plan.

> When setting up MD RAID in this configuration, how would I go about tell
> MD RAID which disk is which in the array (referring to the near/far
> configurations)? I'm assuming by default that MD RAID just uses
> alphabetical order in order to determine the drive order?

No, MD uses the order they were specified in the "--create" operation,
and records that in metadata on each device.  Re-assembly can specify
them in any order--MD will put them into the correct role.

> Let's say the RAID10 drives will be sda sdb sdc sdd sde sdg*, where sdg
> is the second of the RAID0 strip of sde.
> And the two new RAID1 drives are sdf sdh*.
> The drives with the asterisks beside them will be on the new PCIe
> controller.

Probe order during boot is not guaranteed--you might discover that the
new controller gets /dev/sda and /dev/sdb.  Or with parallel probing you
might get /dev/sda[acefgh] on the mobo and /dev/sd[bd] on the new
controller.  (Not terribly likely, in my limited experience.)

You should consider recording what drive serial number is hooked to what
port, and compare that to your device names.  You might find my "lsdrv"
script useful for this, as that was its original purpose.[1]

Or just print a copy of "ls -l /dev/disk/by-id/".

> Do I have to do anything special for this configuration? Will there be a
> performance hit since one drive in the RAID10 array will be on a
> different controller?

Might be faster, if you have really fast drives.  Unlikely to be slower.

HTH,

Phil

[1] http://github.com/pturmel/lsdrv

