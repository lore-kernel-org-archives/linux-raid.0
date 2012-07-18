From: Alexander Schleifer <alexander.schleifer@googlemail.com>
Subject: Re: RAID5 speed goes down
Date: Wed, 18 Jul 2012 11:26:15 +0200
Message-ID: <CA+=meHUK7Sw32BYA57iPNQHpZHPp8s8HOnb5dXA_kwq__H_FEw@mail.gmail.com>
References: <CA+=meHWy3Uejy+At8kB0u4AyRPqR1B_iZoD1LOfFDw5GsmUqkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+=meHWy3Uejy+At8kB0u4AyRPqR1B_iZoD1LOfFDw5GsmUqkg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I assume, that there is no physical error on the harddisks, because
nothing shows up in log files, SMART values are OK, resync end with no
error and fsck also found nothing to repair.
So I changed the scheduler from cfq to deadline, but this only takes a
couple of minutes longer until the RAID locks up. In iotop, I can see
the process "smbd", which I used for the file transfer -  it uses
about 98% of IO. Trying to unmount or stop the array will take
forever, even if I try to kill the smbd process.
I will now try to get a lock by transferring a file to a harddisk
which is not in this array.

-Alex

2012/7/16 Alexander Schleifer <alexander.schleifer@googlemail.com>:
> Hi,
>
> after re-sync and fsck, everything seems fine. The first try to copy a
> big test file to the raid5 starts with a speed of ~45 MB/s which is
> perfect, but after a couple of minutes the speed goes down to ~10
> KB/s. The only way to get the raid5 working again was to reset the
> system. The raid5 then goes again in resync from an unclean array. I
> checked dmesg, but found nothing. What can I do to get more
> information what is going on there?
>
> Thanks,
> Alex
