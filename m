From: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Subject: Re: ANNOUNCE: mdadm 3.2.4 - A tool for managing Soft RAID under Linux
Date: Sat, 12 May 2012 08:36:43 +0200
Message-ID: <2598499.YYnUQlf0Se@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

fyi, this release contains a hidden strict-aliasing-violation bug [1].
please fix this correctly or build mdadm with -fno-strict-aliasing option.

[1] http://www.spinics.net/lists/raid/msg37298.html

