From: d tbsky <tbskyd@gmail.com>
Subject: suggest disk numbers in a raidset?
Date: Fri, 20 May 2016 13:13:43 +0800
Message-ID: <CAC6SzHJ8Wi18opzDbzjtT+niM5QKOyOU3AAeo0npbDsV+sQOTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi:
   I need to create a raid6 array with about 20 disks, and it need to
grow up in the future, maybe add another 20 disks into the array.

   I wonder how many disks can a software raid6 array handled? the LSI
hardware raid (2208/3108) can only put 32 disks in an array, and I
heard it may be just use 16 disks in a array is better in LSI.

  the system will be using to put NVR recording files, so the disk
speed is not very important.

  thanks a lot for suggestion!

Regards,
tbskyd
