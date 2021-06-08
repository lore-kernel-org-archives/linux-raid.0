Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51200C47082
	for <linux-raid@archiver.kernel.org>; Tue,  8 Jun 2021 15:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 363F261042
	for <linux-raid@archiver.kernel.org>; Tue,  8 Jun 2021 15:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhFHPwR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Jun 2021 11:52:17 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:38408 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhFHPwQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Jun 2021 11:52:16 -0400
Received: by mail-pf1-f182.google.com with SMTP id z26so15999409pfj.5;
        Tue, 08 Jun 2021 08:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8VLUyVoQjzgbGCtEsnGg1ATy0rOGIPfSYVzGICoK+0o=;
        b=Am6wIR1qKI2VJxXI5igE493846UupCL9mjVmgwGluIU4yYu3C8+yxX2Sh8QNlL+ejk
         NAcgGFbSB5FHaad/0sRsibtQXyjP++3Ee/uKPqRmPg1aYk3LAJGTecD1+1NcqOyPnB3z
         DcnYFjQlKCC5LM7/7/mdR2ZtNL8qKCP1OTJ1u+dIWlsw0KLR5tJtcoHBB0xC5i44jOgX
         qvZLRBkRyo0OJU+XX1KE1x5H46bxRJXaQGEP6w6ax5Ym18C4oHGe9qmEp/ibpN1Y+5rl
         vntvtFvP4PHbn94ze6OP/gXHTZWjowmcAJ4lbUHi7yUonfaBjK2tOOW6UK0egv30VMWM
         PA3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8VLUyVoQjzgbGCtEsnGg1ATy0rOGIPfSYVzGICoK+0o=;
        b=qRJ1VZ9lVyYoC7jCdS0zRhoABpsENCu9xQWpUdXXBui6WdGOum9G2XU8BWmkQjSCKO
         JiDK9lAZxUhTGYy0DFtp9l+nHviwE75HC7eo9yy3Q6L7SEHd9yZLyQxFHKbLnPzkcsjX
         /1XuZP5X63qUU7Vdxm1mS3FobARfU81yHGBin73gjs65XJsai6dX1trHKENMfDINiFm/
         JhO/tClF9a0SzFQdBQUG7wTyvIZk4UlS2oujbKhgS8Z5F7zB3Lt7cr3TJ7rBeJtjWUIL
         E7rMcSbJBJkMJMvvqEGUfLOABWVwMjqJb47Fd6pGLKJsolft3XfENTkFzIHBAs3M4z6B
         ig3w==
X-Gm-Message-State: AOAM5320Ek6iFRBEeX2t/riYVWPvWvfgQwRF+yTQzvsjIsXFf6taMFu5
        vQzNZHH67fM/05NaaJ9Ae8DzxFW3kwA=
X-Google-Smtp-Source: ABdhPJy+1kbsWSf0NuS9puYmIxAleiRCnXNFglZ03V/P/EGHXlLo3WQPf0Q6NBqWQXft7T8i0dq8lQ==
X-Received: by 2002:a05:6a00:a89:b029:2ee:da59:e89c with SMTP id b9-20020a056a000a89b02902eeda59e89cmr480900pfl.17.1623167351805;
        Tue, 08 Jun 2021 08:49:11 -0700 (PDT)
Received: from [10.7.1.2] ([133.130.111.179])
        by smtp.gmail.com with ESMTPSA id s9sm11084892pfm.120.2021.06.08.08.49.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jun 2021 08:49:11 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.6\))
Subject: Re: [Bug Report] Discard bios cannot be correctly merged in blk-mq
From:   Wang Shanker <shankerwangmiao@gmail.com>
In-Reply-To: <YL4Z/QJCKc0NCV5L@T590>
Date:   Tue, 8 Jun 2021 23:49:04 +0800
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C866C380-7A71-4722-957F-2CE65BDACF26@gmail.com>
References: <85F98DA6-FB28-4C1F-A47D-C410A7C22A3D@gmail.com>
 <YL4Z/QJCKc0NCV5L@T590>
To:     Ming Lei <ming.lei@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.6)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> 2021=E5=B9=B406=E6=9C=8807=E6=97=A5 21:07=EF=BC=8CMing Lei =
<ming.lei@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Sun, Jun 06, 2021 at 04:54:09AM +0800, Wang Shanker wrote:
>> Hi, all
>>=20
>> I'm writing to report my recent findings about the handling of =
discard=20
>> operations. As indicated by a few tests, discard operation cannot be=20=

>> correctly merged, which leads to poor performance of RAID456 on =
discard
>> requests. I'm not quite familiar with block subsystem, so please =
correct
>> me if there are any mistakes in the following analysis.
>>=20
>> In blk_discard_mergable(), we can see the handling of merging discard=20=

