From: Fisher <fisherthepooh@protonmail.com>
Subject: mdadm: not zeroing non-valid bad block log content in newly added disk
Date: Mon, 17 Feb 2020 07:20:04 +0000
Message-ID: <ZCC5pso8ZQLBtsLjK-LJY3XYVwZVB69vRPXXqmhgUeOBf9wpb5h2pjqpvvS2O9n5ztEtGmG3izyYpjZmrS1wIRSwO2vPXPzVOSBgvpvzhVM=@protonmail.com>
Reply-To: Fisher <fisherthepooh@protonmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I got a 2-disk raid1 and I was trying to add a new disk to this array,

right after it was added in, before any IOs came in

I found there're bad blocks present from mdadm --examine

and the bad block log content was like

    8664206884405890 for 512 sectors
    8664206884406402 for 125 sectors
    8798941702130700 for 49 sectors
   18014398509481983 for 512 sectors

those offset and size weren't even valid

if I first zeroing the whole disk I would get

         0 for 0 sectors
         0 for 0 sectors
         0 for 0 sectors
         0 for 0 sectors

mdadm copied the superblock from one of the component disk to

the new disk before adding it to array, and that disk happened to

have bad blocks, so the new disk would have bad block flag set

but with a bunch of non-valid content in the log, there're chances

that this disk might be rejected by kernel while loading bad block list.

Looks like it was a false alarm, I was wondering is there any

reason not to clean bad block log before new disk adding in?

Thanks,
