From: Alfred Isele <Alfred.Isele@fujitsu-siemens.com>
Subject: Re: unable to read superblock ?
Date: Wed, 11 Jun 2003 10:12:38 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3.0.6.32.20030611101238.00a8f700@athen>
References: <004801c32e8b$1dac5170$4300a8c0@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <004801c32e8b$1dac5170$4300a8c0@moon>
To: Donghui Wen <dhwen@protegonetworks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello!
Maybe you created the file system before creating the md device?
Regards
Alfred


At 06:29 09.06.03 -0700, Donghui Wen wrote:
>Hi, I have a machine setup as software-raid + ext3 + redhat ,
>but this morning, it seems the file system crash. here is
>the booting message, anyone has any idea how to fix it.
>
>Thanks!
>
>Donghui
>
>----------------------------------------------------------------------------
>------
>md: adding sda1
>md: created md2
>md: using <sdb1> <sda1>
>md: md2: raid array is not clean -- starting bacground reconstruction
>RAID level 1 does not need chunck size. Continuing anyway.
>md2: max total readahead window set to 124k
>
>raid1: device sdb1 operational as mirror1
>raid1: device sda1 operational as mirror 0
>raid1: raid set md2 mot clean, reconstructing mirror
>raid1: raid set md2 active with 2 out of 2 mirrors
>md: updating md2 RAID superblock device
>.
>.
>md: autorun DONE
>mounting root filesystem
>EXT3-fs: unable to read super block
>mount: error 22 mounting ext3
>pivotrot: oivot_root(/sysrot,/sysrot/initrd) failed :2
>freing unused kernal memory: 244k fred
>kernal panic: no init found. Try passing init= option to kernal
>
>-----------------------------------------------------------
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

