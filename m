From: Hari Subramanian <hari@vmware.com>
Subject: RE: Adaptive throttling for RAID1 background resync
Date: Fri, 18 Mar 2011 13:31:19 -0700
Message-ID: <10FC03A59E498D4A90A45E4A105AD3ED02EE70F540@EXCH-MBX-2.vmware.com>
References: <201103181549.20835.xavier@alternatif.org>
	<10FC03A59E498D4A90A45E4A105AD3ED02EE70F539@EXCH-MBX-2.vmware.com>
 <AANLkTimGL7kDBWSkVeDZSbc-JvnZmds-5a7UBHcv0iar@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimGL7kDBWSkVeDZSbc-JvnZmds-5a7UBHcv0iar@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Roberto, My use case involves both foreground and background resyncs ha=
ppening at the same time. So, by throttling it at the block or IO queue=
s, I would be limiting my throughout for foreground IOs as well which i=
s undesirable.

~ Hari

-----Original Message-----
=46rom: rspadim@gmail.com [mailto:rspadim@gmail.com] On Behalf Of Rober=
to Spadim
Sent: Friday, March 18, 2011 4:29 PM
To: Hari Subramanian
Cc: linux-raid@vger.kernel.org
Subject: Re: Adaptive throttling for RAID1 background resync

maybe this could be better solved at queue linux kernel area... at
elevators or block devices

2011/3/18 Hari Subramanian <hari@vmware.com>:
> I am hitting an issue when performing RAID1 resync from a replica hos=
ted on a fast disk to one on a slow disk. When resync throughput is set=
 at 20Mbps min and 200Mbps max and we have enough data to resync, I see=
 the kernel running out of memory quickly (within a minute). From the c=
rash dumps, I see that a whole lot (12,000+) of biovec-64s that are act=
ive on the slab cache.
>
> Our guess is that MD is allowing data to be read from the fast disk a=
t a frequency much higher than what the slow disk is able to write to. =
This continues for a long time (> 1 minute) in an unbounded fashion res=
ulting in buildup of IOs that are waiting to be written to the disk. Th=
is eventually causes the machine to panic (we have panic on OOM selecte=
d)
>
> From reading the MD and RAID1 resync code, I don't see anything that =
would prevent something like this from happening. So, we would like to =
implement something to this effect that adaptively throttles the backgr=
ound resync.
>
> Can someone confirm or deny these claims and also the need for a new =
solution. Maybe I'm missing something that already exists that would gi=
ve me the adaptive throttling. We cannot make do with the static thrott=
ling (sync_speed_max and min) since that would be too difficult to get =
right for varying IO throughputs form the different RAID1 replicas.
>
> Thanks
> ~ Hari
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
