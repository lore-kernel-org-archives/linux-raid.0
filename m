From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
Date: Tue, 20 Mar 2012 09:27:07 +0800
Message-ID: <CANejiEWeaF44Rbgt5jhf_bnafF4yoTTZAYsqoD2+greJ07c-_A@mail.gmail.com>
References: <20120316073213.656519005@fusionio.com>
	<alpine.LRH.2.02.1203181824590.24824@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1203181824590.24824@diagnostix.dwd.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk, vgoyal@redhat.com, martin.petersen@oracle.com
List-Id: linux-raid.ids

2012/3/20 Holger Kiehl <Holger.Kiehl@dwd.de>:
> Hello,
>
>
> On Fri, 16 Mar 2012, Shaohua Li wrote:
>
>> The patches add TRIM support for raid linear/0/1/10. I'll add TRIM s=
upport
>> for
>> raid 4/5/6 later. The implementation is pretty straightforward and
>> self-explained.
>>
>> v1->v2:
>> 1. fixed a checking issue
>> 2. dropped discard request plug and replace it with no discard mereg=
e,
>> because
>> current SCSI layer can't handle discard request merge.
>>
> Have tested TRIM patches on three different systems with the followin=
g
> hardware/ setup:
>
> =A0 1) root mounted on a raid1 over two SAS SSD's (200GB) and /home p=
artition
> =A0 =A0 =A0on a raid0 over a fusionio ioDrive Duo. Is very new and se=
en very
> =A0 =A0 =A0little usage.
>
> =A0 2) root and /home mounted on a raid0 over two Intel X25 Postville
> =A0 =A0 =A0(160GB) connected to a Intel P55 Express chipset. Has seen=
 very
> =A0 =A0 =A0heavy usage for approx. 2 years.
>
> =A0 3) root and /home mounted on a raid0 over three OCZ-VERTEX2 (120G=
B)
> =A0 =A0 =A0connected via ICH7 south bridge. Has seen mild usage for a=
pprox.
> =A0 =A0 =A01.5 years.
>
> Made the following observations when running my own benchmark which
> copies around a lot of small files and deletes them. The benchmark on
> all systems was always run only on the /home partition ie. on a raid0=
=2E
>
> For system 1) there is hardly any measurable differnce whether discar=
d
> is enabled or not (~29000 files per second).
>
> On system 2) the performance drops from 6500->3700 files per second,
> but under normal usage one does not notice any difference.
do you have the blktrace data when the benchmark is running, especially
when doing file deletion. I'd like to check the latency of discard in t=
his case.

> System 3) has problems during boot, it is so slow that some operation=
s
> receive a timeout during boot:
>
> =A0udevd[474]: timeout '/sbin/blkid -o udev -p /dev/md0'
> =A0udevd[474]: timeout: killing '/sbin/blkid -o udev -p /dev/md0' [86=
6]
> =A0systemd[1]: dev-md3.swap activation timed out. Stopping.
In this one, discard request is slow. And per SATA standard, discard re=
quest
can't be parallel, so only one request one time, which further slows it=
 down.

> Even removing discard does not help and the above errors happen durin=
g
> boot and booting takes a long time.
this doesn't make sense. If you don't mount with discard option, no
discard request
is issued.

Thanks,
Shaohua
