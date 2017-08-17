From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Filesystem corruption on RAID1
Date: Thu, 17 Aug 2017 10:23:47 +0200
Message-ID: <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
 <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org, Gionatan Danti <g.danti@assyoma.it>
List-Id: linux-raid.ids

On 14/07/2017 12:46, Gionatan Danti wrote:> Hi, so a 
premature/preventive drive detachment is not a silver bullet,
> and I buy it. However, I would at least expect this behavior to be 
> configurable. Maybe it is, and I am missing something?
> 
> Anyway, what really surprise me is *not* the drive to not be detached, 
> rather permitting that corruption make its way into real data. I naively 
> expect that when a WRITE_QUEUED or CACHE_FLUSH command aborts/fails 
> (which *will* cause data corruption if not properly handled) the I/O 
> layer has the following possibilities:
> 
> a) retry the write/flush. You don't want to retry indefinitely, so the 
> kernel need some type of counter/threshold; when the counter is reached, 
> continue with b). This would mask out sporadic errors, while propagating 
> recurring ones;
> 
> b) notify the upper layer that a write error happened. For synchronized 
> and direct writes it can notify that by simply returning the correct 
> exit code to the calling function. In this case, the block layer should 
> return an error to the MD driver, which must act accordlying: for 
> example, dropping the disk from the array.
> 
> c) do nothing. This seems to me by far the worst choice.
> 
> If b) is correcly implemented, it should prevent corruption to 
> accumulate on the drives.
> 
> Please also note the *type* of corrupted data: not only user data, but 
> filesystem journal and metadata also. The latter should be protected by 
> the using of write barriers / FUAs, so they should be able to stop 
> themselves *before* corruption.
> 
> So I have some very important questions:
> - how does MD behave when flushing data to disk?
> - does it propagate write barriers?
> - when a write barrier fails, is the error propagated to the upper layers?
> 
> Thanks you all.
>

Hi all,
having some free time, I conducted some new tests and I am now able to 
100% replicate the problem. To recap: a filesystem on a RAID1 array was 
corrupted due to SATA WRITEs failing but *no* I/O error being reported 
to higher layer (ie: mdraid/mdadm). I already submitted my findings on 
the linux-scsi mailing list, but I want to share them here because they 
can be useful to others.

On the affected machine, /var/log/messages shown some "failed command: 
WRITE FPDMA QUEUED" entries, but *no* action (ie: kick off disk) was 
taken by MDRAID. I tracked down the problem to an instable power supply 
(switching power rail/connector solved the problem).

In the latest day I had some spare time and I am now able to regularly 
replicate the problem. Basically, when a short powerloss happens, the 
scsi midlayer logs some failed operations, but does *not* pass these 
errors to higher layer. In other words, no I/O error is returned to the 
calling application. This is the reason why MDRAID did not kick off the 
instable disk on the machine with corrupted filesystem.

To replicated the problem, I wrote a large random file on a small MD 
RAID1 array, pulling off the power of one disk from about 2 seconds. The 
file write operation stopped for some seconds, than recovered. Running 
an array check resulted in a high number of mismatch_cnt sectors. Dmesg 
logged the following lines:

