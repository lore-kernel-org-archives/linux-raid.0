From: Fisher <fisherthepooh@protonmail.com>
Subject: Is it possible to create a single zone RAID0 with different size member disks?
Date: Fri, 10 Apr 2020 09:29:19 +0000
Message-ID: <5ng5lZpZoJjtdf9Xkshn3CSzsLIErcNWAzPPARDbDdzNY9Kr-tgMjy6djUaqRVo9r9KmB2HMV0ZQuurdV7wNDYGOP4azAiw1jPkcoF10-SM=@protonmail.com>
Reply-To: Fisher <fisherthepooh@protonmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I got four disks with different size each,

first I created a raid0 and I found that nr_strip_zones larger than 1,

but I think I would convert it to raid4/5/6 someday in the future,

so I need nr_strip_zones to be 1,

then I tried to add --size to specify the used size of each disk when creat=
ing the raid0,

but the raid0 to raid4 conversion failed because nr_strip_zones still large=
r than 1,

Is there any way I can create a single zone raid0 with different size membe=
r disks?

Thanks,
