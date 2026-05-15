Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14EF4CA260
	for <linux-raid@vger.kernel.org>; Fri, 15 May 2026 16:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778863995; cv=pass; b=ZiGPA9G9V+fa685tOG0iABpl9p0dKGDuhYEYD5iubGlFHfUIzsv1RXVqNSuTDFmMpaVPyzedkh8O3RrqwVYPo0iXIRCpU3L2Syi/ML5SEIRkmeExIPRqVpYtEujr2p8y9UZFy2SjqUWvbbJa3V2lO4mfe62VIkNarMCtO4PCM8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778863995; c=relaxed/simple;
	bh=oour2uG5iRfmu2ayrytJIqDx9R0+oLFFwOaMHB+gtAU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=czHzq8Cgt5PDW3jh7uSi8iPZKoCa+lmCaf3ar6aHnizJdDzUotiUfyJZ3ZUrde18cXLuFShXKKqA6ZoVPvd/4VHlzGax1qTvp+9Nz9oU643s1G6GsIpGdoan0kBpqgJ9zeZEvKDgchjNZAF9sui7AhQA/dveizWfZ6Zt93kaZIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NMKaEt+M; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NMKaEt+M"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5a3ffd11fa2so520222e87.0
        for <linux-raid@vger.kernel.org>; Fri, 15 May 2026 09:53:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778863991; cv=none;
        d=google.com; s=arc-20240605;
        b=ZLUHo7ntMNU4IULh3v+yQVGCDfrCy0GP9mI2/c6zyUEzB324J6mZynRVZ4NIXDe44s
         3AgbZNxcg0vlcWk0zQ4n45wc8qrfjz0EH3ui/CUvpGxtFXpP6v7r919V81cK7YsLxWuP
         PwVszVpJoMFKJ9/XbsYx5HQ38Tz9nwHSnylXOvzOLZ3mj0G3bMAiRTgmP3UPjmVoR/rn
         3jd6MS1Nj3s+s6cfWQDCyHJ8bf/jR9DoLWidLjb7O0W2r58+EJuzJbSnZZ/zk2SHNGmo
         5MEryvoPFTiAGErxCCh1jvFE/QiktzJPc2HYmfzzqIZ8PEBu9TH1Ck82WRFxI7iOplna
         WWIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=QyIEXMzo0LLWlJtxbIVaApvLffeGdlkhSdDar+auJNA=;
        fh=uW+LuMkSDE2qgvN5lFAHKhABQVnyviMJRfpBq+vQDno=;
        b=kBNYAsPw2KcgcDunE5QHpMT1AKldzPP5u2t7X1yXzNz8EykkCZvbxdVNJN+0qpg+SD
         zy0lDdx5sfq/q04RtpkqVVi9Dvxe3QPL0VUMjJuF69RglimlsNh595KfmCnH6Qfn0wFQ
         eSSU1u8ld18luWMxKho/vVwqe7z2SPweUbZJ58FD435D+R+W/Otw5gmwoed9NWPE3GHF
         T+9DMfVn+EK2AipoGdZgs8MHCKciqBxCKjBuvEnKx5XgBoOxffnaJr0HyNuekwEnwXqI
         hWsfJ00xOb/t/HhUQMbc/z+0gkk0GlgMqKa37lWm0LoJozCB34B4GVBYg06O9t6tNQ+h
         v6VA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778863991; x=1779468791; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QyIEXMzo0LLWlJtxbIVaApvLffeGdlkhSdDar+auJNA=;
        b=NMKaEt+MyqGDHZWvALdik1ENydXqfR1JpamuHQR35ud6ml7oPptZSzVA+g7YP3591u
         ptea/n3+AJCvDA1tm4J/E8S1OUtrNN5oXZOa3NFUA+k7jGS8L6vI6mWA6P0/geecc7kj
         QwgN2zx2p9PFIBJIQKxPiqJDeORWIp2HdJAU1liN5+5V9CzK+9lB3gUoAv7cCN9sZkW1
         mnVFpN92r2fFSUmEo0hkvre9eKZbGIbgox8jhZsavoIw70txa9ggCpkRW5HQzaVjdfj7
         ISglf2Z1EgJkugoMKQq/IyMwmf82qwVrOvHBFOzdHhK1N/y3W2uBV1K9Ni3D81hQXzbY
         8VSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778863991; x=1779468791;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QyIEXMzo0LLWlJtxbIVaApvLffeGdlkhSdDar+auJNA=;
        b=YmZ91xvGNaBr3ud4Y4HkzzV+9CpXaoqcRkphxBh9IY08f+YytEBxXpr48LF5Nro6QD
         uNMPhccUpQEHob+JZfDQj4nnXFBO64THtdwQAUE69muQ5ugQgGnvHgfT7a+PcdcYAvM5
         0kVv9s5zfbtptOl26AYpYLecunlO+hE4brAKs80ZkhKX5c07JxDezbDcEpzGWkCE//es
         /Y4CJnOHSizcgeEQJ4gS4vpqF46RK7RVf/SGn9hrupaR/GKCsc9V0m2NiNp4PSEo7hY9
         aoDuXzwr2+7f2dDQ2chbUWG3FAd1CbvvdZtOR+UZhFB73CU9ssRXFnxdV/ZL0cMGAVPa
         tsjg==
