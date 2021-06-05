Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D775FC47082
	for <linux-raid@archiver.kernel.org>; Sat,  5 Jun 2021 20:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B69BF613EF
	for <linux-raid@archiver.kernel.org>; Sat,  5 Jun 2021 20:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhFEU5G (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Jun 2021 16:57:06 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:43678 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhFEU5G (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 5 Jun 2021 16:57:06 -0400
Received: by mail-pj1-f53.google.com with SMTP id l10-20020a17090a150ab0290162974722f2so7952455pja.2;
        Sat, 05 Jun 2021 13:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=bYzYkC3e21+QVzqWgochfGuOw+jQcSEyJXcEXR0FAik=;
        b=lG+WzX8ddLvSr5ivmMZkD03ssZXx+6O7EehO7YNpd+yJi2FCHqvGXqi6bKdgeObvJO
         A+f6hkLAovjcwA/yYuTzHarhdPLHVXIEtRLsEeesZ38GKyaFBH1mRfUjv17loxN7c8wv
         GgAsah4gnOr1bs/E1XvOXQ8wvi4Twi88zM+53WmUj1N5Z0njN8ogAKnBo19zBRhTisu1
         7JQiodz4bG6zIwdJAolVfdq2NYKDRB+SBKIQl0puFViConB1eMVZ1myNyygiXwCMQrlV
         EJ9V0+ly2Zhb+EHNNI11+u3BFNuDiw7wq6ds2owjz1iom2eyePHgE5KhCy9bRsbI2ijr
         kjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=bYzYkC3e21+QVzqWgochfGuOw+jQcSEyJXcEXR0FAik=;
        b=cT72zIMvte7gSRq0+JlULItwlB9zMZFMVk/mG/LSbDAkpyAPtSyYlGX2UPXfBrqL9B
         STZMZek6eqMWCjEAb9CzCGRd/A/XNrg9YVWG52aRLReY11albsFcQcf6amoRULihmD6O
         vsNv1DVx0bP7TxQrFlVl1DGE91LE4g6TvteMQjTNOnaSTE9/aKR3MQSwv71rF7SfZqQD
         zc+YZFAJqWMHbg7ma1qTcoSSDJl6AhWU3EpgQAhauNS4H2m++QReQdmHFUPuWwvM3jKP
         G0MRdod3M1GCVOIkf1R75zUW5i4s8rjjr+tuzZqM0UE48mBoeZoEKWxOCwpSLpmu1SaJ
         1RQQ==
X-Gm-Message-State: AOAM530l0SAl/j5RmJTrUMDdEsLNJGIzb1Az3ttnDVfF2SRwxnatqq7K
        dbcXaw0zyMOylM7wRGc+0X0wa0HB86U=
X-Google-Smtp-Source: ABdhPJyZi+Mt2DKMORzCj3c5BIqtSM90iuiQejdYNBMzNb3AkQMH+l+xXGgHn2z58AAPir4YI+boQQ==
X-Received: by 2002:a17:90a:e647:: with SMTP id ep7mr24358679pjb.208.1622926457127;
        Sat, 05 Jun 2021 13:54:17 -0700 (PDT)
Received: from [10.7.1.2] ([133.130.111.179])
        by smtp.gmail.com with ESMTPSA id pi8sm3368223pjb.52.2021.06.05.13.54.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Jun 2021 13:54:16 -0700 (PDT)
From:   Wang Shanker <shankerwangmiao@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.6\))
Subject: [Bug Report] Discard bios cannot be correctly merged in blk-mq
Message-Id: <85F98DA6-FB28-4C1F-A47D-C410A7C22A3D@gmail.com>
Date:   Sun, 6 Jun 2021 04:54:09 +0800
Cc:     linux-raid@vger.kernel.org
To:     linux-block@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.6)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, all

I'm writing to report my recent findings about the handling of discard=20=

operations. As indicated by a few tests, discard operation cannot be=20
correctly merged, which leads to poor performance of RAID456 on discard
requests. I'm not quite familiar with block subsystem, so please correct
me if there are any mistakes in the following analysis.

In blk_discard_mergable(), we can see the handling of merging discard=20
operations goes through different processes, decided by whether we have
more than one queue_max_discard_segments. If the device requires the=20
sectors should be contiguous in one discard operation, the merging =
process
will be the same as that for normal read/write operations. Otherwise,=20
bio_attempt_discard_merge will try to merge as many bios as the device
allows, ignoring the contiguity. Sadly, for both cases, there are =
problems.

For devices requiring contiguous sector ranges(such as scsi disks),=20
bio_attempt_front_merge() or bio_attempt_back_merge() will be handling=20=

the merging process, and both control flows will arrive at=20
ll_new_hw_segment(), where the following statement:

    req->nr_phys_segments + nr_phys_segs > blk_rq_get_max_segments(req)

can never be true, since blk_rq_get_max_segments(req) will always be 1.
As a result, no discard operations shall be merged.

For devices supporting multiple segments of sector ranges,=20
bio_attempt_discard_merge() will take over the process. Indeed it will =
merge
some bios. But how many bios can be merged into one request? In the=20
implementation, the maximum number of bios is limited mainly by=20
queue_max_discard_segments (also by blk_rq_get_max_sectors, but it's not =
where
the problem is). However, it is not the case, since =
bio_attempt_discard_merge
is not aware of the contiguity of bios. Suppose there are 20 contiguous =
bios.
They should be considered as only one segment instead 20 of them.

