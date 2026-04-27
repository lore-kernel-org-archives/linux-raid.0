Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C71237AA88
	for <linux-raid@vger.kernel.org>; Mon, 27 Apr 2026 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777311878; cv=none; b=Jku/Kaq9NWlD43iAm5ZAd7A3zPWbR8L+oTftUzf9i84X7I6igF0CubQlP05wsEl8qJPBq8dqSd5lgQjs5L4dXqeAZxZMVy8OVzjy7xqqh6zhGSOjbE/7BLX4qnSBW1a3Ol/8mx1xQ8wOVxGLXZQRZxmKTMIabXMiL17mRkFbHYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777311878; c=relaxed/simple;
	bh=Q23bYhHL/7vStZ7nw50Qae+tU91nstFMVQEBdwOiDe8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=vF6otCYyhbtFKPQSrjiBqESmFonDYRGG/WBU+3fWnPDFzGAnRY5Q1LEF8x7K9m2ZJY7llJcsJfjP0pSNRgxlm7AyU81oaQKPfU8xAxqyec3/arLlWs/Fo7U6aETlrzVfbNhOmjW3rZVyfxZbZGtuaXC4OLHE3q40CFAM8+Lg9D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AIYIws5c; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AIYIws5c"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43d76dd4ee8so9480923f8f.2
        for <linux-raid@vger.kernel.org>; Mon, 27 Apr 2026 10:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777311874; x=1777916674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qNTXa+mqIuGkwejdo9tem0NUyOYBLXBlPSmGOAibTY0=;
        b=AIYIws5c2cwIHqx7hn+Tc7htUKo7sUliUe39zp1EbsZQbg6m8YBs0d7Amy53nrSTXv
         DugL8VDTTN8cnvMNt7XFUVRU2qnPK6BBKGggcgnVwfRoLU8Hl+zqss8h5n8Ya+PnxLM/
         d/1SUocRh4RHwYAzWs0twOYptxf9yJk3EEaWzqddSPPTDZWx+vjzH3YNLFcLcTHy7F3r
         VEDtAlQgShcRosMjHjET1qRpj5OKU1YXdRsvbHzjkkbanuUW1NG+K8AAsZha4unae/hb
         pri32wDAC05afpkPaYtW909YQMWueba0XwFGPDZ3bSmc8jUp5J2xB/yH3fPLdD9seE4M
         eCfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777311874; x=1777916674;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qNTXa+mqIuGkwejdo9tem0NUyOYBLXBlPSmGOAibTY0=;
        b=dKzdJ3Jrx7iXwOPMxueCzkaZ5FCiK0/vJRC/QOEzqWslqTfhjV/6X4pc7ePBWS3/nh
         OoR2dtfLUM2cc02D4Dcfp0NaWjHBKyYS5ib5E2NFkc7EYmn9yie917fAVBLzcDK10DIC
         7WohBa+wEFyK5fYtk0IK7Xk4VCRZplmaDNYoa/MTKTFEk5FMBwSyY08SCGg03NMmRHY1
         f6+5e9bLjoX8ZOscy5xpjmbiVAptvFfc9tActBAEgVDCzjfhkTShkX5+xoUwME7GSeYe
         bwy0s4KTTwIgvFkyvOuv/59dBoItnmPAjrL0ZF3knoazcKz6mmucXdw1ulfNJDzOCfWq
         uTQQ==
X-Forwarded-Encrypted: i=1; AFNElJ9r79Idpny5Yq14fPDhXEUafvewL5+9RHQUjc9/EMDIuhn+TPUrzOyIz5zH5Fj/gRxaOI7XB2xQy5as@vger.kernel.org
X-Gm-Message-State: AOJu0YwBqUSoSo5Yalczx1o374HuI6Bp2reoZYrX/40E10KBvblS3pVw
	8DLgy741lcDzvyymVLFWdzh49pRvSdXs84YpZViQL7mHdFwJIU14NzOK