X-Forwarded-Encrypted: i=1; AFNElJ93IHrcOWX4fTKaYVTRIy6wurYFnJ++flNgtp+FrTxC3TnwjXL+DD3P5uHyFbAHyKJXM/jfSdzvsRa4@vger.kernel.org
X-Gm-Message-State: AOJu0Yy57CzJBQ8TPrFr5qXd2GmZi6tidUl7A/Zh2EGZjMAhV0fSVKyO
	SDK1j2dQ/kbhvUyOC+waI1vfTvsn1x12qvmJTyCJankkRO0hIBbbwIRzXANuMocEHBPHUIAZhrP
	oNiZh6+MVH+bfxtV++Lx4Ak2ma5idrZ0=
X-Gm-Gg: Acq92OHljNwcCS9cLHMVBaTsGt0rnbYrXQvPAJNmHoHQ/IyTaq3hzCf+dvILe1Nq/mK
	ohccEtwxVBNHmj5c/1X8kUL9MvjzrxVrmX/ym6IDHcqdlDN++Zlh36TOEq8x0bStJcrp5vcdBeN
	J7ICKRGXjXZBDwiw16MiaIFTN2vm7crbvkMH7WUrvA/tuKxiZH211toUAImjt5VrPNd8vbCKUFV
	GbHs2KsoAj8Wp6M4BqWv+pPQ0bNTfGMIPXYwIHkjeHZOzkiu9+BAMr7eo6qc4rz8+aU0W/AiR+K
	dPH9BsI=
X-Received: by 2002:a05:6512:108a:b0:5a4:19de:eb77 with SMTP id
 2adb3069b0e04-5aa0e74c40emr560236e87.3.1778863990648; Fri, 15 May 2026
 09:53:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Vjaceslavs Klimovs <vklimovs@gmail.com>
