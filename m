Received: from pasta.tip.net.au (pasta.tip.net.au [203.10.76.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7EADDBE
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 04:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.10.76.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741321233; cv=none; b=OLNToeASz/1c1C1ui7oosQZJSvXPT+M/kSXUpUW3ytdNn7B2sv3f3WPQdGUZ1Da82mSW7pRibTJP7+XVeDrkMlXbWtsE7RIhYf61kSxKobF9IRfDCX+8ubKMmqif3ZODsrzVAwRGjD6V21OxhT06C/C16uBJ0yWd1bTIWN0MEzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741321233; c=relaxed/simple;
	bh=UtyKuikzVnqmWSNDSZdkF6QU8vvttLF9/5OkY2FdVNU=;
	h=Message-ID:Date:MIME-Version:Subject:References:From:To:
	 In-Reply-To:Content-Type; b=OgH/xdrS68Q5oiuRyrt2dv9/7FGf7ayva82ujuQ/UydvM8DN0Qcw4LgkYZlgivfvoVHdc3J/ZfRTjuuXj54fPW6juGsHr9krSb1v76sshJ9OaD1PTcKQf8tl3wng+6Ik7ypRkWZkDT0JOSBBwefaLW4G8liHzRRQ9d21elBYQkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eyal.emu.id.au; spf=pass smtp.mailfrom=eyal.emu.id.au; arc=none smtp.client-ip=203.10.76.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eyal.emu.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eyal.emu.id.au
Received: from [192.168.2.7] (unknown [101.115.15.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailhost.tip.net.au (Postfix) with ESMTPSA id 4Z8Ckg3FHqz8tpb
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 15:20:27 +1100 (AEDT)
Message-ID: <adedae1f-dfdb-4770-aa1d-af2292851629@eyal.emu.id.au>
Date: Fri, 7 Mar 2025 15:20:25 +1100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eyal@eyal.emu.id.au
Subject: Re: Need to understand error messages
References: <0e2898c2-7d4a-47de-8d23-010cf2d8836b@eyal.emu.id.au>
 <CAAMCDefYhzMxbn8D2CAQ-XtsmykPPLsL8sjt-e0tF2QDMy=Y1A@mail.gmail.com>
Content-Language: en-US
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
To: Linux-RAID <linux-raid@vger.kernel.org>
In-Reply-To: <CAAMCDefYhzMxbn8D2CAQ-XtsmykPPLsL8sjt-e0tF2QDMy=Y1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/3/25 12:27, Roger Heflin wrote:
> That is the report uncorrectable error coming back to the OS.   ie
> sense key: medium error.
> 
> It looks like you had a few commands lined up (the tags) and one io
> hung (2888) and eventually failed (bad sector) but it took long enough
> that  is timed out on all of the other IO behind it (the SOFT_ERROR).
> 
> The scsi layer should have retried the SOFT ones I would think.
> 
> You might want to check to see what smartctl -l scterc says the disks
> timeout is and what the OS level scsi timeout is.  I set the disk
> timeouts as low as the disk will allow and leave my OS timeouts
> default (30 sec typically).

SCT Error Recovery Control:
            Read:     70 (7.0 seconds)
           Write:     70 (7.0 seconds)

> I would have thought there would be a md rewrite.

I also thought so. The fact that I now see 48 Reallocated_Sector_Ct suggests that there were
writes to the failed sectors, since a failed read adds a Pending then the write leads to Reallocation.
Now Current_Pending_Sector is zero.

Also, 48 reallocated is more than the one failed sector the disk sensed,
and the following timed out tags is something the OS saw (and the disk should not reallocate?).

>  It will look like this:
> 
> Feb 16 13:44:16 bm-server kernel: mpt2sas_cm0: log_info(0x31080000):
> originator(PL), code(0x08), sub_code(0x0000)
> Feb 16 13:44:16 bm-server kernel: sd 6:0:1:0: [sdf] tag#923 FAILED
> Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=2s
> Feb 16 13:44:16 bm-server kernel: sd 6:0:1:0: [sdf] tag#923 Sense Key
> : Medium Error [current] [descriptor]
> Feb 16 13:44:16 bm-server kernel: sd 6:0:1:0: [sdf] tag#923 Add.
> Sense: Unrecovered read error
> Feb 16 13:44:16 bm-server kernel: sd 6:0:1:0: [sdf] tag#923 CDB:
> Read(16) 88 00 00 00 00 01 5d 47 6b 08 00 00 00 f8 00 00
> Feb 16 13:44:16 bm-server kernel: critical medium error, dev sdf,
> sector 5859928904 op 0x0:(READ) flags 0x0 phys_seg 23 prio class 0
> Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
> (8 sectors at 1445866416 on sdf6)
> Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
> (8 sectors at 1445866424 on sdf6)
> Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
> (8 sectors at 1445866432 on sdf6)
> Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
> (8 sectors at 1445866440 on sdf6)
> Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
> (8 sectors at 1445866448 on sdf6)
> Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
> (8 sectors at 1445866312 on sdf6)
> Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
> (8 sectors at 1445866320 on sdf6)
> Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
> (8 sectors at 1445866328 on sdf6)
> Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
> (8 sectors at 1445866336 on sdf6)
> Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
> (8 sectors at 1445866344 on sdf6)F


Is the fact that the sectors are all early in the device leading the md/raid to not care
and quietly zero the failed sectors (as there is no usable data there)?

Clearly I still do not fully understand this event.

Is there a document that explains, in detail, what the items listed in the --examine report mean?

Eyal

> On Thu, Mar 6, 2025 at 6:38 PM Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:
>>
>> I am on fedora 40 with
>>          Linux e7.eyal.emu.id.au 6.13.5-100.fc40.x86_64 #1 SMP PREEMPT_DYNAMIC Thu Feb 27 15:10:07 UTC 2025 x86_64 GNU/Linux
>>
>> It seems that there was an issue with a disk [sdg] which is part of a 7-disk raid6. OK. See messages at the bottom.
>>
>> I want to know what those mpt2sas_cm0 messages are.
>> I think that they come from the raid controller (LSI SAS9211 8i, in non-raid mode).
>> Q) I see 9 messages, then 9 I/O errors. Are the two numbers related?
>> After the errors I note that smart shows:
>>            5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    48
>>          187 Reported_Uncorrect      -O--CK   099   099   000    -    1
>> These are new (were 0).
>>
>> BTW, at this time (5:10AM) my system collects some stats which include "mdadm --misc --{query,detail,examine}".
>> Q) May this be related?
>>
>> Q) Noting the very low sector numbers, I wonder which area they are in (see --examine below).
>>
>> You then can see a single such message later at night without any I/O error. smart attributes did not change then.
>>
>> Looking at the system log I can see such messages from time to time.
>> Q) Do these messages indicate that the controller encountered a problem which it resolved?
>> Q) I saw no md messages, so I assumed that they never propagated to this layer.
>>
>> TIA,
>>          Eyal
>>
>> ================== supporting info ================
>> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
>> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
>> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
>> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
>> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
>> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
>> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
>> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
>> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2889 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2889 CDB: Read(16) 88 00 00 00 00 00 00 00 24 08 00 00 04 00 00 00
>> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 9224 op 0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2890 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2890 CDB: Read(16) 88 00 00 00 00 00 00 00 28 08 00 00 04 00 00 00
>> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 10248 op 0x0:(READ) flags 0x84700 phys_seg 128 prio class 2
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2891 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2891 CDB: Read(16) 88 00 00 00 00 00 00 00 2c 08 00 00 04 00 00 00
>> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 11272 op 0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2892 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2892 CDB: Read(16) 88 00 00 00 00 00 00 00 30 08 00 00 04 00 00 00
>> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 12296 op 0x0:(READ) flags 0x84700 phys_seg 128 prio class 2
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2893 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2893 CDB: Read(16) 88 00 00 00 00 00 00 00 34 08 00 00 04 00 00 00
>> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 13320 op 0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2894 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2894 CDB: Read(16) 88 00 00 00 00 00 00 00 38 08 00 00 04 00 00 00
>> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 14344 op 0x0:(READ) flags 0x84700 phys_seg 128 prio class 2
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2895 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2895 CDB: Read(16) 88 00 00 00 00 00 00 00 3c 08 00 00 04 00 00 00
>> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 15368 op 0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2896 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2896 CDB: Read(16) 88 00 00 00 00 00 00 00 40 08 00 00 04 00 00 00
>> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 16392 op 0x0:(READ) flags 0x84700 phys_seg 128 prio class 2
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2897 FAILED Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=6s
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2897 CDB: Read(16) 88 00 00 00 00 00 00 00 44 08 00 00 02 18 00 00
>> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 17416 op 0x0:(READ) flags 0x80700 phys_seg 67 prio class 2
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2888 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=6s
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2888 Sense Key : Medium Error [current]
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2888 Add. Sense: Unrecovered read error
>> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2888 CDB: Read(16) 88 00 00 00 00 00 00 00 20 08 00 00 04 00 00 00
>>
>> 2025-03-06T22:53:50+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
>>
>> $ sudo mdadm --misc --examine /dev/sdg1
>> /dev/sdg1:
>>             Magic : a92b4efc
>>           Version : 1.2
>>       Feature Map : 0x1
>>        Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
>>              Name : e4.eyal.emu.id.au:127
>>     Creation Time : Fri Oct 26 17:24:59 2018
>>        Raid Level : raid6
>>      Raid Devices : 7
>>
>>    Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
>>        Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
>>       Data Offset : 262144 sectors
>>      Super Offset : 8 sectors
>>      Unused Space : before=262064 sectors, after=0 sectors
>>             State : clean
>>       Device UUID : b1732c74:a34e121d:8347018e:c42b5085
>>
>> Internal Bitmap : 8 sectors from superblock
>>       Update Time : Fri Mar  7 10:19:13 2025
>>     Bad Block Log : 512 entries available at offset 56 sectors
>>          Checksum : f201a5c9 - correct
>>            Events : 5156938
>>
>>            Layout : left-symmetric
>>        Chunk Size : 512K
>>
>>      Device Role : Active device 5
>>      Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
>>
>> --
>> Eyal at Home (eyal@eyal.emu.id.au)
>>
>>


-- 
Eyal at Home (eyal@eyal.emu.id.au)