X-Gm-Gg: AeBDieue3Up+EICVPwHQ670TP7cSjtKPmgmfRYT7MEv9TXOddwWl5zG80pQ/umxqp5X
	0kJFldqvBdvq78oTDbtWYzht0gnbjGTSn8nQTViolgd21zXGksOMQwrIoYg9q6F6ZPVIGva9YWu
	aRsKbJXq3YaTh3RZjL5QPkrBRRfCZI5izHdD+Gl6s902e8/ywbZkJNjxb9unZaqPbWHkAILmjvt
	/ZrRnbTy7zUr5ZO8zeIa75H4wQ8sMGqrfhJzVww/Qd0jv0uSZi8ehBNInGFLIma/J2MShpDA4eS
	jq6TJrk4S+nAyTcASZ+8w88U1RU53ruL2m/xJlsTwPhaQzyWkY9z2Kzp/ftr/Z0UIeWLEmYrEBI
	foVItTKMLEDZV1Ru73/+D73UbYoDa01oGXeGU0gJuv1Xrw/5/R+59V1sr921e8sLDgfmhHMbNg+
	dpbVrp7/R+MwTHMhX0roEHdhOpPzmGqDE5z+mtEu32ouu9GMPe67kOnh5oTSAI5IzLMyJwhtKe6
	u7T
X-Received: by 2002:a05:6000:26d3:b0:43f:e414:1bed with SMTP id ffacd0b85a97d-4463d219b52mr27448f8f.0.1777311874127;
        Mon, 27 Apr 2026 10:44:34 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:60f:89ae:4c2f:e07a:5958:2fb1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44639f2d534sm73715f8f.0.2026.04.27.10.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 10:44:33 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: song@kernel.org, yukuai@fnnas.com, shli@fb.com, neilb@suse.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md/raid1: fix bio splitting in raid1 thread to avoid
 recursion and deadlock
In-Reply-To: <c859ab17-cfc6-4e54-9a79-8b0d2b145adc@molgen.mpg.de>
References: <20260427103446.300378-1-abd.masalkhi@gmail.com>
 <c859ab17-cfc6-4e54-9a79-8b0d2b145adc@molgen.mpg.de>
Date: Mon, 27 Apr 2026 19:44:31 +0200
Message-ID: <m2se8g47sw.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Thank you for the feedback.

On Mon, Apr 27, 2026 at 16:49 +0200, Paul Menzel wrote:
> Dear Abd-Alrhman,
>
>
> Thank you for your patch.
>
> Am 27.04.26 um 12:34 schrieb Abd-Alrhman Masalkhi:
>> Splitting a bio while executing in the raid1 thread can lead to
>> recursion, as task->bio_list is NULL in this context.
>>=20
>> In addition, resubmitting an md_cloned_bio after splitting may lead to
>> a deadlock if the array is suspended before the md driver calls
>> percpu_ref_tryget_live(&mddev->active_io) on it's path to
>> pers->make_request().
>>=20
>> Avoid splitting the bio in this context and require that it is either
>> read in full or not at all.
>>=20
>> This prevents recursion and avoids potential deadlocks during array
>> suspension.
>
> Do you have a reproducer?

I found this issue while reviewing the code and trying to understand the
read path.

The problem can be triggered when the first rdev cannot complete the
md_cloned_bio successfully, and RAID1 selects another rdev that cannot
fulfil the entire request. In that case, raid1_read_request() will split
the bio (the md_cloned_bio) via bio_submit_split_bioset(), which in turn
calls submit_bio_noacct_nocheck(). Since current->bio_list is NULL in
this context, this leads to raid1_read_request() being called again,
resulting in recursion.

