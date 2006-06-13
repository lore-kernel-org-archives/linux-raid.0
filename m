From: "=?GB2312?B?yubQxw==?=" <xshu2006@gmail.com>
Subject: why raid5 not like this?
Date: Tue, 13 Jun 2006 11:32:02 +0800
Message-ID: <7de068fd0606122032t5641c96fm62a208d074750f12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

in linux raid4/5/6  ,one big bio will span several devices,and There
may be several bio's per stripe+device.if the bio arrived in bi_sector
with overlap,we must wait the former bio to be finished.
why not we split the bigger bio into small ones?we can attach the
smaller bio to the stripe+device (here we may can do some merge ).one
disk i/o we can finish many small bios.if all the small bios of the
request be finished ,we can return the request.
