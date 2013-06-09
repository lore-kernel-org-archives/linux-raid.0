From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Enlarging device of linear array
Date: Sun, 09 Jun 2013 03:31:44 -0500
Message-ID: <51B43D70.50004@hardwarefreak.com>
References: <20130608201810.26c19641@hoferr-x61s.hofer.rummelring>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130608201810.26c19641@hoferr-x61s.hofer.rummelring>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/8/2013 1:18 PM, Ramon Hofer wrote:
> Dear Stan and linux-raid list

Hi Ramon.

> My home server with a linear raid (md0) containing three raid5 (md1,
> md2, md3) is still working wonderfully. Thanks again Stan!

Glad to hear it. :)

<snip>
> Is this possible and a good idea?

No, it is not possible to expand a linear array this way.
...
> If in some years one of the oldest 1.5 TB disks of md2 or any other
> fails, I could replace it with a bigger one and at the same time the
> other disks of the same device as well and get additional space?

You can use the extra capacity, but not in the way you're considering.
This is due to the characteristics of a linear array.

You have been using raw disks, not partitions.  So when you replace a
dead drive you will need to create a partition on the replacement that
is the same size or a few sectors larger than the disk being replaced.
You will then use this partition as the replacement device in the array
rebuild.  After you have replaced all 4 drives in this manner, you will
create a 2nd partition in the free space on each.  You will then create
another RAID5 array from these 4 partitions and add it just as you did
the other RAID5s.

-- 
Stan

