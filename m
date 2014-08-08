From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Making spare device into active
Date: Fri, 8 Aug 2014 19:25:24 +0200
Message-ID: <CAAOsTSmkyCqLxrG-q2PQxnbXiAC1zz=qw6+ekMUmY=N+ZoHZ-w@mail.gmail.com>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

I am experiencing the problem with one RAID6 array.

- I was running degraded array with 3 of 5 drives. When adding fourth
HDD one of the drives reported read errors, later disconnected and
then it was kicked out from array. (It was maybe doing of controller
and not drive, not important.)

- The array has internal intent bitmap. After the drive reconnected
I've tried it to --re-add to array with 2 of 5 drives. I am not sure
if that should work? But it did not, recovery got interrupted just
after start and drive was marked as spare.

- Right now I want to assemble array to get data out of it. Is it
possible to change "device role" field in device's superblock so it
can be assembled? I I have --examine and --detail output from before
the problem and so I know at which position the kicked drive belongs.

- Changing device role field seems much safer way than recreating
array with --assume-clean, because with recreating too much things can
go wrong...

Thanks.

Patrik
