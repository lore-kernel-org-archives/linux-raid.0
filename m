From: Alexander Schleifer <alexander.schleifer@googlemail.com>
Subject: RAID5 speed goes down
Date: Mon, 16 Jul 2012 22:10:09 +0200
Message-ID: <CA+=meHWy3Uejy+At8kB0u4AyRPqR1B_iZoD1LOfFDw5GsmUqkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

after re-sync and fsck, everything seems fine. The first try to copy a
big test file to the raid5 starts with a speed of ~45 MB/s which is
perfect, but after a couple of minutes the speed goes down to ~10
KB/s. The only way to get the raid5 working again was to reset the
system. The raid5 then goes again in resync from an unclean array. I
checked dmesg, but found nothing. What can I do to get more
information what is going on there?

Thanks,
Alex
