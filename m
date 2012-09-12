From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: Howto avoid full re-sync
Date: Wed, 12 Sep 2012 22:52:18 +1000
Message-ID: <50508582.3070501@websitemanagers.com.au>
References: <50497AE6.2010005@websitemanagers.com.au> <81BAA7A8-B1C3-49A1-A600-A9D9D8279E30@bj-ig.de> <504D223A.6020707@websitemanagers.com.au> <C0796F33-32E4-4F28-B6FB-469AF438C545@bj-ig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C0796F33-32E4-4F28-B6FB-469AF438C545@bj-ig.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/09/12 00:12, Ralf M=FCller wrote:
> Besides all the stuff about fix your server, a raid is not a backup a=
nd you risk your data - simply add a write intent bitmap:
>
> mdadm /dev/md2 --grow --bitmap=3Dinternal
I've added this across a number of my systems now, and it seems to work
really well (Thank You), especially one system which has a RAID1 with a=
n
external USB drive + internal drive which normally take over 2 days for
a full resync.

Can you suggest if there is any dis-advantage to using the bitmap (mayb=
e
write performance will suffer), or disk space is reduced, or ....

While I can see the benefits, I'm just wondering if it might be too goo=
d
to be true, or what I am missing....

Thanks again for your assistance.

Regards,
Adam

--=20
Adam Goryachev
Website Managers
Ph: +61 2 8304 0000                            adam@websitemanagers.com=
=2Eau
=46ax: +61 2 8304 0001                            www.websitemanagers.c=
om.au

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
