From: Pol Hallen <raid1@fuckaround.org>
Subject: Re: standard performance (write speed 65Mb/s)
Date: Thu, 21 Jul 2011 19:57:16 +0200
Message-ID: <201107211957.16493.raid1@fuckaround.org>
References: <201107181403.49563.raid1@fuckaround.org> <c5a1a83b370a0ddb063cfc828f124e6d.squirrel@fuckaround.org> <CAHX8RiR0MV1iL_OfrVAKGjr0gj7zxtuxFSzMijSgNfKcs0Zz0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHX8RiR0MV1iL_OfrVAKGjr0gj7zxtuxFSzMijSgNfKcs0Zz0Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erwan Leroux <erwan.lerou@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> fdisk -u /dev/sdX
> # -u change the unit displayed by fdisk to sector instead of
> cylinders, this way it's easier to configure
[...]

thanks for guide :-)

after this, my raid5 (rebuilding in progress):

dd if=/dev/zero of=/dev/md0 bs=1024M count=10
10+0 records in
10+0 records out
10737418240 bytes (11 GB) copied, 166.042 s, 64.7 MB/s

Pol
