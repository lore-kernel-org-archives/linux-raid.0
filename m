From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Wed, 14 Dec 2016 13:13:27 +0100
Message-ID: <CAMGffE=KoVdoYRzkHdRMuCopjmUdcrP9-woFFr-4-VszGsSHRQ@mail.gmail.com>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
 <87a8c20xpg.fsf@notabene.neil.brown.name> <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com>
 <87oa0gzuej.fsf@notabene.neil.brown.name> <CAMGffEm4BDhKJSiDt=2WmxrpRutg862at7JP221gMi6_SpPomQ@mail.gmail.com>
 <877f73zd5d.fsf@notabene.neil.brown.name> <CAMGffEnCesgUp4gBsPN2L9qg3WSxNXsCcYEPWH-BaeEEktaqcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1134e1e2e50b5305439d44f4
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGffEnCesgUp4gBsPN2L9qg3WSxNXsCcYEPWH-BaeEEktaqcw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

--001a1134e1e2e50b5305439d44f4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 14, 2016 at 11:22 AM, Jinpu Wang
<jinpu.wang@profitbricks.com> wrote:
> Thanks Neil,
>
> On Tue, Dec 13, 2016 at 11:18 PM, NeilBrown <neilb@suse.com> wrote:
>> On Wed, Dec 14 2016, Jinpu Wang wrote:
>>
>>>
>>> As you suggested, I re-run same test with 4.4.36 with no our own patch =
on MD.
>>> I can still reproduce the same bug, nr_pending on heathy leg(loop1) is =
till 1.
>>>
>>
>> Thanks.
>>
>> I have an hypothesis.
>>
>> md_make_request() calls blk_queue_split().
>> If that does split the request it will call generic_make_request()
>> on the first half. That will call back into md_make_request() and
>> raid1_make_request() which will submit requests to the underlying
>> devices.  These will get caught on the bio_list_on_stack queue in
>> generic_make_request().
>> This is a queue which is not accounted in nr_queued.
>>
>> When blk_queue_split() completes, 'bio' will be the second half of the
>> bio.
>> This enters raid1_make_request() and by this time the array have been
>> frozen.
>> So wait_barrier() has to wait for pending requests to complete, and that
>> includes the one that it stuck in bio_list_on_stack, which will never
>> complete now.
>>
>> To see if this might be happening, please change the
>>
>>         blk_queue_split(q, &bio, q->bio_split);
>>
>> call in md_make_request() to
>>
>>         struct bio *tmp =3D bio;
>>         blk_queue_split(q, &bio, q->bio_split);
>>         WARN_ON_ONCE(bio !=3D tmp);
>>
>> If that ever triggers, then the above is a real possibility.
>
> I triggered the warning as you expected, we can confirm the bug was
> caused by your above hypothesis.
> [  429.282235] ------------[ cut here ]------------
> [  429.282407] WARNING: CPU: 2 PID: 4139 at drivers/md/md.c:262
> md_set_array_sectors+0xac0/0xc30 [md_mod]()
> [  429.285288] Modules linked in: raid1 ibnbd_client(O)
> ibtrs_client(O) dm_service_time dm_multipath rdma_ucm ib_ucm rdma_cm
> iw_cm ib_ipoib ib_cm ib_uverbs ib_umad mlx5_ib mlx5_c
> ore vxlan ip6_udp_tunnel udp_tunnel mlx4_ib ib_sa ib_mad ib_core
> ib_addr ib_netlink mlx4_core mlx_compat loop md_mod kvm_amd
> edac_mce_amd kvm edac_core irqbypass acpi_cpufreq tpm
> _infineon tpm_tis i2c_piix4 tpm serio_raw evdev k10temp processor
> button fam15h_power crct10dif_pclmul crc32_pclmul sg sd_mod ahci
> libahci libata scsi_mod crc32c_intel r8169 psmo
> use xhci_pci xhci_hcd [last unloaded: mlx_compat]
> [  429.288543] CPU: 2 PID: 4139 Comm: fio Tainted: G           O    4.4.3=
6-1-pse
> rver #1
> [  429.288825] Hardware name: To be filled by O.E.M. To be filled by
> O.E.M./M5A97 R2.0, BIOS 2501 04/07/2014
> [  429.289113]  0000000000000000 ffff8801f64ff8f0 ffffffff81424486
> 0000000000000000
> [  429.289538]  ffffffffa0561938 ffff8801f64ff928 ffffffff81058a60
> ffff8800b8f3e000
> [  429.290157]  0000000000000000 ffff8800b51f4100 ffff880234f9a700
> ffff880234f9a700
> [  429.290594] Call Trace:
> [  429.290743]  [<ffffffff81424486>] dump_stack+0x4d/0x67
> [  429.290893]  [<ffffffff81058a60>] warn_slowpath_common+0x90/0xd0
> [  429.291046]  [<ffffffff81058b55>] warn_slowpath_null+0x15/0x20
> [  429.291202]  [<ffffffffa0550740>] md_set_array_sectors+0xac0/0xc30 [md=
_mod]
> [  429.291358]  [<ffffffff813fd3de>] generic_make_request+0xfe/0x1e0
> [  429.291540]  [<ffffffff813fd522>] submit_bio+0x62/0x150
> [  429.291693]  [<ffffffff813f53d9>] ? bio_set_pages_dirty+0x49/0x60
> [  429.291847]  [<ffffffff811d32a7>] do_blockdev_direct_IO+0x2317/0x2ba0
> [  429.292011]  [<ffffffffa0834f64>] ?
> ib_post_rdma_write_imm+0x24/0x30 [ibtrs_client]
> [  429.292271]  [<ffffffff811cdc40>] ? I_BDEV+0x10/0x10
> [  429.292417]  [<ffffffff811d3b6e>] __blockdev_direct_IO+0x3e/0x40
> [  429.292566]  [<ffffffff811ce2d7>] blkdev_direct_IO+0x47/0x50
> [  429.292746]  [<ffffffff81132abf>] generic_file_read_iter+0x45f/0x580
> [  429.292894]  [<ffffffff811ce620>] ? blkdev_write_iter+0x110/0x110
> [  429.293073]  [<ffffffff811ce652>] blkdev_read_iter+0x32/0x40
> [  429.293284]  [<ffffffff811deb86>] aio_run_iocb+0x116/0x2a0
> [  429.293492]  [<ffffffff813fed52>] ? blk_flush_plug_list+0xc2/0x200
> [  429.293703]  [<ffffffff81183ac6>] ? kmem_cache_alloc+0xb6/0x180
> [  429.293901]  [<ffffffff811dfaf4>] ? do_io_submit+0x184/0x4d0
> [  429.294047]  [<ffffffff811dfbaa>] do_io_submit+0x23a/0x4d0
> [  429.294194]  [<ffffffff811dfe4b>] SyS_io_submit+0xb/0x10
> [  429.294375]  [<ffffffff81815497>] entry_SYSCALL_64_fastpath+0x12/0x6a
> [  429.294610] ---[ end trace 25d1cece0e01494b ]---
>
> I double checked the nr_pending on heathy leg is still 1 as before.
>
>>
>> Fixing the problem isn't very easy...
>>
>> You could try:
>> 1/ write a function in raid1.c which calls punt_bios_to_rescuer()
>>   (which you will need to export from block/bio.c),
>>   passing mddev->queue->bio_split as the bio_set.
>>
>> 1/ change the wait_event_lock_irq() call in wait_barrier() to
>>    wait_event_lock_irq_cmd(), and pass the new function as the command.
>>
>> That way, if wait_barrier() ever blocks, all the requests in
>> bio_list_on_stack will be handled by a separate thread.
>>
>> NeilBrown
>
> I will try your sugested way to see if it fix the bug, will report back s=
oon.
>
Hi Neil,

