From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Kernel preventing (extra) spare disk in array from entering standby
Date: Tue, 24 Oct 2017 16:32:14 +0200
Message-ID: <CAJO99TkXsobN3EszoPM37y=Eth-URQeLTSd8fBDpATHg1x-tmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When looking into disk power-save, I notice that all spare disks attached
to a rebuilding array is sent some type of write request every around 5 second.

In my case, where I have perhaps 12 spares attached to an array, it
unnecessary prevents the remaining 11 spares from entering standby
mode when a rebuild is happening.

Is it possible to do something about this?

-- 
Bj(/)rnar
