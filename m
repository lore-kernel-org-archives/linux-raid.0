Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927623B7760
	for <linux-raid@vger.kernel.org>; Wed, 17 Jun 2026 06:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781679588; cv=none; b=eVvL9ph1sZZ8naRUgxSaQyHbbye/TwnGExG+wkMQbcYWMlvmH2kB148hbVNrnaXUSUJVuFTJ46BCQ40Pi0mimU5NE1Vdiaxbjdrqv0RRuvcLbDCxGsVR4OJSRMKzhke9D7fkydotuqKbA0NLN2vPmZv2IvHM8v+OERN+4arKYhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781679588; c=relaxed/simple;
	bh=YzBiqBzb2nTJ2EBToPrJgox6Uy4MJa0HrtWAZQdC488=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=O96inxCqphIc4+FAe61RxyQ0Ld2DxpihYQ4F90vELEL+f+ZDcb6cEUHvCOYcpXKeIeuPkolKTkhw6b/rF8m6mXm9HaH641LTZ1QZ5j1LaIptU38hlydB8l6sYFChlTdk7rCWegxPBbBnnVLIDmGVs2+cNzyDo4uklx4jgHI963Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SO8BchZa; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SO8BchZa"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5176bbb9384so59644691cf.1
        for <linux-raid@vger.kernel.org>; Tue, 16 Jun 2026 23:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781679586; x=1782284386; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0hidjbTjNNzvVMGh2B5LjYCPzQcAqorBBjg1StmO4hc=;
        b=SO8BchZaOfK45Rs+W5pJ5k+1VgDjO5LIYZ2H9iBdGRYgJ0jf7Ke7o7h+AFjlWiv20Q
         4xan03mQS4OFhnImxw6G5hrac3DkdPprlKoI/ZuMLNsPxhqQH5tSqbCj/j+ExblaOfOh
         RYxudH7PrTnVKDk8TdzH/em/x7EHYLAEWhxF5J/6TAnJlQBCUS+RJ1S6NoA+hRu3b3F/
         L/qkOASR6mwc+boiu4OyyWgGqgtZRoFKVQDooASiskKD3lLC/4i/yWnZ1DACZI3l/sph
         WT0JR3Hx410X0Ecq6u6hj1YVM8UV7mvTURM0yL6n+JA9iZCKvnz09pXL4r8XaGqCS4JD
         U4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781679586; x=1782284386;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0hidjbTjNNzvVMGh2B5LjYCPzQcAqorBBjg1StmO4hc=;
        b=QyYSa0U+AhTclq+t3lmr5V8nXXbv92MvopDJ3qAZFegf1naGWYXByRfH1O/lgOXLPS
         Ikp+7/LkG5A0jAUzB2nXTRV3zEIxNUWt4OobDDT3LuXdShgcsScQJAOZsf602OR4nw37
         HUdVilpwtp8lCfwF97U4liq6j7O93IRTQRQylTbWG7+2abpwBt+HvnMVNxsWdzTwMfau
         FdhWaBBpgmgLvFQHRTAOgwqKFVpOyVbceYj6CwLUbRR4bjJ0fNINiRH/Vkh23I0XPTYq
         Qic5jOG46gRUjsiYa96XRrgSvl8Aw+GI0XCSVNYdO/88F9KPwBLOi6M8SFIMUXo6Ju6i
         UD3w==
X-Gm-Message-State: AOJu0YwX8+wiq/1Pi5g2AvtDZmsBTbi+/moE3RT9vbrSBGJFaRPd3O6/
	0MPttcNEuAXUgsGZB5tVoulFMVY+DoJV4F2PgvT8PRd0BPRdd+xFvGdD
