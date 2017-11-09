From: "David F." <df7729@gmail.com>
Subject: When will Linux support new RAID controllers
Date: Thu, 9 Nov 2017 10:24:54 -0800
Message-ID: <CAGRSmLs-Hr+FFfa4_29kidEeL2d7b+cEP6u1OkOUoYW6Cm15BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It seems that Linux will not see any HD on Intel's 100 Series or newer
chipsets (Z170, etc.) when in RAID mode.  (typically these systems
have M2 NVMe devices ). This is problematic when wanting to use Linux
on the system without having to disable RAID and when on their with
Windows.   Maybe not a linux-raid issue, but is Linux RAID issue
within the kernel device support.
