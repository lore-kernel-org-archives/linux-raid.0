From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Howto avoid full re-sync
Date: Wed, 12 Sep 2012 14:28:42 +0100
Message-ID: <50508E0A.7090309@anonymous.org.uk>
References: <50497AE6.2010005@websitemanagers.com.au> <81BAA7A8-B1C3-49A1-A600-A9D9D8279E30@bj-ig.de> <504D223A.6020707@websitemanagers.com.au> <C0796F33-32E4-4F28-B6FB-469AF438C545@bj-ig.de> <50508582.3070501@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50508582.3070501@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/09/2012 13:52, Adam Goryachev wrote:
> On 11/09/12 00:12, Ralf M=FCller wrote:
>> Besides all the stuff about fix your server, a raid is not a backup =
and you risk your data - simply add a write intent bitmap:
>>
>> mdadm /dev/md2 --grow --bitmap=3Dinternal
> I've added this across a number of my systems now, and it seems to wo=
rk
> really well (Thank You), especially one system which has a RAID1 with=
 an
> external USB drive + internal drive which normally take over 2 days f=
or
> a full resync.

It may also be worth reading up on --write-mostly for your external USB=
=20
drive, particularly if your workload tends to be single long streaming=20
reads rather than lots of small parallel ones.

> Can you suggest if there is any dis-advantage to using the bitmap (ma=
ybe
> write performance will suffer), or disk space is reduced, or ....
>
> While I can see the benefits, I'm just wondering if it might be too g=
ood
> to be true, or what I am missing....
>
> Thanks again for your assistance.

Yes, write performance suffers, especially if you have a small bitmap=20
chunk size, and the default is as small as possible for the array. See=20
`mdadm -X /dev/sdX` on one of the components of your array for what the=
=20
default was calculated to be for your array, and read the --bitmap-chun=
k=20
section of `man mdadm` for a description of bitmap chunk size=20
considerations. I found a bitmap chunk of 128MB (131072KB) kept write=20
perfomance very near no-bitmap speeds (both MB/s and IOPS) but kept=20
resync times fast (a few seconds).

I'm not sure, but you may have to remove the bitmap (--grow=20
--bitmap=3Dnone) before re-adding one with a different chunk size (e.g.=
=20
--grow --bitmap=3Dinternal --bitmap-chunk=3D131072).

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
