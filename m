Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19719C47082
	for <linux-raid@archiver.kernel.org>; Mon,  7 Jun 2021 13:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0168D610FC
	for <linux-raid@archiver.kernel.org>; Mon,  7 Jun 2021 13:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhFGNJO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Jun 2021 09:09:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230173AbhFGNJN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Jun 2021 09:09:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623071241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VX9AapVWbvG4dPoiFZct8u8sifqhhNzwplReUpf1Qp8=;
        b=TIw1hHnzZfOa85IrZ+RgqtGHhR2c9hlK+Va8qT/jYvqFIw/LHKiNyXMiDtDRG6juw8n1RW
        +jjxHS8WytDRuYiszokRIewDiReRiFvMYMZbTpW0UgYCFCyvY16fo7BinoCnDsi3hte33J
        TbOfs1LdIM0hBkJ6dJlhJS6N3PChMiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-0zlwCBJ9OWGAX_w4jN6uYA-1; Mon, 07 Jun 2021 09:07:20 -0400
X-MC-Unique: 0zlwCBJ9OWGAX_w4jN6uYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFEAC802939;
        Mon,  7 Jun 2021 13:07:18 +0000 (UTC)
Received: from T590 (ovpn-13-182.pek2.redhat.com [10.72.13.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6416419C66;
        Mon,  7 Jun 2021 13:07:13 +0000 (UTC)
Date:   Mon, 7 Jun 2021 21:07:09 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Wang Shanker <shankerwangmiao@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [Bug Report] Discard bios cannot be correctly merged in blk-mq
Message-ID: <YL4Z/QJCKc0NCV5L@T590>
References: <85F98DA6-FB28-4C1F-A47D-C410A7C22A3D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85F98DA6-FB28-4C1F-A47D-C410A7C22A3D@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Jun 06, 2021 at 04:54:09AM +0800, Wang Shanker wrote:
> Hi, all
> 
> I'm writing to report my recent findings about the handling of discard 
> operations. As indicated by a few tests, discard operation cannot be 
> correctly merged, which leads to poor performance of RAID456 on discard
> requests. I'm not quite familiar with block subsystem, so please correct
> me if there are any mistakes in the following analysis.
> 
> In blk_discard_mergable(), we can see the handling of merging discard 
> operations goes through different processes, decided by whether we have
> more than one queue_max_discard_segments. If the device requires the 
> sectors should be contiguous in one discard operation, the merging process
> will be the same as that for normal read/write operations. Otherwise, 
> bio_attempt_discard_merge will try to merge as many bios as the device
> allows, ignoring the contiguity. Sadly, for both cases, there are problems.
> 
> For devices requiring contiguous sector ranges(such as scsi disks), 
> bio_attempt_front_merge() or bio_attempt_back_merge() will be handling 
> the merging process, and both control flows will arrive at 
> ll_new_hw_segment(), where the following statement:
> 
>     req->nr_phys_segments + nr_phys_segs > blk_rq_get_max_segments(req)
> 
> can never be true, since blk_rq_get_max_segments(req) will always be 1.
> As a result, no discard operations shall be merged.

OK, that looks a bug, and the following change may fix the issue:

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 4d97fb6dd226..65210e9a8efa 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -559,10 +559,14 @@ static inline unsigned int blk_rq_get_max_segments(struct request *rq)
 static inline int ll_new_hw_segment(struct request *req, struct bio *bio,
 		unsigned int nr_phys_segs)
 {
-	if (req->nr_phys_segments + nr_phys_segs > blk_rq_get_max_segments(req))
+	if (blk_integrity_merge_bio(req->q, req, bio) == false)
 		goto no_merge;
 
-	if (blk_integrity_merge_bio(req->q, req, bio) == false)
+	/* discard request merge won't add new segment */
+	if (req_op(req) == REQ_OP_DISCARD)
+		return 1;
+
+	if (req->nr_phys_segments + nr_phys_segs > blk_rq_get_max_segments(req))
 		goto no_merge;
 
 	/*

> 
> For devices supporting multiple segments of sector ranges, 
> bio_attempt_discard_merge() will take over the process. Indeed it will merge
> some bios. But how many bios can be merged into one request? In the 
> implementation, the maximum number of bios is limited mainly by 
> queue_max_discard_segments (also by blk_rq_get_max_sectors, but it's not where
> the problem is). However, it is not the case, since bio_attempt_discard_merge
> is not aware of the contiguity of bios. Suppose there are 20 contiguous bios.
> They should be considered as only one segment instead 20 of them.

Right, so far ELEVATOR_DISCARD_MERGE doesn't merge bios actually, but it
can be supported without much difficulty.

> 
> You may wonder the importance of merging discard operations. In the 
> implementation of RAID456, bios are committed in 4k trunks (they call
> them as stripes in the code and the size is determined by DEFAULT_STRIPE_SIZE).
> The proper merging of the bios is of vital importance for a reasonable 
> operating performance of RAID456 devices. In fact, I met this problem
> when attempting to create a raid5 volume on a bunch of Nvme SSDs enabling trim
> support. Someone also reported similar issues in the linux-raid list
> (https://www.spinics.net/lists/raid/msg62108.html). In that post, the author
> reported that ``lots of small 4k discard requests that get merged into larger
> 512k chunks submitted to devices". This can be explained by my above discovery
> because nvme allows 128 segments at the maximum in a dsm instruction.
> 
> The above two scenarios can be reproduced utilizing latest QEMU, with emulated
> scsi drives (for the first scenario) or nvme drives (for the second scenario)
> and enabling the trace of scsi_disk_emulate_command_UNMAP or pci_nvme_dsm_deallocate.
> The detailed process reproducing is as follows:
> 
> 1. create a rootfs (e.g. using debootstrap) under ./rootfs/ ;
> 2. obtain a kernel image vmlinuz and generate a initramfs image initrd.img ;
> 3. create 3 empty sparse disk images:
>   # truncate -s 1T disk1 disk2 disk3
> 4. using the following qemu command to start the guest vm (here 9p is used 
>  as the rootfs because we don't want the io operations on the rootfs influence
>  the debugging of the block layer of the guest vm)
>   # qemu-system-x86_64 \
>         -cpu kvm64 -machine pc,accel=kvm -smp cpus=2,cores=2,sockets=1 -m 2G  \
>         -chardev stdio,mux=on,id=char0,signal=off  \
>         -fsdev local,path=./rootfs,security_model=passthrough,id=rootfs \
>         -device virtio-9p,fsdev=rootfs,mount_tag=rootfs \
>         -monitor chardev:char0 \
>         -device isa-serial,baudbase=1500000,chardev=char0,index=0,id=ttyS0  \
>         -nographic \
>         -kernel vmlinuz -initrd initrd.img  \
>         -append 'root=rootfs rw rootfstype=9p rootflags=trans=virtio,msize=524288 console=ttyS0,1500000 nokaslr' \
>         -blockdev driver=raw,node-name=nvme1,file.driver=file,file.filename=disk1 \
>         -blockdev driver=raw,node-name=nvme2,file.driver=file,file.filename=disk2 \
>         -blockdev driver=raw,node-name=nvme3,file.driver=file,file.filename=disk3 \
>         -trace pci_nvme_dsm_deallocate,file=nvmetrace.log \
>         -device nvme,drive=nvme1,logical_block_size=4096,discard_granularity=2097152,physical_block_size=4096,serial=NVME1 \
>         -device nvme,drive=nvme2,logical_block_size=4096,discard_granularity=2097152,physical_block_size=4096,serial=NVME2 \
>         -device nvme,drive=nvme3,logical_block_size=4096,discard_granularity=2097152,physical_block_size=4096,serial=NVME3
> 5. enable trim support of the raid456 module:
>   # modprobe raid456
>   # echo Y > /sys/module/raid456/parameters/devices_handle_discard_safely
> 6. using mdaam to create a raid5 device in the guest vm:
>   # mdadm --create --level=5 --raid-devices=3 /dev/md/test /dev/nvme*n1
> 7. and issue a discard request on the dm device: (limit the size of 
>  discard request because discarding all the 2T data is too slow)
>   # blkdiscard -o 0 -l 1M -p 1M --verbose /dev/md/test
> 8. in nvmetrace.log, there are many pci_nvme_dsm_deallocate events of 4k 
>  length (nlb 1).

4kb should be the discard segment length, instead of discard request
length, which should be 512k in the above test.

> 
> Similarly, the problem with scsi devices can be emulated using the following 
> options for qemu:
> 
>         -device virtio-scsi,id=scsi \
>         -device scsi-hd,drive=nvme1,bus=scsi.0,logical_block_size=4096,discard_granularity=2097152,physical_block_size=4096,serial=NVME1 \
>         -device scsi-hd,drive=nvme2,bus=scsi.0,logical_block_size=4096,discard_granularity=2097152,physical_block_size=4096,serial=NVME2 \
>         -device scsi-hd,drive=nvme3,bus=scsi.0,logical_block_size=4096,discard_granularity=2097152,physical_block_size=4096,serial=NVME3 \
>         -trace scsi_disk_emulate_command_UNMAP,file=scsitrace.log
> 
> 
> Despite the discovery, I cannot come up with a proper fix of this issue due
> to my lack of familiarity of the block subsystem. I expect your kind feedback
> on this. Thanks in advance.

In the above setting and raid456 test, I observe that rq->nr_phys_segments can
reach 128, but queue_max_discard_segments() reports 256. So discard
request size can be 512KB, which is the max size when you run 1MB discard on
raid456. However, if the discard length on raid456 is increased, the
current way will become inefficient.


Thanks,
Ming