Sorry, bad news, with the 2 patch attached, I can still reproduce the same =
bug.
nr_pending on healthy leg is still 1, as before.
crash> struct r1conf 0xffff8800b7176100
struct r1conf {
  mddev =3D 0xffff8800b59b0000,
  mirrors =3D 0xffff88022bab7900,
  raid_disks =3D 2,
  next_resync =3D 18446744073709527039,
  start_next_window =3D 18446744073709551615,
  current_window_requests =3D 0,
  next_window_requests =3D 0,
  device_lock =3D {
    {
      rlock =3D {
        raw_lock =3D {
          val =3D {
            counter =3D 0
          }
        }
      }
    }
  },
  retry_list =3D {
    next =3D 0xffff880211b2ec40,
    prev =3D 0xffff88022819ad40
  },
  bio_end_io_list =3D {
    next =3D 0xffff880227e9a9c0,
    prev =3D 0xffff8802119c6140
  },
  pending_bio_list =3D {
    head =3D 0x0,
    tail =3D 0x0
  },
  pending_count =3D 0,
  wait_barrier =3D {
    lock =3D {
      {
        rlock =3D {
          raw_lock =3D {
            val =3D {
              counter =3D 0
            }
          }
        }
      }
    },
    task_list =3D {
      next =3D 0xffff8800adf3b818,
      prev =3D 0xffff88021180f7a8
    }
  },
  resync_lock =3D {
    {
      rlock =3D {
        raw_lock =3D {
          val =3D {
            counter =3D 0
          }
        }
      }
    }
  },
  nr_pending =3D 1675,
  nr_waiting =3D 100,
  nr_queued =3D 1673,
  barrier =3D 0,
  array_frozen =3D 1,
  fullsync =3D 0,
  recovery_disabled =3D 1,
  poolinfo =3D 0xffff88022c80f640,
  r1bio_pool =3D 0xffff88022b8b6a20,
  r1buf_pool =3D 0x0,
  tmppage =3D 0xffffea0008a90c80,
  thread =3D 0x0,
  cluster_sync_low =3D 0,
  cluster_sync_high =3D 0
}

 kobj =3D {
    name =3D 0xffff88022b7194a0 "dev-loop1",
    entry =3D {
      next =3D 0xffff880231495280,
      prev =3D 0xffff880231495280
    },
    parent =3D 0xffff8800b59b0050,
    kset =3D 0x0,
    ktype =3D 0xffffffffa0564060 <rdev_ktype>,
    sd =3D 0xffff8800b6510960,
    kref =3D {
      refcount =3D {
        counter =3D 1
      }
    },
    state_initialized =3D 1,
    state_in_sysfs =3D 1,
    state_add_uevent_sent =3D 0,
    state_remove_uevent_sent =3D 0,
    uevent_suppress =3D 0
  },
  flags =3D 2,
  blocked_wait =3D {
    lock =3D {
      {
        rlock =3D {
          raw_lock =3D {
            val =3D {
              counter =3D 0
            }
          }
        }
      }
    },
    task_list =3D {
      next =3D 0xffff8802314952c8,
      prev =3D 0xffff8802314952c8
    }
  },
  desc_nr =3D 1,
  raid_disk =3D 1,
  new_raid_disk =3D 0,
  saved_raid_disk =3D -1,
  {
    recovery_offset =3D 0,
    journal_tail =3D 0
  },
  nr_pending =3D {
    counter =3D 1
  },


