Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B6F322C99
	for <linux-raid@vger.kernel.org>; Wed, 14 Jan 2026 17:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413159; cv=none; b=X4EzDUmarROiJlveabAJXOysAcIAA2sFL4tpXJlOvr5oon6F+z7Lo1UCgBuXpeDDQ+cV77Q5dpBdeDgSnaV/7/eitOCGHsLPsl3FAvYY+SV3Wl6NlDpASVE1VAHnuiYwQd3+vJzKu8Dmz64fXOGtRDDtF0QiIOROBPBnKPjOY1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413159; c=relaxed/simple;
	bh=SJfQ5Tdoad6rUP6mZDomyfdqFY9JacOhhqOpMvtFNLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Jye9z85aZV9DBJSJnocSuqAeg7X1kP0GDpZI5uWDy3IQhk/Zof0Yt6uE/CJzTMCAw1mbPZWxgWk4KUTexbrY8pgzXIrOTwUlUqZcXAzzLUIBZ5oTiyBfefZNdzogOODQ0dAm06P1P29s6VzVk3O/eLNMREzfevDUrQPUSL8GE8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DHjBNEBJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=K0OvKyq0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DHjBNEBJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="K0OvKyq0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768413156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=amQJm20oQtyM7MnBOJaV9Q05XRO6NU/lkJ86ga0OdEM=;
	b=DHjBNEBJdALuVCYTR6NOQgHdRDB83GrAHusrmAA0akZAuX1uuWYvIHGS/wRsdCAeUttEU9
	1SFRLIJnNvcRIbUVYfScZKSO02iwmfENcWU308yryboVfxv3BchDKp26SzOh9yHHcnU4G6
	521g0A/PIve5N5hJCOl7iELgmqlsDMo=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-XpuCOJgqMOSeSStnB7O_Tw-1; Wed, 14 Jan 2026 12:52:35 -0500
X-MC-Unique: XpuCOJgqMOSeSStnB7O_Tw-1
X-Mimecast-MFC-AGG-ID: XpuCOJgqMOSeSStnB7O_Tw_1768413155
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-5eea4536b99so120797137.1
        for <linux-raid@vger.kernel.org>; Wed, 14 Jan 2026 09:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768413155; x=1769017955; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=amQJm20oQtyM7MnBOJaV9Q05XRO6NU/lkJ86ga0OdEM=;
        b=K0OvKyq0mXnkysCbjFieTBpG7zLr76yrp9YGPY+gn5eUYBD/CGFnn5SaBXdzpJmSpJ
         aBVpjeXuWZUjH8zp9rw6q0VGYNMePaSfIwVR7ELrr44xJICYtmu0j/59MDgST1khPTVG
         y3LujCroVCnfdAMJ7TjXtuZNoyylT9dO09Dl1lk0ggcfgDMgZ3eh18Y6SiIM1kO0gXPg
         9lXo43YMDddGTVKxcC816+kWI0Oc1JIOC3NQAMDI3Racpo7wPT9MOLd6XBFVM3MnfZmF
         P917JB4sC9l/QUgufBlHGRAuM3jfyiDjAaPF1UfbHe2G/nFD0RyqzINS82FHBHEy+aFx
         XdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768413155; x=1769017955;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=amQJm20oQtyM7MnBOJaV9Q05XRO6NU/lkJ86ga0OdEM=;
        b=htSIEml2dmOF6SdQ8FJmQ3JK4Lj2SGOZAXytTPhKhNfoBv7cbc7pQ2dYBUWaRnGPRR
         FVkUhu2naeuOQw3NiFS7qMKkLLZxIad/+rhO6fwF1UFguzDHSy9I9fMkMvD4KWoSKgq+
         sNyIW0++mWNFSIk7Xdar4famFR0/VnkL+zyys2FN7/rbM5KUAJ1dveDLNw88+eX8uApa
         jRs1v8cHnfddMyRmsysIPUmAm8M0z3hmUPlJrBU3gFHGDwXDq+jJonv+nTQR8ho9aG1Z
         /zR/5H9hfyKT/ekM8p7kmuyVEl/U4lOls8JwvBRv67NQb/0A471VgxaVMJIRtQ/eD9nS
         rVRg==
X-Gm-Message-State: AOJu0YwJz3XkkWXqhJCrLtIH3qhTSr0kNsjkigeHgA0oR9VkEUMxbJw+
	fSlVQXFzw1rnMnk2dGU762O9kBmhXWCq7ICiUfeFylwuHbb0PCcQt/2VYyPz+2JOp+a+DUxDxNK
	Wwy/t2ll0p1bNQqLf0vZ0hsblj+Z1KKC5WWlE7X7kVay2oKOJbCdbVDHkQjX4Ec0q6hXGKRQb3f
	q89UhLVk8HLgvvzVuQSy/ievoViXFMQ8sjhC8MUJi7nr6MRg==