I have also created a test to confirm that this can occur by modifying
the code with the following patch:

 drivers/md/raid1.c | 52 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cc9914bd15c1..145e3ad0b1b8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -362,11 +362,34 @@ static int find_bio_disk(struct r1bio *r1_bio, struct=
 bio *bio)

 static void raid1_end_read_request(struct bio *bio)
 {
+	static int tmp =3D 75;
 	int uptodate =3D !bio->bi_status;
 	struct r1bio *r1_bio =3D bio->bi_private;
 	struct r1conf *conf =3D r1_bio->mddev->private;
 	struct md_rdev *rdev =3D conf->mirrors[r1_bio->read_disk].rdev;

+	if (tmp > 2) {
+		tmp --;
+		pr_info("--tmp =3D %d\n", tmp);
+	} else if (tmp =3D=3D 2) {
+		if (r1_bio->sectors > 2 && uptodate) {
+			pr_info("I will start omitting errors\n");
+			bio->bi_status =3D BLK_STS_IOERR;
+			uptodate =3D false;
+			tmp =3D 0;
+		}
+	} else {
+		if (r1_bio->sectors > 2) {
+			if (tmp) {
+				bio->bi_status =3D BLK_STS_IOERR;
+				uptodate =3D false;
+				tmp =3D false;
+			} else {
+				tmp =3D true;
+			}
+		}
+	}
+
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
@@ -607,7 +630,7 @@ static int choose_first_rdev(struct r1conf *conf, struc=
t r1bio *r1_bio,

 		/* choose the first disk even if it has some bad blocks. */
 		read_len =3D raid1_check_read_range(rdev, this_sector, &len);
-		if (read_len > 0) {
+		if (read_len > 0 && (!*max_sectors || read_len =3D=3D r1_bio->sectors)) {
 			update_read_sectors(conf, disk, this_sector, read_len);
 			*max_sectors =3D read_len;
 			return disk;
@@ -704,8 +727,12 @@ static int choose_slow_rdev(struct r1conf *conf, struc=
t r1bio *r1_bio,
 	}

 	if (bb_disk !=3D -1) {
-		*max_sectors =3D bb_read_len;
-		update_read_sectors(conf, bb_disk, this_sector, bb_read_len);
+		if (!*max_sectors || bb_read_len =3D=3D r1_bio->sectors) {
+			*max_sectors =3D bb_read_len;
+			update_read_sectors(conf, bb_disk, this_sector, bb_read_len);
+		} else {
+			bb_disk =3D -1;
+		}
 	}

 	return bb_disk;
@@ -884,9 +911,11 @@ static int read_balance(struct r1conf *conf, struct r1=
bio *r1_bio,
 	 * now spend a bit more time trying to find one with the most good
 	 * sectors.
 	 */
-	disk =3D choose_bb_rdev(conf, r1_bio, max_sectors);
-	if (disk >=3D 0)
-		return disk;
+	if (!*max_sectors) {
+		disk =3D choose_bb_rdev(conf, r1_bio, max_sectors);
+		if (disk >=3D 0)
+			return disk;
+	}

 	return choose_slow_rdev(conf, r1_bio, max_sectors);
 }
@@ -1320,6 +1349,11 @@ static void raid1_read_request(struct mddev *mddev, =
struct bio *bio,
 	int rdisk;
 	bool r1bio_existed =3D !!r1_bio;

+	if (mddev->thread && mddev->thread->tsk =3D=3D current) {
+		pr_info("taask->bio_list =3D %p, %d\n", current->bio_list,
+			r1bio_existed);
+	}
+
 	/*
 	 * If r1_bio is set, we are blocking the raid1d thread
 	 * so there is a tiny risk of deadlock.  So ask for
@@ -1347,6 +1381,7 @@ static void raid1_read_request(struct mddev *mddev, s=
truct bio *bio,
 	 * make_request() can abort the operation when read-ahead is being
 	 * used and no empty request is available.
 	 */
+	max_sectors =3D r1bio_existed;
 	rdisk =3D read_balance(conf, r1_bio, &max_sectors);
 	if (rdisk < 0) {
 		/* couldn't find anywhere to read from */
@@ -1376,7 +1411,12 @@ static void raid1_read_request(struct mddev *mddev, =
struct bio *bio,
 		mddev->bitmap_ops->wait_behind_writes(mddev);
 	}

+	if (r1bio_existed)
+		max_sectors =3D max_sectors - 1;
+
 	if (max_sectors < bio_sectors(bio)) {
+		/* we are not allowed  */
+		/* BUG_ON(r1bio_existed); */
 		bio =3D bio_submit_split_bioset(bio, max_sectors,
 					      &conf->bio_split);
 		if (!bio) {
--
2.43.0

using trace-cmd, it shows the recursion clearly, its output:

    raid1_read_request() {
      bio_submit_split_bioset() {
        bio_split() {
          bio_alloc_clone() {
            bio_alloc_bioset() {
              mempool_alloc_noprof() {
                __cond_resched();
                mempool_alloc_slab() {
                  kmem_cache_alloc_noprof();
                }
              }
              bio_associate_blkg() {
                __rcu_read_lock();
                kthread_blkcg();
                bio_associate_blkg_from_css() {
                  __rcu_read_lock();
                  __rcu_read_unlock();
                }
                __rcu_read_unlock();
              }
            }
            bio_clone_blkg_association() {
              bio_associate_blkg_from_css() {
                __rcu_read_lock();
                __rcu_read_unlock();
                __rcu_read_lock();
                __rcu_read_unlock();
              }
            }
          }
        }
        bio_chain();
        should_fail_bio();
        submit_bio_noacct_nocheck() {
          blk_cgroup_bio_start();
          __submit_bio() {
            __rcu_read_lock();
            __rcu_read_unlock();
            md_submit_bio() {
              bio_split_to_limits() {
                bio_split_rw() {
                  bio_split_io_at();
                  bio_submit_split();
                }
              }
              md_handle_request() {
                __rcu_read_lock();
                __rcu_read_unlock();
                raid1_make_request() {
                  raid1_read_request() {
                    _printk() {
                      vprintk() {
                        vprintk_default() {
                          vprintk_emit() {
                            panic_on_other_cpu();
                            nbcon_get_default_prio() {
                              panic_on_this_cpu();
                              nbcon_get_cpu_emergency_nesting() {
                                printk_percpu_data_ready();
                              }
                            }
                            is_printk_legacy_deferred() {
                              is_printk_cpu_sync_owner();
                            }
                            vprintk_store() {
                              local_clock();
                              printk_parse_prefix();
                              is_printk_force_console();
                              prb_reserve() {
                                data_alloc() {
                                  data_push_tail();
                                }
                                space_used.isra.0();
                              }
                              printk_sprint() {
                                printk_parse_prefix();
                              }
                              prb_final_commit() {
                                desc_update_last_finalized() {
                                  _prb_read_valid() {
                                    desc_read_finalized_seq();
                                  }
                                  _prb_read_valid() {
                                    desc_read_finalized_seq();
                                    panic_on_this_cpu();
                                  }
                                }
                              }
                            }
                            console_trylock() {
                              panic_on_other_cpu();
                              __printk_safe_enter();
                              down_trylock() {
                                _raw_spin_lock_irqsave();
                                _raw_spin_unlock_irqrestore();
                              }
                              __printk_safe_exit();
                            }
                            console_unlock() {
                              nbcon_get_default_prio() {
                                panic_on_this_cpu();
                                nbcon_get_cpu_emergency_nesting() {
                                  printk_percpu_data_ready();
                                }
                              }
                              is_printk_legacy_deferred() {
                                is_printk_cpu_sync_owner();
                              }
                              console_flush_one_record() {
                                nbcon_get_default_prio() {
                                  panic_on_this_cpu();
                                  nbcon_get_cpu_emergency_nesting() {
                                    printk_percpu_data_ready();
                                  }
                                }
                                is_printk_legacy_deferred() {
                                  is_printk_cpu_sync_owner();
                                }
                                __srcu_read_lock();
                                printk_get_next_message() {
                                  prb_read_valid() {
                                    _prb_read_valid() {
                                      desc_read_finalized_seq();
                                      get_data();
                                      desc_read_finalized_seq();
                                    }
                                  }
                                }
                                panic_on_other_cpu();
                                __srcu_read_unlock();
                              }
                              console_flush_one_record() {
                                nbcon_get_default_prio() {
                                  panic_on_this_cpu();
                                  nbcon_get_cpu_emergency_nesting() {
                                    printk_percpu_data_ready();
                                  }
                                }
                                is_printk_legacy_deferred() {
                                  is_printk_cpu_sync_owner();
                                }
                                __srcu_read_lock();
                                printk_get_next_message() {
                                  prb_read_valid() {
                                    _prb_read_valid() {
                                      desc_read_finalized_seq();
                                      panic_on_this_cpu();
                                    }
                                  }
                                }
                                __srcu_read_unlock();
                              }
                              __printk_safe_enter();
                              up() {
                                _raw_spin_lock_irqsave();
                                _raw_spin_unlock_irqrestore();
                              }
                              __printk_safe_exit();
                              prb_read_valid() {
                                _prb_read_valid() {
                                  desc_read_finalized_seq();
                                  panic_on_this_cpu();
                                }
                              }
                            }
                            __wake_up_klogd();
                          }
                        }
                      }
                    }
                    mempool_alloc_noprof() {
                      __cond_resched();
                      mempool_kmalloc() {
                        __kmalloc_noprof();
                      }
                    }
                    md_account_bio() {
                      __rcu_read_lock();
                      __rcu_read_unlock();
                      bio_alloc_clone() {
                        bio_alloc_bioset() {
                          mempool_alloc_noprof() {
                            __cond_resched();
                            mempool_alloc_slab() {
                              kmem_cache_alloc_noprof();
                            }
                          }
                          bio_associate_blkg() {
                            __rcu_read_lock();
                            kthread_blkcg();
                            bio_associate_blkg_from_css() {
                              __rcu_read_lock();
                              __rcu_read_unlock();
                            }
                            __rcu_read_unlock();
                          }
                        }
                        bio_clone_blkg_association() {
                          bio_associate_blkg_from_css() {
                            __rcu_read_lock();
                            __rcu_read_unlock();
                            __rcu_read_lock();
                            __rcu_read_unlock();
                          }
                        }
                      }
                      bio_start_io_acct() {
                        update_io_ticks();
                      }
                    }
                    bio_alloc_clone() {
                      bio_alloc_bioset() {
                        mempool_alloc_noprof() {
                          __cond_resched();
                          mempool_alloc_slab() {
                            kmem_cache_alloc_noprof();
                          }
                        }
                        bio_associate_blkg() {
                          __rcu_read_lock();
                          kthread_blkcg();
                          bio_associate_blkg_from_css() {
                            __rcu_read_lock();
                            __rcu_read_unlock();
                          }
                          __rcu_read_unlock();
                        }
                      }
                      bio_clone_blkg_association() {
                        bio_associate_blkg_from_css() {
                          __rcu_read_lock();
                          __rcu_read_unlock();
                          __rcu_read_lock();
                          __rcu_read_unlock();
                        }
                      }
                    }
                    submit_bio_noacct() {
                      __cond_resched();
                      submit_bio_noacct_nocheck() {
                        blk_cgroup_bio_start();
                      }
                    }
                  }
                }
                __rcu_read_lock();
                __rcu_read_unlock();
              }
            }
            __rcu_read_lock();
            __rcu_read_unlock();
          }
          __submit_bio() {
            blk_mq_submit_bio() {
              __rcu_read_lock();
              __rcu_read_unlock();
              bio_split_rw() {
                bio_split_io_at();
                bio_submit_split();
              }
              blk_attempt_plug_merge();
              blk_mq_sched_bio_merge();
              __blk_mq_alloc_requests() {
                blk_mq_get_tag() {
                  __blk_mq_get_tag();
                }
                blk_mq_rq_ctx_init.isra.0();
              }
              ktime_get();
              update_io_ticks();
              blk_add_rq_to_plug();
            }
          }
        }
      }
      bio_alloc_clone() {
        bio_alloc_bioset() {
          mempool_alloc_noprof() {
            __cond_resched();
            mempool_alloc_slab() {
              kmem_cache_alloc_noprof() {
                __slab_alloc.isra.0() {
                  ___slab_alloc();
                }
              }
            }
          }
          bio_associate_blkg() {
            __rcu_read_lock();
            kthread_blkcg();
            bio_associate_blkg_from_css() {
              __rcu_read_lock();
              __rcu_read_unlock();
            }
            __rcu_read_unlock();
          }
        }
        bio_clone_blkg_association() {
          bio_associate_blkg_from_css() {
            __rcu_read_lock();
            __rcu_read_unlock();
            __rcu_read_lock();
            __rcu_read_unlock();
          }
        }
      }
      submit_bio_noacct() {
        __cond_resched();
        submit_bio_noacct_nocheck() {
          blk_cgroup_bio_start();
          __submit_bio() {
            blk_mq_submit_bio() {
              __rcu_read_lock();
              __rcu_read_unlock();
              bio_split_rw() {
                bio_split_io_at();
                bio_submit_split();
              }
              blk_attempt_plug_merge();
              blk_mq_sched_bio_merge();
              __blk_mq_alloc_requests() {
                blk_mq_get_tag() {
                  __blk_mq_get_tag();
                }
                blk_mq_rq_ctx_init.isra.0();
              }
              update_io_ticks() {
                bdev_count_inflight();
              }
              blk_add_rq_to_plug();
            }
          }
        }
      }
    }

>
>> Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>> I sent an email about this issue two days ago, but at the time I was not
>> sure whether it was a real problem or a misunderstanding on my part.
>>=20
>> After further analysis, it appears that this issue can occur.
>>=20
>> Apologies for the earlier confusion, and thank you for your time.
>>=20
>> Abd-Alrhman
>
> I suggest to always share the URL (lore.kernel.org), when referencing=20
> another thread. If relevant, maybe even reference your message with a=20
> Link: tag in the commit message.

Yes, i will make sure to do that next time. Here is the link:
https://lore.kernel.org/linux-raid/20260425142938.5555-1-abd.masalkhi@gmail=
.com/T

>
>> ---
>>   drivers/md/raid1.c | 33 ++++++++++++++++++++++++---------
>>   1 file changed, 24 insertions(+), 9 deletions(-)
>>=20
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index cc9914bd15c1..14f6d6625811 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -607,7 +607,7 @@ static int choose_first_rdev(struct r1conf *conf, st=
ruct r1bio *r1_bio,
>>=20=20=20
>>   		/* choose the first disk even if it has some bad blocks. */
>>   		read_len =3D raid1_check_read_range(rdev, this_sector, &len);
>> -		if (read_len > 0) {
>> +		if (read_len > 0 && (!*max_sectors || read_len =3D=3D r1_bio->sectors=
)) {
>>   			update_read_sectors(conf, disk, this_sector, read_len);
>>   			*max_sectors =3D read_len;
>>   			return disk;
>> @@ -704,8 +704,13 @@ static int choose_slow_rdev(struct r1conf *conf, st=
ruct r1bio *r1_bio,
>>   	}
>>=20=20=20
>>   	if (bb_disk !=3D -1) {
>> -		*max_sectors =3D bb_read_len;
>> -		update_read_sectors(conf, bb_disk, this_sector, bb_read_len);
>> +		if (!*max_sectors || bb_read_len =3D=3D r1_bio->sectors) {
>> +			*max_sectors =3D bb_read_len;
>> +			update_read_sectors(conf, bb_disk, this_sector,
>> +					    bb_read_len);
>> +		} else {
>> +			bb_disk =3D -1;
>> +		}
>>   	}
>>=20=20=20
>>   	return bb_disk;
>> @@ -852,8 +857,9 @@ static int choose_best_rdev(struct r1conf *conf, str=
uct r1bio *r1_bio)
>>    * disks and disks with bad blocks for now. Only pay attention to key =
disk
>>    * choice.
>>    *
>> - * 3) If we've made it this far, now look for disks with bad blocks and=
 choose
>> - * the one with most number of sectors.
>> + * 3) If we've made it this far and *max_sectors is 0 (i.e., we are tol=
erant
>> + * of bad blocks), look for disks with bad blocks and choose the one wi=
th
>> + * the most sectors.
>>    *
>>    * 4) If we are all the way at the end, we have no choice but to use a=
 disk even
>>    * if it is write mostly.
>> @@ -882,11 +888,13 @@ static int read_balance(struct r1conf *conf, struc=
t r1bio *r1_bio,
>>   	/*
>>   	 * If we are here it means we didn't find a perfectly good disk so
>>   	 * now spend a bit more time trying to find one with the most good
>> -	 * sectors.
>> +	 * sectors. but only if we are tolerant of bad blocks.
>
> s/but/But/
>

I will fix this in v2.

>>   	 */
>> -	disk =3D choose_bb_rdev(conf, r1_bio, max_sectors);
>> -	if (disk >=3D 0)
>> -		return disk;
>> +	if (!*max_sectors) {
>> +		disk =3D choose_bb_rdev(conf, r1_bio, max_sectors);
>> +		if (disk >=3D 0)
>> +			return disk;
>> +	}
>>=20=20=20
>>   	return choose_slow_rdev(conf, r1_bio, max_sectors);
>>   }
>> @@ -1346,7 +1354,14 @@ static void raid1_read_request(struct mddev *mdde=
v, struct bio *bio,
>>   	/*
>>   	 * make_request() can abort the operation when read-ahead is being
>>   	 * used and no empty request is available.
>> +	 *
>> +	 * If we allow splitting the bio while executing in the raid1 thread,
>> +	 * we may end up recursing (current->bio_list is NULL), and we might
>> +	 * also deadlock if we try to suspend the array, since we are
>> +	 * resubmitting an md_cloned_bio. Therefore, we must be read either
>
> =E2=80=A6 we must read =E2=80=A6
>

I will fix this in v2.

>> +	 * all the sectors or none.
>>   	 */
>> +	max_sectors =3D r1bio_existed;
>
> Excuse my ignorance, but I do not get why a bool is assigned to an int=20
> representing the maximum sector value.
>

I modified read_balance() to interpret *max_sectors as a flag. If it is
0, the read path is allowed to be tolerant of bad blocks; otherwise, it
is not. In both cases, *max_sectors will eventually be updated to the
maximum number of readable sectors if a suitable disk is found.

I used r1bio_existed to initialize this value, so assigning
max_sectors =3D r1bio_existed effectively encodes this behavior
without introducing an additional parameter.

>>   	rdisk =3D read_balance(conf, r1_bio, &max_sectors);
>>   	if (rdisk < 0) {
>>   		/* couldn't find anywhere to read from */
>
>
> Kind regards,
>
> Paul

--=20
Best Regards,
Abd-Alrhman
