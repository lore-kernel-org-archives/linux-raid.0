From: Alex Besogonov <alex.besogonov@gmail.com>
Subject: Working TRIM for md RAID
Date: Tue, 18 Oct 2011 16:24:22 -0400
Message-ID: <CA+4wGE4VwodRhzi4FQ0+32Vd9UmjVt-xy34t-uBRxsGbVkdkZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, I've written a simple utility which TRIMs empty space on MD RAID-1
devices, ext4/3 on RAID-1 are supported. My script was inspired by
raid1ext4trim.sh-1.4 script in hdparm, but my script also supports TRIM on
arbitrary partitioned devices.

Since it calls TRIM on raw devices there is a possibility of really bad data
corruption bugs. So there's test/test.sh script which try to test mdtrim by
creating MD array on a single SSD drive, filling it up with random data and
then TRIMing empty space. So far, it works for me but it would be great to
have more test results.

You can get it here: https://github.com/Cyberax/mdtrim
