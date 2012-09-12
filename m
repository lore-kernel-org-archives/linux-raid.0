From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: make filesystem failed while the capacity of raid5 is big than 16TB
Date: Wed, 12 Sep 2012 15:32:10 +0800
Message-ID: <CA+res+T2Tuxy4vbe9czU9AAhp3-od3HLZRrYpPzyppeXK-CunQ@mail.gmail.com>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com>
Sender: linux-raid-owner@vger.kernel.org
To: vincent <hanguozhong@meganovo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You need to change to use bigger blocksize or switch to XFS.

Jack

2012/9/12 vincent <hanguozhong@meganovo.com>:
> Hi, everyone:
>         I am Vincent, I am writing to you to ask a question about how to
> make file system about my raid5.
>         I created a raid5 with 16 *2T disks, it was OK.
>         Then I used mk2fs to make file system for the raid5.
>         Unfortunately, it was failed.
>         The output was:
>         # mke2fs -t ext4 /dev/md126
>           mke2fs 1.41.12 (17-May-2010)
>           mke2fs: Size of device /dev/md126 too big to be expressed in 32
> bits
>           using a blocksize of 4096.
>         Is anyone had the same problem? Could you help me?
>         The version of my mdadm is 3.2.2, and the version of my kernel is
> 2.6.38
>         Thanks.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
