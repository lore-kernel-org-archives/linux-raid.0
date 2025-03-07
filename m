Received: from pasta.tip.net.au (pasta.tip.net.au [203.10.76.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90A01E502
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 00:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.10.76.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741307890; cv=none; b=TxeoyCXimcjqtkjMrDxbz9DnKPmLzYgJTS2bMrZeoX9nPDMhBRF75SGwSgO75q/wTK8AS8cfTBasF+EPEcrDg6JGy2ioJTPwT/dFoasb5zfuBJwqa6kM6yVlnvA+eFdg9BqZKDehNsxZCqHqk4WfDnKfDPLh3tMAH6sjTgEEnLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741307890; c=relaxed/simple;
	bh=7Ewh6GdYk/Z3yf1vJbbqDY1I+3TjfgAUB3Hj+AxCSeE=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=kWBm+9tYOEeMwzjc+rsFviyusqAbLuKBLnzW70/AQu3Bx/oYUqfx1/nazRx3faaxCrlqvwcxIFgG87fMse87JFyMVDc/81T2JLc8/nVzbRNHHWgK1ln5L1tg0Oli5CzV/SJ62x65KZZN2PNzek49DN9Pn7BwmC35ul7hrWlgp/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eyal.emu.id.au; spf=pass smtp.mailfrom=eyal.emu.id.au; arc=none smtp.client-ip=203.10.76.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eyal.emu.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eyal.emu.id.au
Received: from [192.168.2.7] (unknown [101.115.15.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailhost.tip.net.au (Postfix) with ESMTPSA id 4Z86cf2yd8z8tpF
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 11:29:54 +1100 (AEDT)
Message-ID: <0e2898c2-7d4a-47de-8d23-010cf2d8836b@eyal.emu.id.au>
Date: Fri, 7 Mar 2025 11:29:46 +1100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Linux-RAID <linux-raid@vger.kernel.org>
Reply-To: eyal@eyal.emu.id.au
Content-Language: en-US
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Need to understand error messages
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I am on fedora 40 with
	Linux e7.eyal.emu.id.au 6.13.5-100.fc40.x86_64 #1 SMP PREEMPT_DYNAMIC Thu Feb 27 15:10:07 UTC 2025 x86_64 GNU/Linux

It seems that there was an issue with a disk [sdg] which is part of a 7-disk raid6. OK. See messages at the bottom.

I want to know what those mpt2sas_cm0 messages are.
I think that they come from the raid controller (LSI SAS9211 8i, in non-raid mode).
Q) I see 9 messages, then 9 I/O errors. Are the two numbers related?
After the errors I note that smart shows:
	  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    48
	187 Reported_Uncorrect      -O--CK   099   099   000    -    1
These are new (were 0).

BTW, at this time (5:10AM) my system collects some stats which include "mdadm --misc --{query,detail,examine}".
Q) May this be related?

Q) Noting the very low sector numbers, I wonder which area they are in (see --examine below).

You then can see a single such message later at night without any I/O error. smart attributes did not change then.

Looking at the system log I can see such messages from time to time.
Q) Do these messages indicate that the controller encountered a problem which it resolved?
Q) I saw no md messages, so I assumed that they never propagated to this layer.

TIA,
	Eyal

================== supporting info ================
2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2889 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2889 CDB: Read(16) 88 00 00 00 00 00 00 00 24 08 00 00 04 00 00 00
2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 9224 op 0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2890 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2890 CDB: Read(16) 88 00 00 00 00 00 00 00 28 08 00 00 04 00 00 00
2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 10248 op 0x0:(READ) flags 0x84700 phys_seg 128 prio class 2
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2891 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2891 CDB: Read(16) 88 00 00 00 00 00 00 00 2c 08 00 00 04 00 00 00
2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 11272 op 0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2892 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2892 CDB: Read(16) 88 00 00 00 00 00 00 00 30 08 00 00 04 00 00 00
2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 12296 op 0x0:(READ) flags 0x84700 phys_seg 128 prio class 2
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2893 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2893 CDB: Read(16) 88 00 00 00 00 00 00 00 34 08 00 00 04 00 00 00
2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 13320 op 0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2894 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2894 CDB: Read(16) 88 00 00 00 00 00 00 00 38 08 00 00 04 00 00 00
2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 14344 op 0x0:(READ) flags 0x84700 phys_seg 128 prio class 2
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2895 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2895 CDB: Read(16) 88 00 00 00 00 00 00 00 3c 08 00 00 04 00 00 00
2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 15368 op 0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2896 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2896 CDB: Read(16) 88 00 00 00 00 00 00 00 40 08 00 00 04 00 00 00
2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 16392 op 0x0:(READ) flags 0x84700 phys_seg 128 prio class 2
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2897 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2897 CDB: Read(16) 88 00 00 00 00 00 00 00 44 08 00 00 02 18 00 00
2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 17416 op 0x0:(READ) flags 0x80700 phys_seg 67 prio class 2
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2888 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=6s
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2888 Sense Key : Medium Error [current]
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2888 Add. Sense: Unrecovered read error
2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2888 CDB: Read(16) 88 00 00 00 00 00 00 00 20 08 00 00 04 00 00 00

2025-03-06T22:53:50+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)

$ sudo mdadm --misc --examine /dev/sdg1
/dev/sdg1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
            Name : e4.eyal.emu.id.au:127
   Creation Time : Fri Oct 26 17:24:59 2018
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
      Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=0 sectors
           State : clean
     Device UUID : b1732c74:a34e121d:8347018e:c42b5085

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Mar  7 10:19:13 2025
   Bad Block Log : 512 entries available at offset 56 sectors
        Checksum : f201a5c9 - correct
          Events : 5156938

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 5
    Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

-- 
Eyal at Home (eyal@eyal.emu.id.au)

