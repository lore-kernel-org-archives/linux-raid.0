From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Tue, 13 Dec 2016 16:08:40 +0100
Message-ID: <CAMGffEm4BDhKJSiDt=2WmxrpRutg862at7JP221gMi6_SpPomQ@mail.gmail.com>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
 <87a8c20xpg.fsf@notabene.neil.brown.name> <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com>
 <87oa0gzuej.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87oa0gzuej.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

Hi Neil,

On Mon, Dec 12, 2016 at 10:53 PM, NeilBrown <neilb@suse.com> wrote:
> On Tue, Dec 13 2016, Jinpu Wang wrote:
>
>> On Mon, Dec 12, 2016 at 1:59 AM, NeilBrown <neilb@suse.com> wrote:
>>> On Sat, Nov 26 2016, Jinpu Wang wrote:
>>>> [  810.270860]  [<ffffffff813fc851>] blk_prologue_bio+0x91/0xc0
>>>
>>> What is this?  I cannot find that function in the upstream kernel.
>>>
>>> NeilBrown
>>
>> Hi Neil,
>>
>> blk_prologue_bio is our internal extension to gather some stats, sorry
>> not informed before.
>
> Ahhh.
>
> ....
>> +       return q->custom_make_request_fn(q, clone);
>
> I haven't heard of custom_make_request_fn before either.
>
>> +}
>>
>> =EF=BC=A9=EF=BC=AD=EF=BC=A8=EF=BC=AF=EF=BC=8C it seems unrelated, but I =
will rerun my test without this change.
>
> Yes, please re-test with an unmodified upstream kernel (and always
> report *exactly* what kernel you are running.  I cannot analyse code
> that I cannot see).
>
> NeilBrown

As you suggested, I re-run same test with 4.4.36 with no our own patch on M=
D.
I can still reproduce the same bug, nr_pending on heathy leg(loop1) is till=
 1.

4.4.36 kernel:
crash> bt 4069
PID: 4069   TASK: ffff88022b4f8d00  CPU: 3   COMMAND: "md2_raid1"
 #0 [ffff8800b77d3bf8] __schedule at ffffffff81811453
 #1 [ffff8800b77d3c50] schedule at ffffffff81811c30
 #2 [ffff8800b77d3c68] freeze_array at ffffffffa07ee17e [raid1]
 #3 [ffff8800b77d3cc0] handle_read_error at ffffffffa07f093b [raid1]
 #4 [ffff8800b77d3d68] raid1d at ffffffffa07f10a6 [raid1]
 #5 [ffff8800b77d3e60] md_thread at ffffffffa04dee80 [md_mod]
 #6 [ffff8800b77d3ed0] kthread at ffffffff81075fb6
 #7 [ffff8800b77d3f50] ret_from_fork at ffffffff818157df
crash> bt 2558
bt: invalid task or pid value: 2558
crash> bt 4558
PID: 4558   TASK: ffff88022b550d00  CPU: 3   COMMAND: "fio"
 #0 [ffff88022c287710] __schedule at ffffffff81811453
 #1 [ffff88022c287768] schedule at ffffffff81811c30
 #2 [ffff88022c287780] wait_barrier at ffffffffa07ee044 [raid1]
 #3 [ffff88022c2877e8] make_request at ffffffffa07efc65 [raid1]
 #4 [ffff88022c2878d0] md_make_request at ffffffffa04df609 [md_mod]
 #5 [ffff88022c287928] generic_make_request at ffffffff813fd3de
 #6 [ffff88022c287970] submit_bio at ffffffff813fd522
 #7 [ffff88022c2879b8] do_blockdev_direct_IO at ffffffff811d32a7
 #8 [ffff88022c287be8] __blockdev_direct_IO at ffffffff811d3b6e
 #9 [ffff88022c287c10] blkdev_direct_IO at ffffffff811ce2d7
#10 [ffff88022c287c38] generic_file_direct_write at ffffffff81132c90
#11 [ffff88022c287cb0] __generic_file_write_iter at ffffffff81132e1d
#12 [ffff88022c287d08] blkdev_write_iter at ffffffff811ce597
#13 [ffff88022c287d68] aio_run_iocb at ffffffff811deca6
#14 [ffff88022c287e68] do_io_submit at ffffffff811dfbaa
#15 [ffff88022c287f40] sys_io_submit at ffffffff811dfe4b
#16 [ffff88022c287f50] entry_SYSCALL_64_fastpath at ffffffff81815497
    RIP: 00007f63b1362737  RSP: 00007ffff7eb17f8  RFLAGS: 00000206
    RAX: ffffffffffffffda  RBX: 00007f63a142a000  RCX: 00007f63b1362737
    RDX: 0000000001179b58  RSI: 0000000000000001  RDI: 00007f63b1f4a000
    RBP: 0000000000000512   R8: 0000000000000001   R9: 0000000001171fa0
    R10: 00007f639ef84000  R11: 0000000000000206  R12: 0000000000000001
    R13: 0000000000000200  R14: 000000003a2d3000  R15: 0000000000000001
    ORIG_RAX: 00000000000000d1  CS: 0033  SS: 002b

