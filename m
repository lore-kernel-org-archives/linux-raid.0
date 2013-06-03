From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID 10 Repairs
Date: Mon, 03 Jun 2013 00:13:51 -0500
Message-ID: <51AC260F.8050806@hardwarefreak.com>
References: <CAE98Ua_Js7wpfkT7wAZhm79Y46t4Fqtfx3752SUO_+H-3jqqcQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE98Ua_Js7wpfkT7wAZhm79Y46t4Fqtfx3752SUO_+H-3jqqcQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rob Emanuele <rob@emanuele.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/2/2013 9:07 PM, Rob Emanuele wrote:

> So, I've been looking at repairing my RAID 10 software array. I have a
> failing drive with incrementing SMART errors. I went to replace that
> drive with a new drive.  The failing drive is 250,059,350,016 bytes
> while the batch of new drives I bought as spares are 250,000,000,000
> bytes.
> 
> When I add the new drive it tells me the drive is too small.  Is there
> a way to shrink the array so that new new drives (any any other
> replacement drives around 250G) will work in the array?

High Rob,

They're 250GB drives.  Frankly what I'd do is get your investment back
from those 'new' drives, though it probably wasn't much if acquired
recently.  Acquire a number of 750GB, 1TB drives that yield similar
total space after RAID10 overhead.  Build a new array, mkfs, copy all
the data over, and decommission the old disks, then Ebay them.

Or just acquire two 2TB drives an mirror them.  20x 250GB drives in
RAID10 is 2.5TB net space.  Surely you don't currently have 20 drives in
this RAID array.  If you're acquiring 250GB drives in 2013 I'd guess
you're not after performance.  So reducing spindle count shouldn't be an
issue, should it?

-- 
Stan

