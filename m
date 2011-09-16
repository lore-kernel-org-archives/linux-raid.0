From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Converting RAID1 to RAID5
Date: Thu, 15 Sep 2011 22:54:12 -0400
Message-ID: <4529807989974810517@unknownmsgid>
References: <CAB1R3si_QAtOwfzmYkrUz=+xPO7zSMoZEpO5+oEdXvbUnR1zzw@mail.gmail.com>
 <20110911055703.73deb44d@notabene.brown> <27910711.10376.1316131253095.JavaMail.mobile-sync@iagt29>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27910711.10376.1316131253095.JavaMail.mobile-sync@iagt29>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2011-09-15, at 19:50, Alex <mysqlstudent@gmail.com> wrote:

> When I try to grow the other two partitions (/ and /home), it fails
> with device busy:
>
> # mdadm --grow /dev/md2 --level=5 --raid-devices=3
> mdadm: level of /dev/md2 changed to raid5
> mdadm: Need to backup 128K of critical section..
> mdadm: Cannot set device shape for /dev/md2: Device or resource busy
>       Bitmap must be removed before shape can be changed
> mdadm: aborting level change
>

You must remove the bitmap first as told using mdadm --grow --bitmap=none

>
> When the conversion to RAID5 is complete, how can I regenerate the
> mdadm.conf to properly reflect the change?
>

The output of mdadm -Es might be enough for you.