Aug 16 16:04:02 blackhole kernel: ata6.00: exception Emask 0x50 SAct 
0x7fffffff SErr 0x90a00 action 0xe frozen
Aug 16 16:04:02 blackhole kernel: ata6.00: irq_stat 0x00400000, PHY RDY 
changed
Aug 16 16:04:02 blackhole kernel: ata6: SError: { Persist HostInt 
PHYRdyChg 10B8B }
Aug 16 16:04:02 blackhole kernel: ata6.00: failed command: WRITE FPDMA 
QUEUED
Aug 16 16:04:02 blackhole kernel: ata6.00: cmd 
61/00:00:10:82:09/04:00:00:00:00/40 tag 0 ncq 524288 out#012         res 
40/00:d8:10:72:09/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
Aug 16 16:04:02 blackhole kernel: ata6.00: status: { DRDY }
...
Aug 16 16:04:02 blackhole kernel: ata6.00: failed command: WRITE FPDMA 
QUEUED
Aug 16 16:04:02 blackhole kernel: ata6.00: cmd 
61/00:f0:10:7e:09/04:00:00:00:00/40 tag 30 ncq 524288 out#012 
res 40/00:d8:10:72:09/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
Aug 16 16:04:02 blackhole kernel: ata6.00: status: { DRDY }
Aug 16 16:04:02 blackhole kernel: ata6: hard resetting link
Aug 16 16:04:03 blackhole kernel: ata6: SATA link down (SStatus 0 
SControl 310)
Aug 16 16:04:04 blackhole kernel: ata6: hard resetting link
Aug 16 16:04:14 blackhole kernel: ata6: softreset failed (device not ready)
Aug 16 16:04:14 blackhole kernel: ata6: hard resetting link
Aug 16 16:04:24 blackhole kernel: ata6: softreset failed (device not ready)
Aug 16 16:04:24 blackhole kernel: ata6: hard resetting link
Aug 16 16:04:35 blackhole kernel: ata6: link is slow to respond, please 
be patient (ready=0)
Aug 16 16:04:42 blackhole kernel: ata6: SATA link down (SStatus 0 
SControl 310)
Aug 16 16:04:46 blackhole kernel: ata6: hard resetting link
Aug 16 16:04:46 blackhole kernel: ata3: exception Emask 0x10 SAct 0x0 
SErr 0x40d0202 action 0xe frozen
Aug 16 16:04:46 blackhole kernel: ata3: irq_stat 0x00400000, PHY RDY changed
Aug 16 16:04:46 blackhole kernel: ata3: SError: { RecovComm Persist 
PHYRdyChg CommWake 10B8B DevExch }
Aug 16 16:04:46 blackhole kernel: ata3: hard resetting link
Aug 16 16:04:51 blackhole kernel: ata3: softreset failed (device not ready)
Aug 16 16:04:51 blackhole kernel: ata3: applying PMP SRST workaround and 
retrying
Aug 16 16:04:51 blackhole kernel: ata3: SATA link up 3.0 Gbps (SStatus 
123 SControl 300)
Aug 16 16:04:51 blackhole kernel: ata3.00: configured for UDMA/133
Aug 16 16:04:51 blackhole kernel: ata3: EH complete
Aug 16 16:04:52 blackhole kernel: ata6: softreset failed (device not ready)
Aug 16 16:04:52 blackhole kernel: ata6: applying PMP SRST workaround and 
retrying
Aug 16 16:04:52 blackhole kernel: ata6: SATA link up 1.5 Gbps (SStatus 
113 SControl 310)
Aug 16 16:04:52 blackhole kernel: ata6.00: configured for UDMA/133
Aug 16 16:04:52 blackhole kernel: ata6: EH complete

As you can see, while failed SATA operation were logged in dmesg (and 
/var/log/messages), no I/O errors where returned to the upper layer 
(MDRAID) or the calling application. I had to say that I *fully expect* 
some inconsistencies: after all, removing the power wipes the volatile 
disk's DRAM cache, which means data loss. However, I really expected 
some I/O errors to be thrown to the higher layers, causing visible 
reactions (ie: a disks pushed out the array). With no I/O errors 
returned, the higher layer application are effectively blind.

Moreover, both disks show the *same RAID event number*, so the MDRAID 
layer can not automatically offline/don't read the corrupted disk. Here 
is the relevant output:

