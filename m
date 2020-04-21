From: Leland Ball <lelandmball@gmail.com>
Subject: Re: Recovering From RAID5 Failure
Date: Tue, 21 Apr 2020 12:55:00 -0400
Message-ID: <CAM++EjHie1FFZ7y-VveWBSQs2TW=PkD+-QXKxK_pAON-GrcRcQ@mail.gmail.com>
References: <CAM++EjGaFBh8ZChnyY0p=du0CKFT1WVikSNYyUUcJhuKwQf4sQ@mail.gmail.com>
 <CAAMCDeegCE4x26L4OYttiABxvxiu4qYykAo-b-53G-qW8Ua1Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDeegCE4x26L4OYttiABxvxiu4qYykAo-b-53G-qW8Ua1Hw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks Roger, I appreciate your help and quick reply!

Two of the disks (sda, sdb) were able to return
    # smartctl --all /dev/sdX
just fine, but sdc and sdd returned very little, so I dug a bit deeper with
    # smartctl -d ata -T permissive --all /dev/sdX

The results are in the pastebin: https://pastebin.com/yWJTPvBa
It looks like only sdd has an error count. I would love to get this up
long enough to recover at least a portion of the data, which isn't
backed up elsewhere.
