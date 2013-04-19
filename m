From: Tommy Apel <tommyapeldk@gmail.com>
Subject: Re: RAID50 boot problems
Date: Fri, 19 Apr 2013 12:42:52 +0200
Message-ID: <CAGA4a+FucP9SG5NDc079gD06G0vgS_PK3eCiiL2Lvx3sMC1U_g@mail.gmail.com>
References: <CAGqvA+sui=5R7+agbrJgHTQpm+1e9PVZ_MskjO3RTWq+LcAdnQ@mail.gmail.com>
	<16868321.4.1366367759598.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16868321.4.1366367759598.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Alexander Zvyagin <zvyagin.alexander@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The thing is that in order for this to work you need to have the
stripe scanned after the two 5s are created, I seem to recall that if
you put the stripe last in your mdadm.conf it will come up after the
5s


/Tommy

2013/4/19 Roy Sigurd Karlsbakk <roy@karlsbakk.net>:
> ----- Opprinnelig melding -----
>> Hi,
>>
>> I have almost working RAID50 (two RAID5 forms RAID0) in my
>> Linux-mint13. When booting the system always ends up in initramfs
>> shell, saying it cannot find the "root". When I type "cat
>> /proc/mdstat" I see that both RAID5 are available, but they did not
>> form RAID0. So I do "mdadm -A --scan" to finish the raid creation.
>> After that I can exit the initramfs shell and system finishes bootin=
g
>> (and works later) without any problems. Of course initramfs image is
>> in sync with root (/etc/mdadm/mdadm.conf file is the same in initram=
fs
>> and rootfs).
>> This is what my system is using:
>> kernel 3.5.0-26-generic
>> mdadm - v3.2.5 - 18th May 2012
>>
>> To summarize, I have RAID50 which _almost_ works. It just needs to b=
e
>> pushed/kicked during the boot. Could you advise my how can I
>> automatize the process, so I do not need to type "mdadm -A
>> --scan;exit" every time I switch on my computer?
>
> Interesting=E2=80=A6 I have an ubuntu 13.04 VM for just raid testing,=
 and I tried this configuration. I created two RAID-5s here and then a =
RAID-0 on top of those. I yet haven't put a filesystem on it. I just wa=
nted to see if I could reproduce your issue, and I can.
>
> It seems what happens is it only runs an initial scan, and then just =
finding the raids on physical (or otherwise) disks. In my case, md9 won=
't be available before md0 and md1 are started. I solved this by adding=
 a line to /etc/rc.local
>
> # If using nested MD, such as RAID5+0, another scan is needed
> mdadm --assemble --scan
>
> See below for full logs.
>
> roy
>
> root@raidtest:~# mdadm --detail --scan >> /etc/mdadm/mdadm.conf
> (edit mdadm.conf to remove old entries)
> root@raidtest:~# update-initramfs -u
> update-initramfs: Generating /boot/initrd.img-3.8.0-18-generic
> root@raidtest:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4] [raid10]
> md9 : active raid0 md0[0] md1[1]
>       4191232 blocks super 1.2 512k chunks
>
> md1 : active raid5 vde[0] vdg[3] vdf[1]
>       2096000 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] =
[UUU]
>
> md0 : active raid5 vdd[3] vdc[1] vdb[0]
>       2096000 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] =
[UUU]
>
> unused devices: <none>
>
> root@raidtest:~# reboot
> ...
> root@raidtest:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4] [raid10]
> md0 : active raid5 vdd[3] vdc[1] vdb[0]
>       2096000 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] =
[UUU]
>
> md1 : active raid5 vdg[3] vde[0] vdf[1]
>       2096000 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] =
[UUU]
>
> unused devices: <none>
> root@raidtest:~#
>
> --
> Vennlige hilsener / Best regards
>
> roy
> --
> Roy Sigurd Karlsbakk
> (+47) 98013356
> roy@karlsbakk.net
> http://blogg.karlsbakk.net/
> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
> --
> I all pedagogikk er det essensielt at pensum presenteres intelligibel=
t. Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=
=A5 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste t=
ilfeller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
