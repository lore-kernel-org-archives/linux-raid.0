From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: make filesystem failed while the capacity of raid5 is big than
 16TB
Date: Wed, 12 Sep 2012 07:37:55 +0000 (UTC)
Message-ID: <slrnk50euk.lql.chris@chris.onthe.net.au>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com>
Reply-To: chris@onthe.net.au
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-09-12, vincent <hanguozhong@meganovo.com> wrote:
> Hi, everyone:
>         I am Vincent, I am writing to you to ask a question about how=
 to
> make file system about my raid5.
>         I created a raid5 with 16 *2T disks, it was OK.
>         Then I used mk2fs to make file system for the raid5.
>         Unfortunately, it was failed.
>         The output was:
>         # mke2fs -t ext4 /dev/md126
>           mke2fs 1.41.12 (17-May-2010)
>           mke2fs: Size of device /dev/md126 too big to be expressed i=
n 32
> bits
>           using a blocksize of 4096.
>         Is anyone had the same problem? Could you help me?
>         The version of my mdadm is 3.2.2, and the version of my kerne=
l=C2=A0is
> 2.6.38

You need a newer mke2fs: file systems > 16 TB weren't supported until 1=
=2E42:

http://e2fsprogs.sourceforge.net/e2fsprogs-release.html#1.42

Chris

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
