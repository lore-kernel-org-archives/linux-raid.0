From: Bernd Schubert <bs@q-leap.de>
Subject: Re: Reopen: 16 HDDs too much for RAID6?
Date: Fri, 28 Mar 2008 11:35:20 +0100
Message-ID: <200803281135.20890.bs@q-leap.de>
References: <20080306100128.8daad6bd.taeuber@bbaw.de> <200803281114.41018.bs@q-leap.de> <20080328112700.5d5dd662.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080328112700.5d5dd662.taeuber@bbaw.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?utf-8?q?T=C3=A4uber?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Here the conf file:
> monosan:~ # cat /etc/mdadm.conf
> DEVICE /dev/sd[ab][0-9] /dev/dm-*
> ARRAY /dev/md2 level=raid1 UUID=d9d31de2:e6dbd3c3:37c7ea09:882a64e5
> ARRAY /dev/md3 level=raid1 num-devices=2
> UUID=a8687183:a79e514c:ca492c4b:ffd4384f ARRAY /dev/md4 level=raid6
> num-devices=15 spares=1 UUID=cfcbe071:f6766d8f:0f1ffefa:892d09c3 ARRAY
> /dev/md9 level=raid1 num-devices=2 name=9
> UUID=db687150:614e76fd:28feefc0:b1aae572
>
> All dm-* devices are really distinctive. I could post the
> /etc/multipath.conf too if you want.

I only have very little experience with multipathing, but please send your 
config. The fact you really do use multipathing only confirms my initial 
guess it is a multipath and not a md problem.


Cheers,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
