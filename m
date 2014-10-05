From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Hot replacing device in RAID 6
Date: Sun, 5 Oct 2014 18:36:45 +0200
Message-ID: <CAAOsTSmn3MDn-a6usUTpmBObwYngvFNNRUXXF6zhmDKyUTHU_w@mail.gmail.com>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

I want to ask for best solution for replacing device in RAID 6 array.
I want to replace device (actually RAID 0 array of two drives), which
is working OK but there is known problem with firmware of one drive of
that RAID 0 and no solution for it. (It can cause lock up of the
drive, which happened to me.)

I want to minimize risk of problems on any device / devices during
adding new drive, so I am considering other solutions than remove old
and add new.

- We discussed couple of years ago hot replacing the drive. I see it
is now supported in mdadm. Is it rock stable and can be used on
production data? I have kernel and mdadm from debian testing, 3.14-2
and 3.3-2. Were there some important fixes from these versions? I have
this server on UPS but not on aggregator so there is real danger of
power outage and need to shutdown the array during operation.

- I can take the array offline. Is it good solution to simply copy the
old device to new device?

- Or do you suggest as safest solution to remove old device and add new one?

Thanks.

Best regards,

Patrik
