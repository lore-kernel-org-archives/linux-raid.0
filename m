From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: 3ware raid 10 rebuild fails
Date: Mon, 15 Jul 2002 15:50:53 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4D618F6493CE064A844A5D496733D66704DE7B@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: "drenning, bruce" <bdrenni@catholicrelief.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bruce,

> Jul 14 08:24:43 files3 kernel: 3w-xxxx: Received AEN 0xb
> Jul 14 08:24:48 files3 3w-xxxx[583]: Rebuild started on unit 
> 0 on controller
> ID:0. (0xb)
> Jul 14 08:25:02 files3 kernel: 3w-xxxx: Received AEN 0x4
> Jul 14 08:25:04 files3 3w-xxxx[583]: Rebuild/Initialization 
> failed on unit 0
> on controller ID:0. Check drives for media errors. (0x4)
> 
> I tried swapping out the controller w/ another from a 
> spare/test server,
> same result. Running 2.4.9-31 Red Hat kernel under 7.1. Anyone have a
> suggestion as to how to get this array rebuilt? thanks.

This means that there's either a write error on the target disk or a read
error on the source disk for the rebuild; 

First step now should be to back up your data if you haven't done so :-)

Next, I'd check the target disk for errors; best you can do would be to hook
it up to an onboard ide interface and run a manufacturer-provided disgnostic
test on the drive (like DFT for IBM drives for example).

If this test of the target drive turns up nothing you most probably have read
errors on the source drive - not good. 

Writing the damaged sectors can give the drive electronics a chance to remap
them to good areas; alternatively you might want to just replace the drive.

To avoid getting into this situation in the first place, it's a good idea to
regularely scan your raid devices for media damage - recent versions of the
3dmd device manager (I'm running 1.11.00.006) offer an option to schedule
regular scans: Configure => Media Scan. 

Bye, Martin