X-Gm-Gg: AY/fxX63HBnaBPG36pT2ych98rqU3A1w10zZiZ+JJRj0eVnMwnJF74ZoSOVm6qJL74x
	+TwdGvRvqCyq4DD6TQ03tCy+OkI/1rgCTMDXulVQD+ZLiV2/u/T0n/X5ni6fHT2Gct9FjrVFGE7
	4NbsSZ+r4BPugUG3U7JfhXi0/GwG1Po40Gk3K90prXAFdPG20NPHJ1SwnAVY3fV0pM
X-Received: by 2002:a05:6102:5817:b0:5f0:ab9c:12ac with SMTP id ada2fe7eead31-5f183b87a51mr1293892137.25.1768413153265;
        Wed, 14 Jan 2026 09:52:33 -0800 (PST)
X-Received: by 2002:a05:6102:5817:b0:5f0:ab9c:12ac with SMTP id
 ada2fe7eead31-5f183b87a51mr1293881137.25.1768413152801; Wed, 14 Jan 2026
 09:52:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <414ae6e0-604a-f4d3-d7ce-260bd8564927@huaweicloud.com> <d4bab4c8921eaecae856447131c4f4f1aa190dd3.1758631268.git.heinzm@redhat.com>
In-Reply-To: <d4bab4c8921eaecae856447131c4f4f1aa190dd3.1758631268.git.heinzm@redhat.com>
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Wed, 14 Jan 2026 18:52:21 +0100
X-Gm-Features: AZwV_Qhwmn1FVMyZsbklbWyJf6kdmcBblP73YsgJO-drWt92HwInkQQ0UjXRFS0
Message-ID: <CAM23VxqYrwkhKEBeQrZeZwQudbiNey2_8B_SEOLqug=pXxaFrA@mail.gmail.com>
Subject: Fwd: [PATCH V2] md raid: fix hang when stopping arrays with metadata
 through dm-raid
To: linux-raid <linux-raid@vger.kernel.org>, Linux-Kernel <linux-kernel@vger.kernel.org>, 
	Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Resending, as it seems to have gotten lost.

---------- Forwarded message ---------
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Tue, Sep 23, 2025 at 2:58=E2=80=AFPM
Subject: [PATCH V2] md raid: fix hang when stopping arrays with
metadata through dm-raid
To: <yukuai1@huaweicloud.com>, <song@kernel.org>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
Heinz Mauelshagen <heinzm@redhat.com>


When using device-mapper's dm-raid target, stopping a RAID array can cause =
the
system to hang under specific conditions.

This occurs when:

- A dm-raid managed device tree is suspended from top to bottom
   (the top-level RAID device is suspended first, followed by its
    underlying metadata and data devices)

- The top-level RAID device is then removed

Removing the top-level device triggers a hang in the following
sequence: the dm-raid
destructor calls md_stop(), which tries to flush the write-intent
bitmap by writing
to the metadata sub-devices. However, these devices are already
suspended, making
them unable to complete the write operations and causing an indefinite bloc=
k.

Fix:

- Prevent bitmap flushing when md_stop() is called from dm-raid
destructor context
  and avoid a quiescing/unquescing cycle which could also cause I/O

- Still allow write-intent bitmap flushing when called from dm-raid
suspend context

This ensures that RAID array teardown can complete successfully even when t=
he
underlying devices are in a suspended state.

This second patch uses md_is_rdwr() to distinguish between suspend and
destructor paths as elaborated on above.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/md.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e033c26fdd4..78408d2f78fc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6541,12 +6541,14 @@ static void __md_stop_writes(struct mddev *mddev)
 {
        timer_delete_sync(&mddev->safemode_timer);

-       if (mddev->pers && mddev->pers->quiesce) {
-               mddev->pers->quiesce(mddev, 1);
-               mddev->pers->quiesce(mddev, 0);
-       }
+       if (md_is_rdwr(mddev) || !mddev_is_dm(mddev)) {
+               if (mddev->pers && mddev->pers->quiesce) {
+                       mddev->pers->quiesce(mddev, 1);
+                       mddev->pers->quiesce(mddev, 0);
+               }

-       mddev->bitmap_ops->flush(mddev);
+               mddev->bitmap_ops->flush(mddev);
+       }

        if (md_is_rdwr(mddev) &&
            ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
--
2.51.0

