Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B29C48E0FE
	for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2026 08:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789634318; cv=none; b=aIPGjFiK1WRArRmADd5F04BSURVi4XiD3IMxpxz1Gs9FloLE2QhGny/5YHrHt4wDT5F6dkfX98qtnjZwKTpwuEXKf9/cvFKzULGHO19yX/2ejNT7te7QkrbPXhJkCF5bMlyUXNDzVKJQgGHA9pgvODBamTAL38idCT5s3eQludY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789634318; c=relaxed/simple;
	bh=k1GXYY6A7y0hQF32K0VwcwBXakkSSyzeWdLnCM6RKV8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iBbzx85jkTa95j7+UXyN/ajz2bquTtFAjoN2bemYPoHOxP35K5JyU7Fdx8y1ax1V4lLEGhZ98N7cP6jw08a6EtDGmuD7nxoRLpNqvlx1iFjhRj656AGIqdlHqHpmdLEem/KEtKweOOQsHp+Cj/qrR76qMf6jj47z78tjLenTecc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G+0HqudH; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+0HqudH"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccb65437so420585a91.3
        for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2026 01:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789634310; x=1790239110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u3HdJDUDcBvt28oPFTrWwWmgVt/98a4ZJvXsfBuXjA8=;
        b=G+0HqudHOtBZnJMs/74IJOorP8EzP5UnSzvuY7eYderUpdjSFlQBGWY4tnZCdCSlEn
         lWY5V79PJWf9IGGc7bLo0db+9KAMMernvGA073By7zRTBAUE/dbYYc2f9RTbEHDIACuB
         3f2873isAtM2z7r4tHf3ENQCyv3PXveWXtiQMVGJlE1oByskw12ovhH2YjptgrsRjanQ
         yXombypdiBp/i/37+tWnEXn6PujETBU/pTSnvSLTrHdm0HzvI0jGJrCrZciANnjkqL4V
         ue2IlIZXFtwmhiFZjqa74FtsjC78gXpgdRNXLB+WLdOrymWo8lUEaCzcRaYInq5ssG4c
         cppQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789634310; x=1790239110;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u3HdJDUDcBvt28oPFTrWwWmgVt/98a4ZJvXsfBuXjA8=;
        b=SfvCeJ/h4Gro/tCU01LEVQ43tkz4dBAEsPmIFb5ua/9IcmHOtAyKeoLTpbtSNlQ1nn
         HHPwq9sgwFPB+Y2gtW2PETIcGyduZ184s7TWfpZRs6c1hhw6+zuJ7MNAFIr71FSaxkqB
         vQezh2OsDGAgD4yMwiL9e1V92Obitb0aYRnf2F2y8j8n2SdxWLlnBciqnKxLK5SsLB1v
         zEW8dMTuKUdlUlFzgbyZ0eVT1bkZmT0TY6ECG3o6nYmELP21gO6C4aue9rfOraoFIrJC
         wmsx5EffQ1eOE9bfVAGLORQjHjtM0CGledTZAH48vSw373Yz/WGKa/4GGF6WjFtkKDQi
         KFlw==
X-Forwarded-Encrypted: i=1; AKwUvBws29+OJkhjIruI7SO4z+ICoUxRSWVyai37Is0Y2n6ewr3hMF0pQjedRYJGFRdYtwR3hH5UF5rkNDjd@vger.kernel.org
X-Gm-Message-State: AFuF++mpd5HjJ1qqKx2tmem6ifBj4pRoC1HPrvyncQ9gJWzst/y6CfMo
	sg6Qm3tBzdvkAjwNhQe3yzmE6MH2EwigG7s4391pCp5zEj2ebpIbYE82
X-Gm-Gg: AYBFou3hbVsptbQQqxpvryjCmhu+4w6VGrl9pfwh59M/3nedPAIIeQmCUprsCZ+cHMa
	nlUb0J2CdMVrPn/uI36JsSxLgZsbh8Q9Xd9hRh88I5lAg0vFCR1u1n2RvnbpBztSa1jc/Jp3MFA
	JopD+yzMpM72Jh2ptAbzAAh/wbxHfCCKYGj46UKsdaxQKLyvZl04nqiYbWI+vxM/5ygVZ/qAJ93
	MMtJsk2E4MMOVbXgNzgU/bNpGVBHYPlUtfq3D+p0MhzSbEwWjMRpMZX6RNZ1yVVsSH/3modInXr
	3CdVryGdGzelWhhMze+rDScgIXeCnPX+67KT7PlkH8RCNUBRfvt/lsm9PBarl69c9/OxXnU3u45
	DIckwyvQUjsFjY+zo0B0QvTjVPHRVcFVOFbbRUdAtyXfhS7lK6Y7fs3rRpcCj93FFtzStYmxITU
	MchKN6nq4DkH/Nwr1SXRHwQ6/gAYQPVBlabGGmLyQKPZlNEYVLZ8ncaiXgMIG0xVytvi8Y4pdL8
	winozXyPqxmN8fZf1+PgGOPzkPY
