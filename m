From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Thu, 17 Feb 2011 15:10:32 +0000
Message-ID: <AANLkTikLWmC1u3rMFktwULgSPh-zL+D-xgcyogcJfqnP@mail.gmail.com>
References: <4D540F6C.6050904@gmail.com>
	<20110215155315.55d35b8e@notabene.brown>
	<4D5A92F3.1090004@turmel.org>
	<4D5ACE4B.9040309@gmail.com>
	<4D5AD613.3040402@turmel.org>
	<20110216004524.67abe977@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110216004524.67abe977@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

proxmox:~# dpkg -S blkid
libblkid1: /lib/libblkid.so.1.0
libblkid1: /lib/libblkid.so.1
libblkid1: /usr/share/doc/libblkid1/changelog.Debian.gz
libblkid1: /usr/share/doc/libblkid1/copyright
libblkid1: /usr/share/doc/libblkid1
e2fsprogs-dbg: /usr/lib/debug/sbin/blkid

proxmox:~# apt-get install e2fsprogs-dbg
Reading package lists... Done
Building dependency tree
Reading state information... Done
e2fsprogs-dbg is already the newest version.
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.


I still can't blkid installed, even though I have e2fsprogs-dbg install=
ed...

On 15 February 2011 19:45, Roman Mamedov <rm@romanrm.ru> wrote:
> On Tue, 15 Feb 2011 14:37:55 -0500
> Phil Turmel <philip@turmel.org> wrote:
>
>> > For some reason blkid doesn't exist on my machine even though I ha=
ve
>> > e2fs-utils installed. =A0V weird.
>
> Weird is that you think it is somehow a "e2fs-utils" program.
>
> dpkg -S blkid
> ...
> util-linux: /sbin/blkid
> ...
>
>>
>> FWIW, on my VPS running Ubuntu Server 10.10, the blkid executable is=
 part of
>> util-linux, and installed in /sbin. =A0You might need to re-install =
it.
>
> --
> With respect,
> Roman
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