>> operations goes through different processes, decided by whether we =
have
>> more than one queue_max_discard_segments. If the device requires the=20=

>> sectors should be contiguous in one discard operation, the merging =
process
>> will be the same as that for normal read/write operations. Otherwise,=20=

>> bio_attempt_discard_merge will try to merge as many bios as the =
device
>> allows, ignoring the contiguity. Sadly, for both cases, there are =
problems.
>>=20
>> For devices requiring contiguous sector ranges(such as scsi disks),=20=

>> bio_attempt_front_merge() or bio_attempt_back_merge() will be =
handling=20
>> the merging process, and both control flows will arrive at=20
>> ll_new_hw_segment(), where the following statement:
>>=20
>>    req->nr_phys_segments + nr_phys_segs > =
blk_rq_get_max_segments(req)
>>=20
>> can never be true, since blk_rq_get_max_segments(req) will always be =
1.
>> As a result, no discard operations shall be merged.
>=20
> OK, that looks a bug, and the following change may fix the issue:
>=20
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 4d97fb6dd226..65210e9a8efa 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -559,10 +559,14 @@ static inline unsigned int =
blk_rq_get_max_segments(struct request *rq)
> static inline int ll_new_hw_segment(struct request *req, struct bio =
*bio,
> 		unsigned int nr_phys_segs)
> {
> -	if (req->nr_phys_segments + nr_phys_segs > =
blk_rq_get_max_segments(req))
> +	if (blk_integrity_merge_bio(req->q, req, bio) =3D=3D false)
> 		goto no_merge;
>=20
> -	if (blk_integrity_merge_bio(req->q, req, bio) =3D=3D false)
> +	/* discard request merge won't add new segment */
> +	if (req_op(req) =3D=3D REQ_OP_DISCARD)
> +		return 1;
> +
> +	if (req->nr_phys_segments + nr_phys_segs > =
blk_rq_get_max_segments(req))
> 		goto no_merge;
>=20
> 	/*
>=20

Many thanks for this patch. I wonder whether it will be applied soon or =
it will go=20
through a formal [PATCH] process.

>>=20
>> For devices supporting multiple segments of sector ranges,=20
>> bio_attempt_discard_merge() will take over the process. Indeed it =
will merge
>> some bios. But how many bios can be merged into one request? In the=20=

>> implementation, the maximum number of bios is limited mainly by=20
>> queue_max_discard_segments (also by blk_rq_get_max_sectors, but it's =
not where
>> the problem is). However, it is not the case, since =
bio_attempt_discard_merge
>> is not aware of the contiguity of bios. Suppose there are 20 =
contiguous bios.
>> They should be considered as only one segment instead 20 of them.
>=20
> Right, so far ELEVATOR_DISCARD_MERGE doesn't merge bios actually, but =
it
> can be supported without much difficulty.
>=20
>>=20
>> You may wonder the importance of merging discard operations. In the=20=

>> implementation of RAID456, bios are committed in 4k trunks (they call
>> them as stripes in the code and the size is determined by =
DEFAULT_STRIPE_SIZE).
>> The proper merging of the bios is of vital importance for a =
reasonable=20
>> operating performance of RAID456 devices. In fact, I met this problem
>> when attempting to create a raid5 volume on a bunch of Nvme SSDs =
enabling trim
>> support. Someone also reported similar issues in the linux-raid list
>> (https://www.spinics.net/lists/raid/msg62108.html). In that post, the =
author
>> reported that ``lots of small 4k discard requests that get merged =
into larger
>> 512k chunks submitted to devices". This can be explained by my above =
discovery
>> because nvme allows 128 segments at the maximum in a dsm instruction.
>>=20
>> The above two scenarios can be reproduced utilizing latest QEMU, with =
emulated
>> scsi drives (for the first scenario) or nvme drives (for the second =
scenario)
>> and enabling the trace of scsi_disk_emulate_command_UNMAP or =
pci_nvme_dsm_deallocate.
>> The detailed process reproducing is as follows:
>>=20
>> 1. create a rootfs (e.g. using debootstrap) under ./rootfs/ ;
>> 2. obtain a kernel image vmlinuz and generate a initramfs image =
initrd.img ;
>> 3. create 3 empty sparse disk images:
>>  # truncate -s 1T disk1 disk2 disk3
>> 4. using the following qemu command to start the guest vm (here 9p is =
used=20
>> as the rootfs because we don't want the io operations on the rootfs =
influence
>> the debugging of the block layer of the guest vm)
>>  # qemu-system-x86_64 \
>>        -cpu kvm64 -machine pc,accel=3Dkvm -smp =
cpus=3D2,cores=3D2,sockets=3D1 -m 2G  \
>>        -chardev stdio,mux=3Don,id=3Dchar0,signal=3Doff  \
>>        -fsdev =
local,path=3D./rootfs,security_model=3Dpassthrough,id=3Drootfs \
>>        -device virtio-9p,fsdev=3Drootfs,mount_tag=3Drootfs \
>>        -monitor chardev:char0 \
>>        -device =
isa-serial,baudbase=3D1500000,chardev=3Dchar0,index=3D0,id=3DttyS0  \
>>        -nographic \
>>        -kernel vmlinuz -initrd initrd.img  \
>>        -append 'root=3Drootfs rw rootfstype=3D9p =
rootflags=3Dtrans=3Dvirtio,msize=3D524288 console=3DttyS0,1500000 =
nokaslr' \
>>        -blockdev =
driver=3Draw,node-name=3Dnvme1,file.driver=3Dfile,file.filename=3Ddisk1 =
\
>>        -blockdev =
driver=3Draw,node-name=3Dnvme2,file.driver=3Dfile,file.filename=3Ddisk2 =
\
>>        -blockdev =
driver=3Draw,node-name=3Dnvme3,file.driver=3Dfile,file.filename=3Ddisk3 =
\
>>        -trace pci_nvme_dsm_deallocate,file=3Dnvmetrace.log \
>>        -device =
nvme,drive=3Dnvme1,logical_block_size=3D4096,discard_granularity=3D2097152=
,physical_block_size=3D4096,serial=3DNVME1 \
>>        -device =
nvme,drive=3Dnvme2,logical_block_size=3D4096,discard_granularity=3D2097152=
,physical_block_size=3D4096,serial=3DNVME2 \
>>        -device =
nvme,drive=3Dnvme3,logical_block_size=3D4096,discard_granularity=3D2097152=
,physical_block_size=3D4096,serial=3DNVME3
>> 5. enable trim support of the raid456 module:
>>  # modprobe raid456
>>  # echo Y > =
/sys/module/raid456/parameters/devices_handle_discard_safely
>> 6. using mdaam to create a raid5 device in the guest vm:
>>  # mdadm --create --level=3D5 --raid-devices=3D3 /dev/md/test =
/dev/nvme*n1
>> 7. and issue a discard request on the dm device: (limit the size of=20=

>> discard request because discarding all the 2T data is too slow)
>>  # blkdiscard -o 0 -l 1M -p 1M --verbose /dev/md/test
>> 8. in nvmetrace.log, there are many pci_nvme_dsm_deallocate events of =
4k=20
>> length (nlb 1).
>=20
> 4kb should be the discard segment length, instead of discard request
> length, which should be 512k in the above test.

Actually, what are received by the nvme controller are discard requests
with 128 segments of 4k, instead of one segment of 512k.

>=20
>>=20
>> Similarly, the problem with scsi devices can be emulated using the =
following=20
>> options for qemu:
>>=20
>>        -device virtio-scsi,id=3Dscsi \
>>        -device =
scsi-hd,drive=3Dnvme1,bus=3Dscsi.0,logical_block_size=3D4096,discard_granu=
larity=3D2097152,physical_block_size=3D4096,serial=3DNVME1 \
>>        -device =
scsi-hd,drive=3Dnvme2,bus=3Dscsi.0,logical_block_size=3D4096,discard_granu=
larity=3D2097152,physical_block_size=3D4096,serial=3DNVME2 \
>>        -device =
scsi-hd,drive=3Dnvme3,bus=3Dscsi.0,logical_block_size=3D4096,discard_granu=
larity=3D2097152,physical_block_size=3D4096,serial=3DNVME3 \
>>        -trace scsi_disk_emulate_command_UNMAP,file=3Dscsitrace.log
>>=20
>>=20
>> Despite the discovery, I cannot come up with a proper fix of this =
issue due
>> to my lack of familiarity of the block subsystem. I expect your kind =
feedback
>> on this. Thanks in advance.
>=20
> In the above setting and raid456 test, I observe that =
rq->nr_phys_segments can
> reach 128, but queue_max_discard_segments() reports 256. So discard
> request size can be 512KB, which is the max size when you run 1MB =
discard on
> raid456. However, if the discard length on raid456 is increased, the
> current way will become inefficient.

Exactly.=20

I suggest that bio's can be merged and be calculated as one segment if =
they are
contiguous and contain no data.

And I also discovered later that, even normal long write requests, e.g.
a 10m write, will be split into 4k bio's. The maximum number of bio's =
which can=20
be merged into one request is limited by queue_max_segments, regardless
of whether those bio's are contiguous. In my test environment, for scsi =
devices,
queue_max_segments can be 254, which means about 1m size of requests. =
For nvme
devices(e.g. Intel DC P4610), queue_max_segments is only 33 since their =
mdts is 5,
which results in only 132k of requests.=20

So, I would also suggest that raid456 should be improved to issue bigger =
bio's to
underlying drives.

Cheers,

Miao Wang

