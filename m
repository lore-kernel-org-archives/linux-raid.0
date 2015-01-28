From: John Drescher <drescherjm@gmail.com>
Subject: Re: raid5 Unplug the disk
Date: Wed, 28 Jan 2015 11:59:30 -0500
Message-ID: <CAEhu1-4krpTbF-0mLdgoTKrkdrWo8J2k80BC0t48rv3WkG3UBA@mail.gmail.com>
References: <2c82c493-1fd8-4e59-9f9c-ecd2ab4296e3@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2c82c493-1fd8-4e59-9f9c-ecd2ab4296e3@aliyun.com>
Sender: linux-raid-owner@vger.kernel.org
To: lilofile <lilofile@aliyun.com>
Cc: stan <stan@hardwarefreak.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jan 28, 2015 at 1:44 AM, lilofile <lilofile@aliyun.com> wrote:
> kernel  linux 3.10, centos
> when I use 5 disk to create raid5,after sync complete, I unplug a disk,and wait a moment, then replug the same disk.
>
> the original 4 disk are still a raid5 which is degraded.
> I find the single disk  become a new raid5,but inactive,what the reason?

stop whatever new array that shows up then use

mdadm --manage /dev/mymddevice --re-add /dev/disk5

John