--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss

--001a1134e1e2e50b5305439d44f4
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-block-export-punt_bios_to_rescuer.patch"
Content-Disposition: attachment;
	filename="0001-block-export-punt_bios_to_rescuer.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iwovq3so0

RnJvbSBlN2FkYmJiMWE4ZDU0MmVhNjhhZGE1OTk2ZTBmOWZmZTg3YzQ3OWI2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogV2VkLCAxNCBEZWMgMjAxNiAxMToyNjoyMyArMDEwMApTdWJqZWN0OiBbUEFUQ0gg
MS8yXSBibG9jazogZXhwb3J0IHB1bnRfYmlvc190b19yZXNjdWVyCgpXZSBuZWVkIGl0IGxhdGVy
IGluIHJhaWQxCgpTdWdnZXN0ZWQtYnk6IE5laWwgQnJvd24gPG5laWwuYnJvd25Ac3VzZS5jb20+
ClNpZ25lZC1vZmYtYnk6IEphY2sgV2FuZyA8amlucHUud2FuZ0Bwcm9maXRicmlja3MuY29tPgot
LS0KIGJsb2NrL2Jpby5jICAgICAgICAgfCAzICsrLQogaW5jbHVkZS9saW51eC9iaW8uaCB8IDEg
KwogMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYg
LS1naXQgYS9ibG9jay9iaW8uYyBiL2Jsb2NrL2Jpby5jCmluZGV4IDQ2ZTJjYzEuLmY2YTI1MGQg
MTAwNjQ0Ci0tLSBhL2Jsb2NrL2Jpby5jCisrKyBiL2Jsb2NrL2Jpby5jCkBAIC0zNTQsNyArMzU0
LDcgQEAgc3RhdGljIHZvaWQgYmlvX2FsbG9jX3Jlc2N1ZShzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndv
cmspCiAJfQogfQogCi1zdGF0aWMgdm9pZCBwdW50X2Jpb3NfdG9fcmVzY3VlcihzdHJ1Y3QgYmlv
X3NldCAqYnMpCit2b2lkIHB1bnRfYmlvc190b19yZXNjdWVyKHN0cnVjdCBiaW9fc2V0ICpicykK
IHsKIAlzdHJ1Y3QgYmlvX2xpc3QgcHVudCwgbm9wdW50OwogCXN0cnVjdCBiaW8gKmJpbzsKQEAg
LTM4NCw2ICszODQsNyBAQCBzdGF0aWMgdm9pZCBwdW50X2Jpb3NfdG9fcmVzY3VlcihzdHJ1Y3Qg
YmlvX3NldCAqYnMpCiAKIAlxdWV1ZV93b3JrKGJzLT5yZXNjdWVfd29ya3F1ZXVlLCAmYnMtPnJl
c2N1ZV93b3JrKTsKIH0KK0VYUE9SVF9TWU1CT0wocHVudF9iaW9zX3RvX3Jlc2N1ZXIpOwogCiAv
KioKICAqIGJpb19hbGxvY19iaW9zZXQgLSBhbGxvY2F0ZSBhIGJpbyBmb3IgSS9PCmRpZmYgLS1n
aXQgYS9pbmNsdWRlL2xpbnV4L2Jpby5oIGIvaW5jbHVkZS9saW51eC9iaW8uaAppbmRleCA0MmU0
ZTNjLi42MjU2YmE3IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2Jpby5oCisrKyBiL2luY2x1
ZGUvbGludXgvYmlvLmgKQEAgLTQ3OSw2ICs0NzksNyBAQCBleHRlcm4gdm9pZCBiaW9fYWR2YW5j
ZShzdHJ1Y3QgYmlvICosIHVuc2lnbmVkKTsKIGV4dGVybiB2b2lkIGJpb19pbml0KHN0cnVjdCBi
aW8gKik7CiBleHRlcm4gdm9pZCBiaW9fcmVzZXQoc3RydWN0IGJpbyAqKTsKIHZvaWQgYmlvX2No
YWluKHN0cnVjdCBiaW8gKiwgc3RydWN0IGJpbyAqKTsKK3ZvaWQgcHVudF9iaW9zX3RvX3Jlc2N1
ZXIoc3RydWN0IGJpb19zZXQgKik7CiAKIGV4dGVybiBpbnQgYmlvX2FkZF9wYWdlKHN0cnVjdCBi
aW8gKiwgc3RydWN0IHBhZ2UgKiwgdW5zaWduZWQgaW50LHVuc2lnbmVkIGludCk7CiBleHRlcm4g
aW50IGJpb19hZGRfcGNfcGFnZShzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqLCBzdHJ1Y3QgYmlvICos
IHN0cnVjdCBwYWdlICosCi0tIAoyLjcuNAoK
--001a1134e1e2e50b5305439d44f4
Content-Type: text/x-patch; charset=US-ASCII; name="0002-raid1-fix-deadlock.patch"
Content-Disposition: attachment; filename="0002-raid1-fix-deadlock.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iwovq3vv1