X-Received: by 2002:a17:90b:2585:b0:39d:f351:8f0c with SMTP id 98e67ed59e1d1-39e1e48b580mr12652726a91.13.1789634309950;
        Thu, 17 Sep 2026 01:38:29 -0700 (PDT)
Received: from localhost.localdomain ([183.194.144.114])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35e56298sm3871317a91.9.2026.09.17.01.38.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 17 Sep 2026 01:38:29 -0700 (PDT)
From: zjamg <ndaugoing@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	NeilBrown <neil@brown.name>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zjamg <ndaugoing@gmail.com>
Subject: [PATCH 0/2] md: fix bblog_size-driven OOB read in md_write_metadata()
Date: Thu, 17 Sep 2026 16:38:18 +0800
Message-ID: <20260917083820.57091-1-ndaugoing@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series fixes an out-of-bounds read in the md badblocks log (bblog)
write path. The on-disk bblog_size field is taken verbatim from the
member device superblock and used as the bio length in
md_write_metadata(), without any check against the size of the page that
actually backs the write.

This is a different issue from CVE-2026-89557, which fixed the
bblog_shift overflow. The bblog_size path is still unfixed.

Introduced by commit 2699b67223ac ("md: load/store badblock list from v1.x metadata").

Mechanism:

  super_1_load() reads sb->bblog_size (__le16) from the member device
  and stores it in rdev->badblocks.size via super_1_sync() (md.c:2316).
  md_update_sb() then calls

      md_write_metadata(mddev, rdev, rdev->badblocks.sector,
                        rdev->badblocks.size << 9, rdev->bb_page, 0);

  (md.c:2944-2948). bb->size is sector_t, so 0xFFFF << 9 = 33553920
  does not wrap. md_write_metadata() passes that length to
  __bio_add_page() with a single 4 KiB page:

      __bio_add_page(bio, page, size, 0)

  __bio_add_page() is the no-check variant: after a WARN_ON_ONCE() it
  unconditionally records bvec_set_page(page, size, offset) and bumps
  bi_size/bi_vcnt. bio_full()'s second clause is
  "bi_size > BIO_MAX_SIZE - len", with bi_size == 0 and
  BIO_MAX_SIZE == UINT_MAX, so it is false and not even the WARN fires.
  The 4 KiB page is recorded as a bvec with bv_len == 33553920.

Downstream bvec iteration (nth_page, bio_split_to_limits, etc.) then
reads past the end of the page, into whatever follows in the linear
map. KASAN reports slab-out-of-bounds or slab-use-after-free, and the
data is written to the attacker-controlled member device.

Reproducer (CONTROL/ATTACK, only bblog_size differs):

  CONTROL bblog_size = 8      -> 4096 bytes land, out-of-range stays
                                 at the fill pattern
  ATTACK  bblog_size = 0xFFFF -> 33553920 bytes land, KASAN reports
                                 slab-out-of-bounds in
                                 copy_folio_from_iter_atomic(), and
                                 ~33.5 MB of kernel memory is copied
                                 into the member device image

The harness creates the on-disk superblock by hand, attaches the loop
device, binds it to a new md array via sysfs, adds one bad block, and
then writes "writemostly" to the member state attribute to force an
md_update_sb(). Both runs share the same kernel, the same md module and
the same code path; the only difference is the bblog_size field in the
on-disk superblock.

Patch 1 adds an upper bound for bb->size in super_1_sync(), matching
the existing guard in super_1_load().

Patch 2 is a defensive check in md_write_metadata() itself, so that
any future caller that passes an oversized length is caught before the
bio is built. Only one of the two is strictly needed to fix the
immediate issue; I'm sending both because the checks cover different
layers.

I can send the harness and full dmesg logs if useful.

Thanks.


zjamg (2):
  md: fix bblog_size-driven OOB read in super_1_load() and
    super_1_sync()
  md: add defensive bounds check for bio in md_write_metadata()

 drivers/md/md.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

-- 
2.53.0

