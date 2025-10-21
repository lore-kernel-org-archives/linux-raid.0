Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2774C16CD33
	for <linux-raid@vger.kernel.org>; Tue, 21 Oct 2025 00:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761006835; cv=none; b=W1maOi5FOC9T7FWlKZ50L6vHO3AQVNxGLTcrHqKVCAUc24xiNRe03fCsw+mnJ8hbme7In15bgUS6LzLQckswsrqJiy1TlHGTWzkBj9DE+ts2pQMQGMwY3ip290ljMCzDVMK503prtbydh/ikix8N+SK92E9eQDeut1T7pn4Dc9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761006835; c=relaxed/simple;
	bh=i+lyXF6WiH6BPn86wE1I8TbLqj2uYj4YRWlKVcdcFW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eZPvibKJk2WrHyTR4NjJfWdhsM5j+7rzR7CvPWKKdoCymcAioj45Xn8JXmAqijCnq3lxNtHEOLnSJFTnWlejOxbOwySeeKKIbcXxcxynLsodol7XJvoXPlG0fJ/UgLCwSnMlZRS55sbG3kz6atk/zvsImjRsS4DBkhcLSEQnS18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B/njOSHN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B/njOSHN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761006832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SRl7F6O546yzswxRliWjBdxg0Vz2Tp8/9UrJy0fPL9A=;
	b=B/njOSHN4wJfgFVF0DBgrv6k2RJKgGt+h64WyaQfSwDZMPEHAbXSbcfAoItWaZRcdzmc9a
	0YfaKwIXgCndwVRZ7dbgUIVy8n3nrlMv0OaIzuJvjMtYspS23vYIObtGCW91TcFYHR3+y4
	eHMOzqlL2cJKmSdIMXNpZUMml3FuHBY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-zO3gJfosPleE8bMoyFGnOw-1; Mon, 20 Oct 2025 20:33:50 -0400
X-MC-Unique: zO3gJfosPleE8bMoyFGnOw-1
X-Mimecast-MFC-AGG-ID: zO3gJfosPleE8bMoyFGnOw_1761006828
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-36c983e4c21so30999831fa.1
        for <linux-raid@vger.kernel.org>; Mon, 20 Oct 2025 17:33:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761006828; x=1761611628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SRl7F6O546yzswxRliWjBdxg0Vz2Tp8/9UrJy0fPL9A=;
        b=KNk6A9bsma4R2SotdTjpyi7OZ9qTAI1x0iFOQNmqyWEta6QQlBvKWjinbnxMLINM3N
         2UzSl35T1Gm7VIt5eF8XHrnPGBrzjDPl2uIzLzwxutla4rD0U9yuKgtz780F7PGGUFEQ
         ma1usb+pVS3/rFOgwb0lsZA9E5xIr0h69kypiWA4XEpP8X4PJdss+8ZJzGRUbR49nfct
         maWJk1OI/vZMs98T4BYCYbfLTY8QHDjaSyXlSNjFUSOmgoZTz0nibYfDw4SGDoVTzz0S
         ztt2SKPUz8d1Q+HSpaxH9YweS7yta4XSGeu4XUKlkzIiIXLcC5EUwcJJPktp3Qq5tHht
         O2QA==
X-Gm-Message-State: AOJu0Yyhzk2z9E8YJFhkrGHc5X47XcJflyCGWATQNALrhwIO2njYcqlQ
	EMml9t93BdZV2Y3nwx9Qgk4CqdqhxmfnHVduc7JtgT0P2hyqfSn+AwhMpHDvYbM+U5DKL/+b3qe
	+UWofY3IdGRoHkIUtooe0b/CjgNLjvFmHJkMKrhSUxFwRPua9pkwddNsGQ/kAmE6iMLCspgQujP
	jDTv6MIl9rbJxDOtFYZv0tEBbwU550SPaoGZDXuA==
X-Gm-Gg: ASbGncsoN8kug1T80vax5tTx3cgdNIZhsf8nGTSHLJurgLtvZ5Uzs20+XXaavOWjQwh
	qPjDk8g01fozOpKJ5WC7ra2CGp3fauYj/wuIya96XxNl4Kt6ls1OgREXimWmtVmcWx1ovSbrrY9
	EXVXOgx6NAkip8LXLdCw1yEOWPDe2Rl+kLu6abPqAQyzw9rrgIYpwsTb/D
X-Received: by 2002:a05:651c:211c:b0:365:6b40:8656 with SMTP id 38308e7fff4ca-37797948f9bmr42026171fa.35.1761006828221;
        Mon, 20 Oct 2025 17:33:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbHsgcOJ3vyUKdn40nC1RKvaIUDOQWOgQQ7ZTGulwbgePTQdblnr1eYL4um+Pt2gWGK5yi9mLXzmb4OkiiQ4o=