crash> struct r1conf 0xffff880037362100
struct r1conf {
  mddev =3D 0xffff880037352800,
  mirrors =3D 0xffff88022c209c00,
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
    next =3D 0xffff8801ce757740,
    prev =3D 0xffff8801b1b79140
  },
  bio_end_io_list =3D {
    next =3D 0xffff8801ce7d9ac0,
    prev =3D 0xffff88022838f4c0
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
      next =3D 0xffff8801f6d87818,
      prev =3D 0xffff88022c2877a8
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
  nr_pending =3D 2086,
  nr_waiting =3D 97,
  nr_queued =3D 2084,
  barrier =3D 0,
  array_frozen =3D 1,
  fullsync =3D 0,
  recovery_disabled =3D 1,
  poolinfo =3D 0xffff8802330be390,
  r1bio_pool =3D 0xffff88022bdf54e0,
  r1buf_pool =3D 0x0,
  tmppage =3D 0xffffea0000dcee40,
  thread =3D 0x0,
  cluster_sync_low =3D 0,
  cluster_sync_high =3D 0
}
crash>
crash> struct raid1_info 0xffff88022c209c00
struct raid1_info {
  rdev =3D 0xffff880231635800,
  head_position =3D 1318965,
  next_seq_sect =3D 252597,
  seq_start =3D 252342
}
crash> struct raid1_info 0xffff88022c209c20
struct raid1_info {
  rdev =3D 0xffff88023166ce00,
  head_position =3D 1585216,
  next_seq_sect =3D 839992,
  seq_start =3D 839977
}
crash> struct md_rdev 0xffff880231635800
struct md_rdev {
  same_set =3D {
    next =3D 0xffff880037352818,
    prev =3D 0xffff88023166ce00
  },
  sectors =3D 2095104,
  mddev =3D 0xffff880037352800,
  last_events =3D 41325652,
  meta_bdev =3D 0x0,
  bdev =3D 0xffff880235c2aa40,
  sb_page =3D 0xffffea0002dd98c0,
  bb_page =3D 0xffffea0002e48f80,
  sb_loaded =3D 1,
  sb_events =3D 205,
  data_offset =3D 2048,
  new_data_offset =3D 2048,
  sb_start =3D 8,
  sb_size =3D 512,
  preferred_minor =3D 65535,
  kobj =3D {
    name =3D 0xffff8802341cdef0 "dev-loop1",
    entry =3D {
      next =3D 0xffff880231635880,
      prev =3D 0xffff880231635880
    },
    parent =3D 0xffff880037352850,
    kset =3D 0x0,
    ktype =3D 0xffffffffa04f3020 <rdev_ktype>,
    sd =3D 0xffff880233e3b8e8,
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
      next =3D 0xffff8802316358c8,
      prev =3D 0xffff8802316358c8
    }
  },
desc_nr =3D 0,
  raid_disk =3D 0,
  new_raid_disk =3D 0,
  saved_raid_disk =3D -1,
  {
    recovery_offset =3D 0,
    journal_tail =3D 0
  },
  nr_pending =3D {
    counter =3D 1
  },
  read_errors =3D {
    counter =3D 0
  },
  last_read_error =3D {
    tv_sec =3D 0,
    tv_nsec =3D 0
  },
  corrected_errors =3D {
    counter =3D 0
  },
  del_work =3D {
    data =3D {
      counter =3D 0
    },
    entry =3D {
      next =3D 0x0,
      prev =3D 0x0
    },
    func =3D 0x0
  },
  sysfs_state =3D 0xffff880233e3b960,
  badblocks =3D {
    count =3D 0,
    unacked_exist =3D 0,
    shift =3D 0,
    page =3D 0xffff88022c0d6000,
    changed =3D 0,
    lock =3D {
      seqcount =3D {
        sequence =3D 264
      },
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
      }
    },
    sector =3D 0,
    size =3D 0
  }
}
struct md_rdev {
  same_set =3D {
    next =3D 0xffff880231635800,
    prev =3D 0xffff880037352818
  },
  sectors =3D 2095104,
  mddev =3D 0xffff880037352800,
  last_events =3D 10875407,
  meta_bdev =3D 0x0,
  bdev =3D 0xffff880234a86a40,
  sb_page =3D 0xffffea00089e0ac0,
  bb_page =3D 0xffffea0007db4980,
  sb_loaded =3D 1,
  sb_events =3D 204,
  data_offset =3D 2048,
  new_data_offset =3D 2048,
  sb_start =3D 8,
  sb_size =3D 512,
  preferred_minor =3D 65535,
  kobj =3D {
    name =3D 0xffff88022c100e30 "dev-ibnbd0",
    entry =3D {
      next =3D 0xffff88023166ce80,
      prev =3D 0xffff88023166ce80
    },
    parent =3D 0xffff880037352850,
    kset =3D 0x0,
    ktype =3D 0xffffffffa04f3020 <rdev_ktype>,
    sd =3D 0xffff8800b6539e10,
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
  flags =3D 581,
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
      next =3D 0xffff88023166cec8,
      prev =3D 0xffff88023166cec8
    }
  },
  desc_nr =3D 1,
  raid_disk =3D 1,
  new_raid_disk =3D 0,
  saved_raid_disk =3D -1,
  {
    recovery_offset =3D 18446744073709551615,
    journal_tail =3D 18446744073709551615
  },
  nr_pending =3D {
    counter =3D 2073
  },
  read_errors =3D {
    counter =3D 0
  },
  last_read_error =3D {
    tv_sec =3D 0,
    tv_nsec =3D 0
  },
  corrected_errors =3D {
    counter =3D 0
  },
  del_work =3D {
    data =3D {
      counter =3D 0
    },
    entry =3D {
      next =3D 0x0,
      prev =3D 0x0
    },
    func =3D 0x0
  },
  sysfs_state =3D 0xffff8800b6539e88,
  badblocks =3D {
    count =3D 1,
    unacked_exist =3D 0,
    shift =3D 0,
    page =3D 0xffff880099ced000,
    changed =3D 0,
    lock =3D {
      seqcount =3D {
        sequence =3D 4
      },
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
      }
    },
    sector =3D 80,
    size =3D 8
  }
}


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
