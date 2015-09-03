From: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Subject: Re: Expanding RAID0
Date: Thu, 3 Sep 2015 13:53:08 +0300
Message-ID: <CAETWcfvLeFHj3hLg9hJc83Z=6i2UV4NgQpVUp_NqYo=qxbgUHQ@mail.gmail.com>
References: <CAETWcftSGsOnm6FX49cPs3S5TTGbAOFt0-s3Fq850q8qJfDtGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAETWcftSGsOnm6FX49cPs3S5TTGbAOFt0-s3Fq850q8qJfDtGA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Small correction:

- mdadm -G -l 0 -n 3 /dev/md3

Regards,
Alexander

On Wed, Sep 2, 2015 at 11:57 AM, Alexander Afonyashin
<a.afonyashin@madnet-team.ru> wrote:
> Hi,
>
> I added 3rd drive to 2-disk raid0 (with some issues like mdadm hung
> and all disks became spares) but now it looks like:
>
> md3 : active raid4 sda4[0] sdc4[3] sdb4[1]
>       1304305152 blocks super 1.2 level 4, 512k chunk, algorithm 5 [4/3] [UUU_]
>
> (/dev/sdc4 was added). I wonder what should be better to convert raid4
> back to raid0 again:
> - mdadm -G -l 0 -n 0 /dev/md3
> or
> - echo 0 > /sys/block/md3/md/level
>
> Which command doesn't start 'sync' process again? (I suspect that
> first one does)
>
> Regards,
> Alexander Afonyashin