[root@blackhole storage]# mdadm -E /dev/sd[bc]1
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 8d06acd3:95920a78:069a7fc3:a526ca8a
            Name : blackhole.assyoma.it:200  (local to host 
blackhole.assyoma.it)
   Creation Time : Wed Aug 16 15:11:14 2017
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 2095104 (1023.00 MiB 1072.69 MB)
      Array Size : 1047552 (1023.00 MiB 1072.69 MB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
    Unused Space : before=1960 sectors, after=0 sectors
           State : clean
     Device UUID : 97bfbe06:89016508:2cb250c9:937a5c2e

     Update Time : Thu Aug 17 10:09:28 2017
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 52670329 - correct
          Events : 759


    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 8d06acd3:95920a78:069a7fc3:a526ca8a
            Name : blackhole.assyoma.it:200  (local to host 
blackhole.assyoma.it)
   Creation Time : Wed Aug 16 15:11:14 2017
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 2095104 (1023.00 MiB 1072.69 MB)
      Array Size : 1047552 (1023.00 MiB 1072.69 MB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
    Unused Space : before=1960 sectors, after=0 sectors
           State : clean
     Device UUID : bf660182:701430fd:55f5fde9:6ded709e

     Update Time : Thu Aug 17 10:09:28 2017
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 5336733f - correct
          Events : 759


    Device Role : Active device 1
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)

More concerning is the fact that these undetected errors can make their 
way even when the higher application consistently calls sync() and/or 
fsync. In other words, it seems than even acknowledged writes can fail 
in this manner (and this is consistent with the first machine corrupting 
its filesystem due to journal trashing - XFS journal surely uses sync() 
where appropriate). The mechanism seems the following:

- an higher layer application issue sync();
- a write barrier is generated;
- a first FLUSH CACHE command is sent to the disk;
- data are written to the disk's DRAM cache;
- power is lost! The volatile cache lose its content;
- power is re-established and the disk become responsive again;
- a second FLUSH CACHE command is sent to the disk;
- the disk acks each SATA command, but real data are lost.

As a side note, when the power loss or SATA cable disconnection is 
relatively long (over 10 seconds, as by eh timeout), the SATA disks 
become disconnected (and the MD layer acts accordlying):

Aug 16 16:12:20 blackhole kernel: ata6.00: exception Emask 0x50 SAct 
0x7fffffff SErr 0x490a00 action 0xe frozen
Aug 16 16:12:20 blackhole kernel: ata6.00: irq_stat 0x08000000, 
interface fatal error
Aug 16 16:12:20 blackhole kernel: ata6: SError: { Persist HostInt 
PHYRdyChg 10B8B Handshk }
Aug 16 16:12:20 blackhole kernel: ata6.00: failed command: WRITE FPDMA 
QUEUED
Aug 16 16:12:20 blackhole kernel: ata6.00: cmd 
61/00:00:38:88:09/04:00:00:00:00/40 tag 0 ncq 524288 out#012         res 
40/00:d8:38:f4:09/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
Aug 16 16:12:20 blackhole kernel: ata6.00: status: { DRDY }
...
Aug 16 16:12:32 blackhole kernel: sd 5:0:0:0: [sdf] FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Aug 16 16:12:32 blackhole kernel: sd 5:0:0:0: [sdf] Sense Key : Illegal 
Request [current] [descriptor]
Aug 16 16:12:32 blackhole kernel: sd 5:0:0:0: [sdf] Add. Sense: 
Unaligned write command
Aug 16 16:12:32 blackhole kernel: sd 5:0:0:0: [sdf] CDB: Write(10) 2a 00 
00 09 88 38 00 04 00 00
Aug 16 16:12:32 blackhole kernel: blk_update_request: 23 callbacks 
suppressed
Aug 16 16:12:32 blackhole kernel: blk_update_request: I/O error, dev 
sdf, sector 624696

Now, I have few questions:
- is the above explanation plausible, or I am (horribly) missing something?
- why the scsi midlevel does not respond to a power loss event by 
immediately offlining the disks?
- is the scsi midlevel behavior configurable (I know I can lower eh 
timeout, but is this the right solution)?
- how to deal with this problem (other than being 100% sure power is 
never lost by any disks)?

Thank you all,
regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
