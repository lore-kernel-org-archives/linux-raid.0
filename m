From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] Assemble: print error message if mdadm fails assembling
 with --uuid option
Date: Mon, 27 Apr 2020 10:44:38 -0400
Message-ID: <291d7ab2-34f8-8f6e-cbd3-18113d9226be@trained-monkey.org>
References: <20190416160817.10526-1-gi-oh.kim@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20190416160817.10526-1-gi-oh.kim@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Gioh Kim <gi-oh.kim@cloud.ionos.com>, linux-raid@vger.kernel.org
Cc: neilb@suse.com, jsorensen@fb.com, jinpu.wang@cloud.ionos.com
List-Id: linux-raid.ids

On 4/16/19 12:08 PM, Gioh Kim wrote:
> When mdadm tries to assemble one working device and one zeroed-out device,
> it failed but print successful message because there is --uuid option.
> 
> Following script always reproduce it.
> 
> dd if=/dev/zero of=/dev/ram0 oflag=direct
> dd if=/dev/zero of=/dev/ram1 oflag=direct
> ./mdadm -C /dev/md111 -e 1.2 --uuid="12345678:12345678:12345678:12345678" \
>     -l1 -n2 /dev/ram0 /dev/ram1
> ./mdadm -S /dev/md111
> dd if=/dev/zero of=/dev/ram1 oflag=direct
> ./mdadm -A /dev/md111 --uuid="12345678:12345678:12345678:12345678" \
>     /dev/ram0 /dev/ram1
> 
> Following is message from mdadm.
> 
> mdadm: No super block found on /dev/ram1 (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/ram1
> mdadm: /dev/md111 assembled from 1 drive - need all 2 to start it (use --run to insist).
> 
> The mdadm say that it assembled but mdadm does not create /dev/md111.
> The message is wrong.
> 
> After applying this patch, mdadm reports error correctly as following.
> 
> mdadm: No super block found on /dev/ram1 (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/ram1
> mdadm: /dev/ram1 has no superblock - assembly aborted
> 
> Signed-off-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>

Applied!

This looks like an ideal case for something to be added to the test suite.

Thanks,
Jes