You may wonder the importance of merging discard operations. In the=20
implementation of RAID456, bios are committed in 4k trunks (they call
them as stripes in the code and the size is determined by =
DEFAULT_STRIPE_SIZE).
The proper merging of the bios is of vital importance for a reasonable=20=

operating performance of RAID456 devices. In fact, I met this problem
when attempting to create a raid5 volume on a bunch of Nvme SSDs =
enabling trim
support. Someone also reported similar issues in the linux-raid list
(https://www.spinics.net/lists/raid/msg62108.html). In that post, the =
author
reported that ``lots of small 4k discard requests that get merged into =
larger
512k chunks submitted to devices". This can be explained by my above =
discovery
because nvme allows 128 segments at the maximum in a dsm instruction.

The above two scenarios can be reproduced utilizing latest QEMU, with =
emulated
scsi drives (for the first scenario) or nvme drives (for the second =
scenario)
and enabling the trace of scsi_disk_emulate_command_UNMAP or =
pci_nvme_dsm_deallocate.
The detailed process reproducing is as follows:

1. create a rootfs (e.g. using debootstrap) under ./rootfs/ ;
2. obtain a kernel image vmlinuz and generate a initramfs image =
initrd.img ;
3. create 3 empty sparse disk images:
  # truncate -s 1T disk1 disk2 disk3
4. using the following qemu command to start the guest vm (here 9p is =
used=20
 as the rootfs because we don't want the io operations on the rootfs =
influence
 the debugging of the block layer of the guest vm)
  # qemu-system-x86_64 \
        -cpu kvm64 -machine pc,accel=3Dkvm -smp cpus=3D2,cores=3D2,sockets=
=3D1 -m 2G  \
        -chardev stdio,mux=3Don,id=3Dchar0,signal=3Doff  \
        -fsdev local,path=3D./rootfs,security_model=3Dpassthrough,id=3Droo=
tfs \
        -device virtio-9p,fsdev=3Drootfs,mount_tag=3Drootfs \
        -monitor chardev:char0 \
        -device =
isa-serial,baudbase=3D1500000,chardev=3Dchar0,index=3D0,id=3DttyS0  \
        -nographic \
        -kernel vmlinuz -initrd initrd.img  \
        -append 'root=3Drootfs rw rootfstype=3D9p =
rootflags=3Dtrans=3Dvirtio,msize=3D524288 console=3DttyS0,1500000 =
nokaslr' \
        -blockdev =
driver=3Draw,node-name=3Dnvme1,file.driver=3Dfile,file.filename=3Ddisk1 =
\
        -blockdev =
driver=3Draw,node-name=3Dnvme2,file.driver=3Dfile,file.filename=3Ddisk2 =
\
        -blockdev =
driver=3Draw,node-name=3Dnvme3,file.driver=3Dfile,file.filename=3Ddisk3 =
\
        -trace pci_nvme_dsm_deallocate,file=3Dnvmetrace.log \
        -device =
nvme,drive=3Dnvme1,logical_block_size=3D4096,discard_granularity=3D2097152=
,physical_block_size=3D4096,serial=3DNVME1 \
        -device =
nvme,drive=3Dnvme2,logical_block_size=3D4096,discard_granularity=3D2097152=
,physical_block_size=3D4096,serial=3DNVME2 \
        -device =
nvme,drive=3Dnvme3,logical_block_size=3D4096,discard_granularity=3D2097152=
,physical_block_size=3D4096,serial=3DNVME3
5. enable trim support of the raid456 module:
  # modprobe raid456
  # echo Y > =
/sys/module/raid456/parameters/devices_handle_discard_safely
6. using mdaam to create a raid5 device in the guest vm:
  # mdadm --create --level=3D5 --raid-devices=3D3 /dev/md/test =
/dev/nvme*n1
7. and issue a discard request on the dm device: (limit the size of=20
 discard request because discarding all the 2T data is too slow)
  # blkdiscard -o 0 -l 1M -p 1M --verbose /dev/md/test
8. in nvmetrace.log, there are many pci_nvme_dsm_deallocate events of 4k=20=

 length (nlb 1).

Similarly, the problem with scsi devices can be emulated using the =
following=20
options for qemu:

        -device virtio-scsi,id=3Dscsi \
        -device =
scsi-hd,drive=3Dnvme1,bus=3Dscsi.0,logical_block_size=3D4096,discard_granu=
larity=3D2097152,physical_block_size=3D4096,serial=3DNVME1 \
        -device =
scsi-hd,drive=3Dnvme2,bus=3Dscsi.0,logical_block_size=3D4096,discard_granu=
larity=3D2097152,physical_block_size=3D4096,serial=3DNVME2 \
        -device =
scsi-hd,drive=3Dnvme3,bus=3Dscsi.0,logical_block_size=3D4096,discard_granu=
larity=3D2097152,physical_block_size=3D4096,serial=3DNVME3 \
        -trace scsi_disk_emulate_command_UNMAP,file=3Dscsitrace.log


Despite the discovery, I cannot come up with a proper fix of this issue =
due
to my lack of familiarity of the block subsystem. I expect your kind =
feedback
on this. Thanks in advance.

Cheers,

Miao Wang

