From: d c <c866e866e@gmail.com>
Subject: Is it possible to restore a linux raid partition?
Date: Tue, 16 Feb 2016 17:38:10 +0100
Message-ID: <CAM1AHSwqkRhH0WkSOEhWbs=qif_Wwtw5sKoYr0mGTh7E6nT36g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Here is the situation.  I need to restore some old archive files that
were on a raid 5 that was created with a very old Fedora distribution.

The three disks were segmented into three partitions.  Then a separate
raid 5 was created for each of the partitions.  After a few years the
three raids were taken down and the disks were put in a closet.

Recently, I found that I needed some data that was on the 3 raids.
But I was only able to find two of the three raid 5 disks.  The 3rd
disk is gone forever.

I mounted the two remaining disks and was able to get the files out of
two of the three raids.

But for the third raid, linux does not recognize one of the partitions
on one of the disks as a raid partition.

My question is it possible to repair the disk partition so that linux
recognizes it as a raid 5 partition?

thank you
