From: Phil Turmel <philip@turmel.org>
Subject: Re: Mdadm with data offsets
Date: Mon, 14 Dec 2015 07:55:20 -0500
Message-ID: <566EBC38.7060205@turmel.org>
References: <CAH_hVdp4mGE-AZ1ww81u9vS0xri4xR+LrpaRSbaUb6VRohZ_Rg@mail.gmail.com>
 <566E0440.70801@turmel.org> <566E05B2.20803@turmel.org>
 <CAH_hVdo43dSuaeJT-QGN14LhiRnR1zYVFwqvueV6vxthHYYU9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH_hVdo43dSuaeJT-QGN14LhiRnR1zYVFwqvueV6vxthHYYU9g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "TheGerwazy ." <gerardlesiuk@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/14/2015 07:03 AM, TheGerwazy . wrote:

> Hi  Phil
> Thanks for the message .... but,
> In the last version of mdadm I get:
> 
> ./mdadm --create --raid-devices=8 --level=6 --assume-clean /dev/md7
> /dev/mapper/ovsdb1:1024 /dev/mapper/ovsdc1:4096
> /dev/mapper/ovsdd1:1024 /dev/mapper/ovsde1:1024
> /dev/mapper/ovsdf1:1024 /dev/mapper/ovsdg1:1024
> /dev/mapper/ovsdh1:1024 /dev/mapper/ovsdi1:4096
> mdadm: cannot open /dev/mapper/ovsdb1:1024: No such file or directory

The final version of that feature requires --data-offset=variable before
the :offset syntax is recognized on the devices.

> sudo ./mdadm --create --raid-devices=8 --level=6 --assume-clean

> mdadm: array /dev/md7 started.

You're committed now.  I hope it works out for you.

> BTW is it possible to find right data offset without superblock on drive ?

Only if the content of that member device has searchable content in a
predictable location.  In practice that means finding the offset of the
first member by locating filesystem magic, or otherwise locating the
transition from all zeros to randomish data.

Good luck.

Phil

