From: Sarah Newman <srn@prgmr.com>
Subject: Re: FW: change in disk failure policy for non-BBL arrays?
Date: Fri, 3 Nov 2017 13:19:28 -0700
Message-ID: <2bd80694-a168-2ae7-c1db-e9b8d3b29657@prgmr.com>
References: <ebc61f38-b401-c01a-5c2a-4671287f6eee@cray.com>
 <294F8C1D-AFB2-4445-9F7B-18D761A6D846@cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <294F8C1D-AFB2-4445-9F7B-18D761A6D846@cray.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Chris Walker <cwalker@cray.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/03/2017 12:58 PM, Chris Walker wrote:
> Hello,
> I was looking at this again today and it appears that with this change, error handling no longer works correctly in RAID10 (I haven't checked the other levels yet).  Without a BBL configured, an error cycles through fix_read_error until max_read_errors is exceeded, and only then is the drive kicked out of the array.  For example, if I inject errors in response to both read and write commands at sector 16392 of /dev/sda, logs in response to a read of the corresponding md0 sector look like:
>  
> (many repeats)
> Oct 27 16:15:16 c1 kernel: md/raid10:md0: unable to read back corrected sectors (8 sectors at 16392 on sda)
> Oct 27 16:15:16 c1 kernel: md/raid10:md0: sda: failing drive
> Oct 27 16:15:16 c1 kernel: md/raid10:md0: read correction write failed (8 sectors at 16392 on sda)
> Oct 27 16:15:16 c1 kernel: md/raid10:md0: sda: failing drive
> Oct 27 16:15:16 c1 kernel: md/raid10:md0: unable to read back corrected sectors (8 sectors at 16392 on sda)
> Oct 27 16:15:16 c1 kernel: md/raid10:md0: sda: failing drive
> Oct 27 16:15:16 c1 kernel: md/raid10:md0: sda: Raid device exceeded read_error threshold [cur 21:max 20]
> Oct 27 16:15:16 c1 kernel: md/raid10:md0: sda: Failing raid device
> Oct 27 16:15:16 c1 kernel: md/raid10:md0: Disk failure on sda, disabling device.
> 
> Previously, the drive would have been failed out of the array by the call of md_error at the end of r10_sync_page_io.
> 
> Is there an appetite for a patch that takes the easy way out by reverting to the previous behavior with changes like
> 
> -       if (!rdev_set_badblocks(rdev, sector, sectors, 0))
> +       if (!rdev_set_badblocks(rdev, sector, sectors, 0) || rdev->badblocks.shift < 0)
> 
> Thanks,
> Chris
> 

As a RAID10 user that seems like the right thing to do, thank you.

--Sarah
