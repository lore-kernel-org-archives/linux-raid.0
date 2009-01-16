From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re[2]: [PATCH 07/11] md: rewrite handle_stripe_dirtying6 in asynchronous  way
Date: Fri, 16 Jan 2009 17:46:03 +0300
Message-ID: <1675190812.20090116174603@emcraft.com>
References: <200812090057.33890.yur@emcraft.com> <e9c3a7c20901151351p5e1b4641h1b4c8ba1ae5dcc73@mail.gmail.com> <e9c3a7c20901151421o69522f71rfe6d7d9621de47eb@mail.gmail.com> <91b13c310901151707x48b1ef8av1609c3a622c19565@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <91b13c310901151707x48b1ef8av1609c3a622c19565@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Cheng Renquan <crquan@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

=0D
Hello Cheng,

On Friday, January 16, 2009 you wrote:

> Ack, could you please make the changelog more descriptive?
> and or add some of your benchmark results?

 Of course. We did benchmarking using the Xdd tool like follows:

# xdd -op write -kbytes $kbytes -reqsize $reqsize -dio-passes 2 =E2=80=93=
verbose -target $target_device

 where

$kbytes =3D data disks * size of disk
$reqsize=3D data disks * chunk size
$target_device =3D /dev/md0

 This way we did write of full array size, and thus achieved the=20
maximum performance.

 The test cases were RAID-6 built on the top of 14 S-ATA drives=20
connected to 2 LSI cards (7+7) inserted into the 800 MHz Katmai board=20
(based on ppc440spe) equipped with 4GB of 800 MHz DRAM .

 Here are the results (Psw - write throughput with s/w RAID-6; Phw -=20
write throughput with the h/w accelerated RAID-6):

 PAGE_SIZE=3D4KB, chunk=3D64/128/256 KB
        Psw =3D 71/72/74 MBps
        Phw =3D 128/136/139 MBps

 PAGE_SIZE=3D16KB, chunk=3D256/512/1024 KB
        Psw =3D 81/81/82 MBps
        Phw =3D 205/244/239 MBps

 PAGE_SIZE=3D64KB, chunk=3D1024/2048/4096 KB
        Psw =3D 84/84/85 MBps
        Phw =3D 258/253/258 MBps

 PAGE_SIZE=3D256KB, chunk=3D4096/8192/16384 KB
        Psw =3D 81/83/83 MBps
        Phw =3D 288/275/274 MBps

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