Date: Fri, 15 May 2026 09:52:59 -0700
X-Gm-Features: AVHnY4K5KLdo5SUY6rORreRp5hLSJu5MynIgl0mmY702h5swQNzKJAuKAe4ZMPI
Message-ID: <CAC_j7i1R7oy+nRhxEjCTba=DUgn02w9X+p94DCu0aHv5+5tKnQ@mail.gmail.com>
Subject: [REGRESSION] block: virtio-blk + LVM raid1 spurious sector-0 read
 failures on libaio/threads submit since 5ff3f74e145a ("block: simplify direct
 io validity check")
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Summary
-------
On v6.18, starting a libvirt/QEMU guest with virtio-blk backed by an
LVM "--type raid1" LV (drivers/md/dm-raid.c stacked on
drivers/md/raid1.c) makes md/raid1 register read failures at LV
sector 0 within seconds of "virsh start" and mark rimage_0 Faulty
once max_corrected_read_errors (default 20) is exceeded. Reads
succeed via the redirect path so guests boot, but every guest disk
ends up degraded on every VM start. Same workload on legacy
"--type mirror" (drivers/md/dm-raid1.c) crashes the host: a
zero-length READ reaches the NVMe controller, is rejected with
"Invalid Field in Command", and the dm-mirror recovery path oopses.

Symptom on dm-raid raid1 (post --type raid1)
--------------------------------------------
Per LV, at virsh start, in host dmesg:

  kernel: raid1_end_read_request: 95 callbacks suppressed
  kernel: raid1_read_request: 95 callbacks suppressed
  kernel: md/raid1:mdX: dm-58: rescheduling sector 0
  kernel: md/raid1:mdX: redirecting sector 0 to other mirror: dm-58
  kernel: md/raid1:mdX: dm-58: rescheduling sector 0
  kernel: md/raid1:mdX: redirecting sector 0 to other mirror: dm-58
  [... 10 rescheduling/redirecting pairs ...]
  kernel: md/raid1:mdX: dm-58: Raid device exceeded read_error
threshold [cur 21:max 20]
  kernel: md/raid1:mdX: dm-58: Failing raid device
  kernel: md/raid1:mdX: Disk failure on dm-58, disabling device.
  kernel: md/raid1:mdX: Operation continuing on 1 devices.

  dmeventd: WARNING: Device #0 of raid1 array, vg0-iris_boot, has failed.
  dmeventd: WARNING: Waiting for resynchronization to finish before
initiating repair on RAID device vg0-iris_boot.
  dmeventd: Use 'lvconvert --repair vg0/iris_boot' to replace failed device.

Subsequent "lvs -a":

  WARNING: RaidLV vg0/iris_boot needs to be refreshed!
  See character 'r' at position 9 in the RaidLV's attributes and its SubLV(s).

dmesg | grep nvme is EMPTY on this path. The NVMe driver is not
involved in producing the error; the failure originates between the
virtio-blk bio submission and raid1_end_read_request().

Symptom on legacy dm-mirror (pre-conversion --type mirror)
----------------------------------------------------------
Same workload on drivers/md/dm-raid1.c reaches the NVMe controller
as a zero-length READ and panics the host through dm-mirror's
recovery path:

  kernel: operation not supported error, dev nvme1n1, sector 935446535
op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
  kernel: nvme1n1: I/O Cmd(0x2) @ LBA 935446535, 0 blocks, I/O Error
(sct 0x0 / sc 0x2)
  [... 10+ identical bursts at same timestamp ...]
  dmeventd: Primary mirror device 252:58 read failed.
  dmeventd: vg0-iris_boot is now in-sync.
  [kernel oops in dm_mirror recovery path, full trace lost to console flash]

The "phys_seg 0", "0 blocks", "sct 0x0/sc 0x2" trio (NVMe Generic,
Invalid Field in Command, NVMe spec 4.1.1.2) is unambiguous: a bio
with bi_iter.bi_size == 0 and bi_vcnt == 0 left the block layer and
hit the controller. dm-raid raid1 hides this by retrying on the
surviving leg, but the upstream-of-md trigger is identical.

Bisect
------
git bisect, v6.12..v6.18, 16 deterministic GOOD/BAD steps, no skips,
~104 minutes:

  5ff3f74e145adc79b49668adb8de276446acf6be is the first bad commit
  block: simplify direct io validity check

  --- a/block/fops.c
  +++ b/block/fops.c
  @@ -38,8 +38,8 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
   static bool blkdev_dio_invalid(struct block_device *bdev, struct kiocb *iocb,
                                  struct iov_iter *iter)
   {
  -        return iocb->ki_pos & (bdev_logical_block_size(bdev) - 1) ||
  -                !bdev_iter_is_aligned(bdev, iter);
  +        return (iocb->ki_pos | iov_iter_count(iter)) &
  +                        (bdev_logical_block_size(bdev) - 1);
   }

The dropped bdev_iter_is_aligned() used to walk the iov_iter and
reject per-segment misaligned/degenerate vectors at the blkdev fops
entry point. The replacement only validates ki_pos and total length
against the logical block size. Cases that now pass that no longer
get rejected:

  - iter with iov_iter_count(iter) == 0  (degenerate; total length is
    "sector-aligned" since 0 % 512 == 0)
  - iter where total length is sector-aligned but a segment isn't

The commit message justifies the removal with "The block layer
checks all the segments for validity later". This is true for the
io_uring submit path (which enters __blkdev_direct_IO directly and
does its own validation) but not for the libaio aio_read/write_iter
or the worker-pool sync read/write_iter paths that enter via
blkdev_{read,write}_iter() -> blkdev_dio_invalid(). For those paths,
the segment check has no replacement.

Reproducing
----------------------------------------------------------

The trigger requires QEMU virtio-blk's specific submission shape AND
a non-io_uring submit. Userspace libaio alone, userspace
preadv-in-a-thread alone, and QEMU's raw-driver open probes (which
qemu-img info exercises identically) are all insufficient. The
combination that hits the bug is "guest-driven I/O through
virtio-blk-pci with cache.direct=on and aio in {native, threads}".

#regzbot introduced: 5ff3f74e145adc79b49668adb8de276446acf6be

Thanks,
Vjaceslavs Klimovs
