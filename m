From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: partitions
Date: Fri, 28 Jan 2011 22:40:39 -0500
Message-ID: <4D438C37.3040008@cfl.rr.com>
References: <AANLkTimGHtECH2oFdcWWmjXjzrFeRmDsXhfwg4FMR2a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimGHtECH2oFdcWWmjXjzrFeRmDsXhfwg4FMR2a8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It already is.

On 01/28/2011 04:24 PM, Roberto Spadim wrote:
> hi guys, could we implement raid partitions?
> for example:
> mdadm --create /dev/md0 --level=3D1 --devices /dev/sda /dev/sdb
> fdisk /dev/md0
> create pratition 1,2,3,4
>
> mkfs.ext4 /dev/md0p1
> mkfs.ext4 /dev/md0p2
> mkfs.ext4 /dev/md0p3
> mkfs.ext4 /dev/md0p4
>
> ?? any idea? could we implement it?
> there=B4s a TODO list for linux software raid?
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
