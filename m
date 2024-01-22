Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D6F482ED
	for <linux-raid@vger.kernel.org>; Mon, 22 Jan 2024 21:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.118.73.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705960532; cv=none; b=sTfcuowBRA1twXc/6FFSc808xNvLWuHWBV52LAZaDRVTwGPurjZ945AIqYlQAb6krrbkbIC6u83gg6M28cqtaANCL47eIyXNOjiv8uGh7Fc5l1RpUd4NJvGmCN94Y/f3HirbFNs+88W55vWGiEdVGYjEI998eegCFOv7yR+5NmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705960532; c=relaxed/simple;
	bh=2RNJgyjUPFR5dRPVzRqui/TTjdGuwmVb9v8ayQtEe30=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hDZfm7Vt8oyu+kS5QRmH/I932wlXkM1ihEs4De0JuYNoUO7JL9Wop4gXHVM3dksIEGYitDWlRDTVl0v/gGTAAirLn1TI3GucO6vktqAMWt/fRPJbKz1a0B4d3nDcAKOahuVV38iVTGx0AXLb/A9CjU1KoHVoaRreHyEHDofcqGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thelounge.net; spf=pass smtp.mailfrom=thelounge.net; arc=none smtp.client-ip=91.118.73.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thelounge.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelounge.net
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: h.reindl@thelounge.net)
	by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4TJkC63cyCzXsT;
	Mon, 22 Jan 2024 22:39:41 +0100 (CET)
Message-ID: <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net>
Date: Mon, 22 Jan 2024 22:39:41 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Requesting help recovering my array
Content-Language: en-US
To: RJ Marquette <rjm1@yahoo.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com>
 <432300551.863689.1705953121879@mail.yahoo.com>
From: Reindl Harald <h.reindl@thelounge.net>
Autocrypt: addr=h.reindl@thelounge.net; keydata=
 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
 K4rYsjPimkSIVdrNM//wVKdCTbO+
Organization: the lounge interactive design
In-Reply-To: <432300551.863689.1705953121879@mail.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

a ton of "mdadm --examine" outputs but i can't see a "cat /proc/mdstat"

/dev/sdX is completly irrelevant when it comes to raid - you can even 
connect a random disk via USB adapter without a change from the view of 
the array