X-Gm-Gg: Acq92OE5mub+II+ageJZ/CDYWmyGp9D4TrR6YZnhoaBm546VLpARFjtBKp5sb0WAKFB
	dY6kMChduX5TR7m6WCnclLdrgo0F0Y7uPetnJ1r7qQ3em8MztxaFcVbQm2H7hoVmuqq1Xo9Du8h
	tBHgc3q618HJaxWLfUtNCDFcy3Meost/lwr07Fm6N9cThLmrEe3FKWrHYgtdmqewc/ragY2v8Dt
	iBuJR6zWHbtbYkmCEQcIvvLHpG+/UBFs2rDrFDCl3z88Z3gzQB5yMR9vWGuh7LMZV0VpnVCEWFi
	QMbfyrmSEnopeE/bk84UWLEKi5Cmp+OWSllPlLdIO3vP4IL6RBhAsy8NdBVszrP/ijL+4/91UEB
	VAlbII/U05ECLc+6z7huwruejmAIA+dyHUgLmnyh4s+3/zwJZcJq86rj83A5vnbQqdToiRpkwSu
	Qn70fzMw==
X-Received: by 2002:a05:622a:450d:b0:517:577a:76f2 with SMTP id d75a77b69052e-519a902c90emr31933751cf.54.1781679586480;
        Tue, 16 Jun 2026 23:59:46 -0700 (PDT)
Received: from localhost ([43.225.189.75])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8d9f18f31d7sm57413796d6.12.2026.06.16.23.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 23:59:45 -0700 (PDT)
Date: Wed, 17 Jun 2026 09:59:39 +0300
From: Dan Carpenter <error27@gmail.com>
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
Subject: [bug report] raid5-ppl: PPL support for disks with write-back cache
 enabled
Message-ID: <ajJF2wKYWRk4GGCK@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This code is nine years old, so what I like to do is add it to the KTODO
in case anyone wants to fix it.

KTODO: Fix use after free in ppl_do_flush()

Hello Tomasz Majchrzak,

Commit 1532d9e87e8b ("raid5-ppl: PPL support for disks with
write-back cache enabled") from Dec 27, 2017 (linux-next), leads to
the following Smatch static checker warning:

	drivers/md/raid5-ppl.c:646 ppl_do_flush()
	warn: 'io' was already freed. (line 647)

drivers/md/raid5-ppl.c
    608 static void ppl_do_flush(struct ppl_io_unit *io)
    609 {
    610         struct ppl_log *log = io->log;
    611         struct ppl_conf *ppl_conf = log->ppl_conf;
    612         struct r5conf *conf = ppl_conf->mddev->private;
    613         int raid_disks = conf->raid_disks;
    614         int flushed_disks = 0;
    615         int i;
    616 
    617         atomic_set(&io->pending_flushes, raid_disks);
    618 
    619         for_each_set_bit(i, &log->disk_flush_bitmap, raid_disks) {
    620                 struct md_rdev *rdev;
    621                 struct block_device *bdev = NULL;
    622 
    623                 rdev = conf->disks[i].rdev;
    624                 if (rdev && !test_bit(Faulty, &rdev->flags))
    625                         bdev = rdev->bdev;
    626 
    627                 if (bdev) {
    628                         struct bio *bio;
    629 
    630                         bio = bio_alloc_bioset(bdev, 0,
    631                                                REQ_OP_WRITE | REQ_PREFLUSH,
    632                                                GFP_NOIO, &ppl_conf->flush_bs);
    633                         bio->bi_private = io;
    634                         bio->bi_end_io = ppl_flush_endio;
    635 
    636                         pr_debug("%s: dev: %ps\n", __func__, bio->bi_bdev);
    637 
    638                         submit_bio(bio);
    639                         flushed_disks++;
    640                 }
    641         }
    642 
    643         log->disk_flush_bitmap = 0;
    644 
    645         for (i = flushed_disks ; i < raid_disks; i++) {
--> 646                 if (atomic_dec_and_test(&io->pending_flushes))
    647                         ppl_io_unit_finished(io);

The ppl_io_unit_finished() function frees "io" so probably there is
supposed to be a statement after it.  The atomic_dec_and_test() will
underflow on subsequent iterations through the loop which is normally
harmless.  We may want to convert this to refcount_t so that any
underflows cause a WARN().


    648         }
    649 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
