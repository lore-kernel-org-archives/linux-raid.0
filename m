From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: best base / worst case RAID 5,6 write speeds
Date: Wed, 9 Dec 2015 19:34:56 -0600
Message-ID: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all.  I'm trying to determine best and worst case expected
sequential write speeds for Linux software RAID with spinning disks.

I have been assuming on the following:

Best case RAID 6 sequential write speed is (N-2) * X, where is is
number of drives and X is write speed of a single drive.

Worst case RAID 6 sequential write speed is (N-2) * X / 2.

Best case RAID 5 sequential write speed is (N-1) * X.

Worst case RAID 5 sequential write speed is (N-1) * X / 2.

Could someone please confirm whether these formulas are accurate or not?


I am not even getting worst case write performance with an array of 12
spinning 7200 RPM SATA disks.  Thus I  suspect either the formulas I
am using are wrong or I have alignment issues or something.  My chunk
size is 128 KB at the moment.

Thanks,

Dallas
