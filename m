From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] mdadm/Grow: prevent md's fd from being occupied during
 delayed time
Date: Thu, 18 Jun 2020 16:05:59 -0400
Message-ID: <a19f6d66-09d8-6c7d-59f7-762395dd22ea@trained-monkey.org>
References: <1591952439-8768-1-git-send-email-allenpeng@synology.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1591952439-8768-1-git-send-email-allenpeng@synology.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: allenpeng <allenpeng@synology.com>, linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com
List-Id: linux-raid.ids

On 6/12/20 5:00 AM, allenpeng wrote:
> If we start reshaping on md which shares sub-devices with another
> resyncing md, it may be forced to wait for others to complete. mdadm
> occupies the md's fd during this time, which causes the md can not be
> stopped and the filesystem can not be mounted on the md. We can close
> md's fd earlier to solve this problem.
> 
> Reproducible Steps:
> 
> 1. create two partitions on sda, sdb, sdc, sdd
> 2. create raid1 with sda1, sdb1
> mdadm -C /dev/md1 --assume-clean -l1 -n2 /dev/sda1 /dev/sdb1
> 3. create raid5 with sda2, sdb2, sdc2
> mdadm -C /dev/md2 --assume-clean -l5 -n3 /dev/sda2 /dev/sdb2 /dev/sdc2
> 4. start resync at md1
> echo repair > /sys/block/md1/md/sync_action
> 5. reshape raid5 to raid6
> mdadm -a /dev/md2 /dev/sdd2
> mdadm --grow /dev/md2 -n4 -l6 --backup-file=/root/md2-backup
> 
> Now mdadm is occupying the fd of md2, causing md2 unable to be stopped
> 
> 6.Try to stop md2, an error message shows
> mdadm -S /dev/md2
> mdadm: Cannot get exclusive access to /dev/md3:Perhaps a running process,
> mounted filesystem or active volume group?
> 
> Reviewed-by: Alex Wu <alexwu@synology.com>
> Reviewed-by: BingJing Chang <bingjingc@synology.com>
> Reviewed-by: Danny Shih <dannyshih@synology.com>
> Signed-off-by: ChangSyun Peng <allenpeng@synology.com>

Applied!

Thanks,
Jes