RnJvbSAyYWQ0Y2M1ZThiNWQ3ZWM5ZGI3YTZmZmZhYTJmZGNkNWYyMDQxOWJmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogV2VkLCAxNCBEZWMgMjAxNiAxMTozNTo1MiArMDEwMApTdWJqZWN0OiBbUEFUQ0gg
Mi8yXSByYWlkMTogZml4IGRlYWRsb2NrCgpTaWduZWQtb2ZmLWJ5OiBKYWNrIFdhbmcgPGppbnB1
LndhbmdAcHJvZml0YnJpY2tzLmNvbT4KLS0tCiBkcml2ZXJzL21kL3JhaWQxLmMgfCAxMCArKysr
KysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvcmFpZDEuYyBiL2RyaXZlcnMvbWQvcmFpZDEuYwppbmRl
eCA0NzgyMjNjLi42MWRhZmIxIDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL3JhaWQxLmMKKysrIGIv
ZHJpdmVycy9tZC9yYWlkMS5jCkBAIC0xOTAsNiArMTkwLDExIEBAIHN0YXRpYyB2b2lkIHB1dF9h
bGxfYmlvcyhzdHJ1Y3QgcjFjb25mICpjb25mLCBzdHJ1Y3QgcjFiaW8gKnIxX2JpbykKIAl9CiB9
CiAKK3N0YXRpYyB2b2lkIHJhaWQxX3B1bnRfYmlvc190b19yZXNjdWVyKHN0cnVjdCByMWNvbmYg
KmNvbmYpCit7CisJcHVudF9iaW9zX3RvX3Jlc2N1ZXIoY29uZi0+bWRkZXYtPnF1ZXVlLT5iaW9f
c3BsaXQpOworfQorCiBzdGF0aWMgdm9pZCBmcmVlX3IxYmlvKHN0cnVjdCByMWJpbyAqcjFfYmlv
KQogewogCXN0cnVjdCByMWNvbmYgKmNvbmYgPSByMV9iaW8tPm1kZGV2LT5wcml2YXRlOwpAQCAt
ODcxLDE0ICs4NzYsMTUgQEAgc3RhdGljIHNlY3Rvcl90IHdhaXRfYmFycmllcihzdHJ1Y3QgcjFj
b25mICpjb25mLCBzdHJ1Y3QgYmlvICpiaW8pCiAJCSAqIHRoYXQgcXVldWUgdG8gYWxsb3cgY29u
Zi0+c3RhcnRfbmV4dF93aW5kb3cKIAkJICogdG8gaW5jcmVhc2UuCiAJCSAqLwotCQl3YWl0X2V2
ZW50X2xvY2tfaXJxKGNvbmYtPndhaXRfYmFycmllciwKKwkJd2FpdF9ldmVudF9sb2NrX2lycV9j
bWQoY29uZi0+d2FpdF9iYXJyaWVyLAogCQkJCSAgICAhY29uZi0+YXJyYXlfZnJvemVuICYmCiAJ
CQkJICAgICghY29uZi0+YmFycmllciB8fAogCQkJCSAgICAgKChjb25mLT5zdGFydF9uZXh0X3dp
bmRvdyA8CiAJCQkJICAgICAgIGNvbmYtPm5leHRfcmVzeW5jICsgUkVTWU5DX1NFQ1RPUlMpICYm
CiAJCQkJICAgICAgY3VycmVudC0+YmlvX2xpc3QgJiYKIAkJCQkgICAgICAhYmlvX2xpc3RfZW1w
dHkoY3VycmVudC0+YmlvX2xpc3QpKSksCi0JCQkJICAgIGNvbmYtPnJlc3luY19sb2NrKTsKKwkJ
CQkgICAgY29uZi0+cmVzeW5jX2xvY2ssCisJCQkJICAgIHJhaWQxX3B1bnRfYmlvc190b19yZXNj
dWVyKGNvbmYpKTsKIAkJY29uZi0+bnJfd2FpdGluZy0tOwogCX0KIAotLSAKMi43LjQKCg==
--001a1134e1e2e50b5305439d44f4--