X-Received: by 2002:a05:651c:211c:b0:365:6b40:8656 with SMTP id
 38308e7fff4ca-37797948f9bmr42026101fa.35.1761006827704; Mon, 20 Oct 2025
 17:33:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <608328b7-9dfe-4edd-afd5-68366fb845bc@gmail.com>
 <CALTww2_0rAvqc=C0zAP7pdGT-V7-ypMV5Rc=dk4iKS4VkAVE7Q@mail.gmail.com> <b0db39dc-f261-4bc3-aac3-e983150ba8c7@gmail.com>
In-Reply-To: <b0db39dc-f261-4bc3-aac3-e983150ba8c7@gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 21 Oct 2025 08:33:35 +0800
X-Gm-Features: AS18NWBlJczQ7M34LDqNoEed8vje_ZjzDySkWhgZx8HBzvKJQq853hLx5PxftyY
Message-ID: <CALTww29Cn3nZ_+XDqkZpikdKw9w5xMYWjQpWMtfZW9a0fw_jNg@mail.gmail.com>
Subject: Re: Unable to set group_thread_cnt using mdadm.conf
To: Franco Martelli <martellif67@gmail.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, mtkaczyk@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 3:22=E2=80=AFAM Franco Martelli <martellif67@gmail.=
com> wrote:
>
> On 20/10/25 at 16:40, Xiao Ni wrote:
> > On Fri, Oct 17, 2025 at 10:07=E2=80=AFPM Franco Martelli <martellif67@g=
mail.com> wrote:
> >>
> >> Hello,
> >>
> >> I've a RAID5 array on Debian 13:
> >>
> >> ~$ cat /proc/mdstat
> >> Personalities : [raid6] [raid5] [raid4] [linear] [raid0] [raid1] [raid=
10]
> >> md0 : active raid5 sda1[0] sdc1[2] sdd1[3](S) sdb1[1]
> >>         1953258496 blocks super 1.2 level 5, 512k chunk, algorithm 2
> >> [3/3] [UUU]
> >>
> >> unused devices: <none>
> >>
> >> ~# mdadm --version
> >> mdadm - v4.4 - 2024-11-07 - Debian 4.4-11
> >>
> >> the issue is that I can't set group_thread_cnt if I use the syntax
> >> described in mdadm.conf(5) man-page:
> >>
> >> =E2=80=A6
> >> SYSFS name=3D/dev/md/raid5 group_thread_cnt=3D4 sync_speed_max=3D10000=
00
> >> SYSFS uuid=3Dbead5eb6:31c17a27:da120ba2:7dfda40d group_thread_cnt=3D4
> >> sync_speed_max=3D1000000
> >>
> >> my "mdadm.conf" is:
> >>
> >> ~$ grep -v '^#' /etc/mdadm/mdadm.conf
> >>
> >>
> >> HOMEHOST <system>
> >>
> >> MAILADDR root
> >>
> >> ARRAY /dev/md/0  metadata=3D1.2 UUID=3D8bdf78b9:4cad434c:3a30392d:8463=
c7e0
> >>      spares=3D1
> >>
> >>
> >> SYSFS name=3D/dev/md/0 group_thread_cnt=3D8
> >> SYSFS uuid=3D8bdf78b9:4cad434c:3a30392d:8463c7e0 sync_speed_max=3D1000=
000
> >>
> >>
> >> after I makes changes to the file "mdadm.conf" I rebuild the initramfs
> >> image file and reboot. The thing that seems strange to me is that the
> >> other item I set (sync_speed_max) is changed accordingly, only
> >> "group_thread_cnt" fails to set (it's always =3D=3D0):
> >>
> >> ~$ cat /sys/block/md0/md/group_thread_cnt
> >> 0
> >> ~$ cat /sys/block/md0/md/sync_speed_max
> >> 1000000 (system)
> >>
> >> Why "sync_speed_max" is set while "group_thread_cnt" it is not? Any cl=
ue?
> >
> > Hi Franco
> >
> > The sync_speed_max should not be set too. Because it still shows
> > "system" rather than "local". I tried in my environment. It indeed has
> > a problem if you specify uuid in conf file to set sysfs value. This is
> > my conf:
>
> Hi Xiao,
>
> Yes, it's correct, I cannot set sync_speed_max maybe it reflects the
> setting of:
>
> ~$ cat /etc/sysctl.d/md0.conf
> dev.raid.speed_limit_max =3D 1000000
>
> I don't know, I guess=E2=80=A6
>
> >
> > cat /etc/mdadm.conf
> > ARRAY /dev/md/0  metadata=3D1.2 UUID=3D689642b7:fa1e5cf2:82c6c527:ca377=
16f
> > SYSFS name=3D/dev/md/0 sync_speed_max=3D5000 group_thread_cnt=3D8
> >
> > After assembling by command `mdadm -As`:
> > [root@ mdadm]# cat /sys/block/md0/md/group_thread_cnt
> > 8
> > [root@ mdadm]# cat /sys/block/md0/md/sync_speed_max
> > 5000 (local)
> >
> > If I specify uuid in the second line of the conf file, it can't work.
> > Because the uuid read from the device doesn't match with the conf
> > file. It should be the problem of big-endian and little-endian. I'm
> > looking at this problem.
> >
> > But in your conf, the group thread cnt should be set successfully.
> > What's your command to assemble the array? Can you stop the array and
> > assemble it after boot.
>
> my mdadm.conf now is:
>
> ~$ grep -v '^#' /etc/mdadm/mdadm.conf
>
>
> HOMEHOST <system>
>
> MAILADDR root
>
> ARRAY /dev/md/0  metadata=3D1.2 UUID=3D8bdf78b9:4cad434c:3a30392d:8463c7e=
0
>     spares=3D1
>
>
> SYSFS name=3D/dev/md/0 sync_speed_max=3D5000000 group_thread_cnt=3D8
>
>
> I rebuild the initramfs image file:
>
> ~# update-initramfs -uk all
> update-initramfs: Generating /boot/initrd.img-6.12.48+deb13-amd64
> update-initramfs: Generating /boot/initrd.img-6.12.48
>
>
> mdadm files in the initramfs file are:
>
> ~# lsinitramfs /boot/initrd.img-6.12.48 |grep mdadm
> etc/mdadm
> etc/mdadm/mdadm.conf
> etc/modprobe.d/mdadm.conf
> scripts/local-block/mdadm
> scripts/local-bottom/mdadm
> usr/sbin/mdadm
>
>
> and then I rebooted the system, I cannot set group_thread_cnt:
>
> ~$ cat /sys/block/md0/md/sync_speed_max
> 1000000 (system)
> ~$ cat /sys/block/md0/md/group_thread_cnt
> 0
>
>
> I cannot stop the array since my root filesystem resides on it. The
> command that Debian 13 Trixie uses to assemble the array is:
>
> ~$ ps -wax|grep mdadm
>      543 ?        Ss     0:00 /usr/sbin/mdadm --monitor --scan
>
>
> FYI the topology of the storage on my system is:
>
> PCI [ahci] 00:11.0 SATA controller: Advanced Micro Devices, Inc.
> [AMD/ATI] SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40)
> =E2=94=9Cscsi 0:0:0:0 ATA      ST1000DM003-1CH1 {Z1D93ZHJ}
> =E2=94=82=E2=94=94sda 931.51g [8:0] Partitioned (dos)
> =E2=94=82 =E2=94=94sda1 931.51g [8:1] MD raid5 (0/3) (w/ sdd1,sdc1,sdb1) =
in_sync
> 'itek:0' {8bdf78b9-4cad-434c-3a30-392d8463c7e0}
> =E2=94=82  =E2=94=94md0 1.82t [9:0] MD v1.2 raid5 (3) clean, 512k Chunk
> {8bdf78b9:-4cad-43:4c-3a30-:392d8463c7e0}
> =E2=94=82   =E2=94=82               PV LVM2_member 1,82t used, 0 free
> {6HMlpl-ZLKi-4JOP-DU9i-aiZh-7IoH-Dd1Hoy}
> =E2=94=82   =E2=94=94VG ld0 1,82t 0 free {BUUpNE-w0IY-Ut2I-OmiZ-err7-zXLX=
-F0VmjU}
> =E2=94=82    =E2=94=9Cdm-6 1.67t [253:6] LV data ext4 {29ed4bd3-f546-4781=
-988c-39f853276492}
> =E2=94=82    =E2=94=9Cdm-1 27.94g [253:1] LV lv1 ext4 {fa251689-956d-4a3c=
-b60c-0ab92ac51488}
> =E2=94=82    =E2=94=9Cdm-2 27.94g [253:2] LV lv2 ext4 {4baf8453-6525-4b72=
-aade-25de240ac4f4}
> =E2=94=82    =E2=94=9Cdm-3 27.94g [253:3] LV lv3 ext4 {9ad082fd-d9fb-4ddc=
-b3e8-a39753480319}
> =E2=94=82    =E2=94=82=E2=94=94Mounted as /dev/mapper/ld0-lv3 @ /
> =E2=94=82    =E2=94=9Cdm-4 27.94g [253:4] LV lv4 ext4 {6cbd93ab-0def-4a56=
-8270-176c66588c45}
> =E2=94=82    =E2=94=9Cdm-5 27.94g [253:5] LV lv5 ext4 {665d8145-786a-461b=
-a4c1-7155156c40be}
> =E2=94=82    =E2=94=94dm-0 9.31g [253:0] LV swap swap {f3859a53-eb70-4a7b=
-ac94-93433b72a723}
> =E2=94=9Cscsi 1:0:0:0 ATA      ST1000DM003-1CH1 {Z1D8ZJ1H}
> =E2=94=82=E2=94=94sdb 931.51g [8:16] Partitioned (dos)
> =E2=94=82 =E2=94=94sdb1 931.51g [8:17] MD raid5 (1/3) (w/ sdd1,sdc1,sda1)=
 in_sync