Am 22.01.24 um 20:52 schrieb RJ Marquette:
> Hi, all.  I have a Raid5 array with 5 disks in use and a 6th in reserve that I built using 3TB drives in 2019.  It has been running fine since, not even a single drive failure.  The system also has a 7th hard drive for OS, home directory, etc.  The motherboard had four SATA ports, so I added an adapter card that has 4 more ports, with three drives connected to it.  The server runs Debian that I keep relatively current.
> 
> Yesterday, I swapped a newer motherboard into the computer (upgraded my desktop and moved the guts to my server).  I never disconnected the cables from the adapter card (whew, I think), so I know which four drives were connected to the motherboard.  Unfortunately I didn't really note how they were hooked to the motherboard (SATA1-4 ports).  Didn't even think it would be an issue.  I'm reasonably confident the array drives on the motherboard were sda-sdc, but I'm not certain.
> 
> Now I can't get the array to come up.  I'm reasonably certain I haven't done anything to write to the drives - but mdadm will not assemble the drives (I have not tried to force it).  I'm not entirely sure what's up and would really appreciate any help.
> 
> I've tried various incantations of mdadm --assemble --scan, with no luck.  I've seen the posts about certain motherboards that can mess up the drives, and I'm hoping I'm not in that boat.  The "new" motherboard is a Asus Z96-K/CSM.
> 
> I assume using --force is in my future...I see various pages that say use --force then check it, but will that damage it if I'm wrong?  If not, how will I know it's correct?  Is the order of drives important with --force?  I see conflicting info on that.
> 
> I'm no expert but it looks like each drive has the mdadm superblock...so I'm not sure why it won't assemble.  Please help!
> 
> Thanks in advance.
> --RJ
> 
> root@jackie:~# uname -a
> Linux jackie 5.10.0-27-amd64 #1 SMP Debian 5.10.205-2 (2023-12-31) x86_64 GNU/Linux
> 
> root@jackie:~# mdadm --version
> mdadm - v4.1 - 2018-10-01
> 
> root@jackie:~# mdadm --examine /dev/sda
> /dev/sda:   MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> 
> root@jackie:~# mdadm --examine /dev/sda1
> mdadm: No md superblock detected on /dev/sda1.
> 
> root@jackie:~# mdadm --examine /dev/sdb
> /dev/sdb:   MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> 
> root@jackie:~# mdadm --examine /dev/sdb1
> mdadm: No md superblock detected on /dev/sdb1.
> 
> root@jackie:~# mdadm --examine /dev/sdc
> /dev/sdc:          Magic : a92b4efc        Version : 1.2
> Feature Map : 0x0
> Array UUID : 74a11272:9b233a5b:2506f763:27693ccc
> Name : jackie:0  (local to host jackie)
> Creation Time : Sat Dec  8 19:32:07 2018
> Raid Level : raid5
> Raid Devices : 5 Avail
> Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
> Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
> Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
> Data Offset : 262144 sectors
> Super Offset : 8 sectors
> Unused Space : before=261864 sectors, after=944 sectors
> State : clean
> Device UUID : a2b677bb:4004d8fb:a298a923:bab4df8a
> Update Time : Fri Jan 19 15:25:37 2024
> Bad Block Log : 512 entries available at offset 264 sectors
> Checksum : 2487f053 - correct
> Events : 5958
> Layout : left-symmetric
> Chunk Size : 512K
> Device Role : spare
> Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> root@jackie:~# mdadm --examine /dev/sdc1
> mdadm: cannot open /dev/sdc1: No such file or directory
> 
> root@jackie:~# mdadm --examine /dev/sde
> /dev/sde:   MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> 
> root@jackie:~# mdadm --examine /dev/sde1
> mdadm: No md superblock detected on /dev/sde1.
> 
> root@jackie:~# mdadm --examine /dev/sdf
> /dev/sdf:   MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> 
> root@jackie:~# mdadm --examine /dev/sdf1
> mdadm: No md superblock detected on /dev/sdf1.
> 
> root@jackie:~# mdadm --examine /dev/sdg
> /dev/sdg:   MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> 
> root@jackie:~# mdadm --examine /dev/sdg1
> mdadm: No md superblock detected on /dev/sdg1.
> 
> root@jackie:~# lsdrv
> PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 9 Series Chipset Family SATA Controller [AHCI Mode]
> ├scsi 0:0:0:0 ATA      ST3000VN007-2E41 {Z7317D1A}
> │└sda 2.73t [8:0] Partitioned (gpt)
> │ └sda1 2.73t [8:1] Empty/Unknown
> ├scsi 1:0:0:0 ATA      Hitachi HUS72403 {P8GSA1WR}
> │└sdb 2.73t [8:16] Partitioned (gpt)
> │ └sdb1 2.73t [8:17] Empty/Unknown
> ├scsi 2:0:0:0 ATA      Hitachi HUA72303 {MK0371YVGSZ9RA}
> │└sdc 2.73t [8:32] MD raid5 (5) inactive 'jackie:0' {74a11272-9b23-3a5b-2506-f76327693ccc}
> └scsi 3:0:0:0 ATA      ST32000542AS     {5XW110LY}
> └sdd 1.82t [8:48] Partitioned (dos)
> ├sdd1 23.28g [8:49] Partitioned (dos) {d94cc2c8-037a-49c5-8a1e-01bb47d78624}
> │└Mounted as /dev/sdd1 @ /
> ├sdd2 1.00k [8:50] Partitioned (dos)
> ├sdd5 9.31g [8:53] ext4 {6eb3b4d0-8c7f-4b06-a431-4c292d5bda86}
> │└Mounted as /dev/sdd5 @ /var
> ├sdd6 3.96g [8:54] swap {901cd56d-ef11-4866-824b-d9ec4ae6fe6e}
> ├sdd7 1.86g [8:55] ext4 {69ba0889-322b-4fc8-b9d3-a2d133c97e5e}
> │└Mounted as /dev/sdd7 @ /tmp
> └sdd8 1.78t [8:56] ext4 {4ed408d4-6b22-46e0-baed-2e0589ff41fb}
> └Mounted as /dev/sdd8 @ /home PCI [ahci]
> 
> 06:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9215 PCIe 2.0 x1 4-port SATA 6 Gb/s Controller (rev 11)
> ├scsi 6:0:0:0 ATA      Hitachi HUS72403 {P8G84LEP}
> │└sde 2.73t [8:64] Partitioned (gpt)
> │ └sde1 2.73t [8:65] Empty/Unknown
> ├scsi 7:0:0:0 ATA      ST3000VN007-2E41 {Z7317D46}
> │└sdf 2.73t [8:80] Partitioned (gpt)
> │ └sdf1 2.73t [8:81] Empty/Unknown
> └scsi 8:0:0:0 ATA      ST3000VN007-2E41 {Z7317JTX}
> └sdg 2.73t [8:96] Partitioned (gpt)
> └sdg1 2.73t [8:97] Empty/Unknown
> 
> root@jackie:~# cat /etc/mdadm/mdadm.conf
>   # This configuration was auto-generated on Wed, 27 Nov 2019 15:53:23 -0500 by mkconf
> ARRAY /dev/md0 metadata=1.2 spares=1 name=jackie:0 UUID=74a11272:9b233a5b:2506f763:27693cccr

