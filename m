From: =?UTF-8?B?5b2t5pi25Yuz?= <cxpeng111@gmail.com>
Subject: Reshape didn't stop when two disks was removed
Date: Wed, 26 Apr 2017 15:58:16 +0800
Message-ID: <CANxZRwtGKWeVhKGtoHpfQJhy1O7oYrFzmhyoSzXLMUMQzqk7OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I built a raid5 md on 3 disks, than I added two disks to reshape this
md to a five disks raid5 md.
When reshaping the md, two added disks disconneted, but reshape didn't
stop. The md didn't crash, just degraded.

I traced code and I found this problem may be caused by function
error() in raid5.c
In error(), it set faulty bit after calc_degraded.
therefore, when clac_degraded() checking faulty, it didn't count
degrade of the first removed disk.
Should it set_bit faulty before clac_degrade function?

thanks,

Allen
