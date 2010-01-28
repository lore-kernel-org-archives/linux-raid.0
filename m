From: Carlos Williams <carloswill@gmail.com>
Subject: Re: How To Grow Using 'mdadm' Utility
Date: Thu, 28 Jan 2010 10:13:53 -0500
Message-ID: <d80f793f1001280713j5b0ee689m1c4c455403c64928@mail.gmail.com>
References: <d80f793f1001271056i1127fbcege5b4dd4a3927576@mail.gmail.com>
	 <1264634977.1928.13.camel@test.apertos.eu>
	 <d80f793f1001280658k487be15emc0a6d23c9d013957@mail.gmail.com>
	 <1264691314.1928.27.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264691314.1928.27.camel@test.apertos.eu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010/1/28 Micha=C5=82 Sawicz <michal@sawicz.net>:
> You need to 'fsck -f' first to verify that the filesystem is fine.

I get a stern warning that because /dev/md0 is my / (root) file
system, I can cause serious damage performing this task:

[root@tuna ~]# fsck -f
fsck from util-linux-ng 2.17
e2fsck 1.41.9 (22-Aug-2009)
/dev/md0 is mounted.

WARNING!!!  Running e2fsck on a mounted filesystem may cause
SEVERE filesystem damage.

Do you really want to continue (y/n)?

*****************************************

Should I ignore the warning and proceed?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
