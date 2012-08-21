From: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Subject: RE: md raid6 not working
Date: Tue, 21 Aug 2012 11:17:57 +0000
Message-ID: <429D03F4F1CC234886D1288428CFE8E0D42B0E@CH1PRD0102MB110.prod.exchangelabs.com>
References: <CC5802CB.287BB%michael.vanhorn@wright.edu>,<20120821083402.5e5b2fcf@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120821083402.5e5b2fcf@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you for your response. Here is the output you requested.

>What is the result of:
>
>  mdadm -S /dev/md0

# mdadm -S /dev/md0
mdadm: stopped /dev/md0
#

>  mdadm -Avvv /dev/md0

# mdadm -Avvv /dev/md0
mdadm: looking for devices for /dev/md0
mdadm: cannot open device /dev/sdi1: Device or resource busy
mdadm: /dev/sdi1 has no superblock - assembly aborted
#

---
Mike VanHorn
Senior Computer Systems Administrator
College of Engineering and Computer Science
Wright State University
265 Russ Engineering Center
937-775-5157
michael.vanhorn@wright.edu
http://www.cecs.wright.edu/~mvanhorn/