> 'itek:0' {8bdf78b9-4cad-434c-3a30-392d8463c7e0}
> =E2=94=82  =E2=94=94md0 1.82t [9:0] MD v1.2 raid5 (3) clean, 512k Chunk
> {8bdf78b9:-4cad-43:4c-3a30-:392d8463c7e0}
> =E2=94=82                   PV LVM2_member 1,82t used, 0 free
> {6HMlpl-ZLKi-4JOP-DU9i-aiZh-7IoH-Dd1Hoy}
> =E2=94=9Cscsi 2:0:0:0 ATA      ST1000DM003-1CH1 {Z1D94DF3}
> =E2=94=82=E2=94=94sdc 931.51g [8:32] Partitioned (dos)
> =E2=94=82 =E2=94=94sdc1 931.51g [8:33] MD raid5 (2/3) (w/ sdd1,sdb1,sda1)=
 in_sync
> 'itek:0' {8bdf78b9-4cad-434c-3a30-392d8463c7e0}
> =E2=94=82  =E2=94=94md0 1.82t [9:0] MD v1.2 raid5 (3) clean, 512k Chunk
> {8bdf78b9:-4cad-43:4c-3a30-:392d8463c7e0}
> =E2=94=82                   PV LVM2_member 1,82t used, 0 free
> {6HMlpl-ZLKi-4JOP-DU9i-aiZh-7IoH-Dd1Hoy}
> =E2=94=9Cscsi 3:0:0:0 ATA      ST1000DM003-1CH1 {Z1D94DF5}
> =E2=94=82=E2=94=94sdd 931.51g [8:48] Partitioned (dos)
> =E2=94=82 =E2=94=94sdd1 931.51g [8:49] MD raid5 (none/3) (w/ sdc1,sdb1,sd=
a1) spare
> 'itek:0' {8bdf78b9-4cad-434c-3a30-392d8463c7e0}
> =E2=94=82  =E2=94=94md0 1.82t [9:0] MD v1.2 raid5 (3) clean, 512k Chunk
> {8bdf78b9:-4cad-43:4c-3a30-:392d8463c7e0}
> =E2=94=82                   PV LVM2_member 1,82t used, 0 free
> {6HMlpl-ZLKi-4JOP-DU9i-aiZh-7IoH-Dd1Hoy}
> =E2=94=94scsi 4:0:0:0 ASUS     BW-16D1HT        {K9GDBBA5248}
>   =E2=94=94sr0 1.00g [11:0] Empty/Unknown
> PCI [ahci] 04:00.0 SATA controller: ASMedia Technology Inc. ASM1062
> Serial ATA Controller (rev 01)
> =E2=94=94scsi 5:x:x:x [Empty]

I c, thanks for the detailed information. The array is assembled
during boot by udev rule which runs `mdadm -I` command. I looked at
the codes. mdadm doesn't support setting sysfs values through this
way. Maybe the author missed this part. He was only concerned about
imsm array.

In my environment:
mdadm -Ss
cat /etc/mdadm.conf
ARRAY /dev/md/0  metadata=3D1.2 UUID=3D689642b7:fa1e5cf2:82c6c527:ca37716f
SYSFS name=3D/dev/md/0 sync_speed_max=3D5000 group_thread_cnt=3D8
mdadm -I /dev/loop0
mdadm -I /dev/loop1
mdadm -I /dev/loop2
[root@ mdadm]# cat /sys/block/md0/md/group_thread_cnt
0
[root@ mdadm]# cat /sys/block/md0/md/sync_speed_max
200000 (system)
So it indeed doesn't work now. I'll fix this. And I've filed a new
issue at https://github.com/md-raid-utilities/mdadm/issues/208.

Regards
Xiao
>
>
> Thank you again, kind regards.
> --
> Franco Martelli
>

