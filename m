From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Thu, 8 Dec 2016 10:50:22 +0100
Message-ID: <CAMGffEntREcP-A=td4m3LRp1oHtxR=MMH_=a4N49UPvzFj-02A@mail.gmail.com>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
 <CAMGffE=L_XziWyV+wCJFqKj+v_ahOPNSugZ3uY1q5ixd4iv2fQ@mail.gmail.com>
 <af7ae0a8-eb73-0070-4280-8758433ad500@suse.de> <CAMGffEmc_6o+Lgq3iJsCUyn6K=5S2w8pnrVDhXNBJxaKxd1Teg@mail.gmail.com>
 <519e773d-e6e6-5d79-7224-ef94ef7c7a93@suse.de> <CAMGffEktp+raca2fYPu8fC5nxUrhGLKwjJhtHwXV2Bh_m5oViA@mail.gmail.com>
 <dd068837-6873-ab1b-3c25-d4dbf4ad2ec4@suse.de> <CAMGffEkbddHsJ4LSWcd1DmueM8XTm1pUiowa=_MUHmysVEFN_w@mail.gmail.com>
 <CAMGffE=T15eLaROLCDGBA_OxQgUZbo22LQZJuSji=Z=rZRGr6Q@mail.gmail.com> <871sxj2jpd.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871sxj2jpd.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

Thanks Neil for valuable inputs, please see comments inline.

On Thu, Dec 8, 2016 at 4:17 AM, NeilBrown <neilb@suse.com> wrote:
> On Thu, Dec 08 2016, Jinpu Wang wrote:
>
>> On Tue, Nov 29, 2016 at 12:15 PM, Jinpu Wang
>> <jinpu.wang@profitbricks.com> wrote:
>>> On Mon, Nov 28, 2016 at 10:10 AM, Coly Li <colyli@suse.de> wrote:
>>>> On 2016/11/28 =E4=B8=8B=E5=8D=885:02, Jinpu Wang wrote:
>>>>> On Mon, Nov 28, 2016 at 9:54 AM, Coly Li <colyli@suse.de> wrote:
>>>>>> On 2016/11/28 =E4=B8=8B=E5=8D=884:24, Jinpu Wang wrote:
>>>>>>> snip
>>>>>>>>>>
>>>>>>>>>> every time nr_pending is 1 bigger then (nr_queued + 1), so seems=
 we
>>>>>>>>>> forgot to increase nr_queued somewhere?
>>>>>>>>>>
>>>>>>>>>> I've noticed (commit ccfc7bf1f09d61)raid1: include bio_end_io_li=
st in
>>>>>>>>>> nr_queued to prevent freeze_array hang. Seems it fixed similar b=
ug.
>>>>>>>>>>
>>>>>>>>>> Could you give your suggestion?
>>>>>>>>>>
>>>>>>>>> Sorry, forgot to mention kernel version is 4.4.28
>
>>
>> I continue debug the bug:
>>
>> 20161207
>
>>   nr_pending =3D 948,
>>   nr_waiting =3D 9,
>>   nr_queued =3D 946, // again we need one more to finished wait_event.
>>   barrier =3D 0,
>>   array_frozen =3D 1,
>
>> on conf->bio_end_io_list we have 91 entries.
>
>> on conf->retry_list we have 855
>
> This is useful.  It confirms that nr_queued is correct, and that
> nr_pending is consistently 1 higher than expected.
> This suggests that a request has been counted in nr_pending, but hasn't
> yet been submitted, or has been taken off one of the queues but has not
> yet been processed.
>
> I notice that in your first email the Blocked tasks listed included
> raid1d which is blocked in freeze_array() and a few others in
> make_request() blocked on wait_barrier().
> In that case nr_waiting was 100, so there should have been 100 threads
> blocked in wait_barrier().  Is that correct?  I assume you thought it
> was pointless to list them all, which seems reasonable.
This is correct. From my test, I initially use numjobs set to 100 in
fio. then later I reduce that to 10,
I can still trigger the bug.


>
> I asked because I wonder if there might have been one thread in
> make_request() which was blocked on something else.  There are a couple
> of places when make_request() will wait after having successfully called
> wait_barrier().  If that happened, it would cause exactly the symptoms
> you report.  Could you check all blocked threads carefully please?

Every time it's the same hung task, raid1d is blocked in freeze_array
PID: 5002   TASK: ffff8800ad430d00  CPU: 0   COMMAND: "md1_raid1"
 #0 [ffff8800ad44bbf8] __schedule at ffffffff81811483
 #1 [ffff8800ad44bc50] schedule at ffffffff81811c60
 #2 [ffff8800ad44bc68] freeze_array at ffffffffa085a1e1 [raid1]
 #3 [ffff8800ad44bcc0] handle_read_error at ffffffffa085bfe9 [raid1]
 #4 [ffff8800ad44bd68] raid1d at ffffffffa085d29b [raid1]
 #5 [ffff8800ad44be60] md_thread at ffffffffa0549040 [md_mod]
and 9 fio threads are blocked in wait_barrier
PID: 5172   TASK: ffff88022bf4a700  CPU: 3   COMMAND: "fio"
 #0 [ffff88022186b6d8] __schedule at ffffffff81811483
 #1 [ffff88022186b730] schedule at ffffffff81811c60
 #2 [ffff88022186b748] wait_barrier at ffffffffa085a0b6 [raid1]
 #3 [ffff88022186b7b0] make_request at ffffffffa085c3cd [raid1]
 #4 [ffff88022186b890] md_make_request at ffffffffa0549903 [md_mod]
The other fio thread is  sleeping in futex wait, I think it's unrelated.
PID: 5171   TASK: ffff88022bf49a00  CPU: 2   COMMAND: "fio"
 #0 [ffff880221f97c08] __schedule at ffffffff81811483
 #1 [ffff880221f97c60] schedule at ffffffff81811c60
 #2 [ffff880221f97c78] futex_wait_queue_me at ffffffff810c8a42
 #3 [ffff880221f97cb0] futex_wait at ffffffff810c9c72



>
>
> There are other ways that nr_pending and nr_queued can get out of sync,
> though I think they would result in nr_pending being less than
> nr_queued, not more.
>
> If the presense of a bad block in the bad block log causes a request to
> be split into two r1bios, and if both of those end up on one of the
> queues, then they would be added to nr_queued twice, but to nr_pending
> only once.  We should fix that.
I checked, there're some bad_blocks md detected, not sure if it helps.
root@ibnbd-clt1:~/jack# cat /sys/block/md1/md/dev-ibnbd0/bad_blocks
180630 512
181142 7
982011 8
1013386 255

I also checked each md_rdev:
crash> struct md_rdev 0xffff880230630000
struct md_rdev {
  same_set =3D {
    next =3D 0xffff88022db03818,
    prev =3D 0xffff880230653e00
  },
  sectors =3D 2095104,
  mddev =3D 0xffff88022db03800,
  last_events =3D 125803676,
  meta_bdev =3D 0x0,
  bdev =3D 0xffff880234a56080,
  sb_page =3D 0xffffea0008d3edc0,
  bb_page =3D 0xffffea0008b17400,
  sb_loaded =3D 1,
  sb_events =3D 72,
  data_offset =3D 2048,
  new_data_offset =3D 2048,
  sb_start =3D 8,
  sb_size =3D 512,
  preferred_minor =3D 65535,
  kobj =3D {
    name =3D 0xffff88022c567510 "dev-loop1",
    entry =3D {
      next =3D 0xffff880230630080,
      prev =3D 0xffff880230630080
    },
    parent =3D 0xffff88022db03850,
    kset =3D 0x0,
    ktype =3D 0xffffffffa055f200 <rdev_ktype>,
    sd =3D 0xffff88022c4ac708,
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
      next =3D 0xffff8802306300c8,
      prev =3D 0xffff8802306300c8
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
  sysfs_state =3D 0xffff88022c4ac780,
  badblocks =3D {
    count =3D 0,
    unacked_exist =3D 0,
    shift =3D 0,
    page =3D 0xffff88022740d000,
    changed =3D 0,
    lock =3D {
      seqcount =3D {
        sequence =3D 60
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
crash>
crash> struct md_rdev 0xffff880230653e00
struct md_rdev {
  same_set =3D {
    next =3D 0xffff880230630000,
    prev =3D 0xffff88022db03818
  },
  sectors =3D 2095104,
  mddev =3D 0xffff88022db03800,
  last_events =3D 9186098,
  meta_bdev =3D 0x0,
  bdev =3D 0xffff880234a56700,
  sb_page =3D 0xffffea0007758f40,
  bb_page =3D 0xffffea000887b480,
  sb_loaded =3D 1,
  sb_events =3D 42,
  data_offset =3D 2048,
  new_data_offset =3D 2048,
  sb_start =3D 8,
  sb_size =3D 512,
  preferred_minor =3D 65535,
  kobj =3D {
    name =3D 0xffff880233c825b0 "dev-ibnbd0",
    entry =3D {
      next =3D 0xffff880230653e80,
      prev =3D 0xffff880230653e80
    },
    parent =3D 0xffff88022db03850,
    kset =3D 0x0,
    ktype =3D 0xffffffffa055f200 <rdev_ktype>,
    sd =3D 0xffff8800b9fcce88,
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
      next =3D 0xffff880230653ec8,
      prev =3D 0xffff880230653ec8
    }
  },
  desc_nr =3D 0,
  raid_disk =3D 0,
  new_raid_disk =3D 0,
  saved_raid_disk =3D -1,
  {
    recovery_offset =3D 18446744073709551615,
    journal_tail =3D 18446744073709551615
  },
  nr_pending =3D {
    counter =3D 856
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
  sysfs_state =3D 0xffff8800b9fccf78,
  badblocks =3D {
    count =3D 4,
    unacked_exist =3D 0,
    shift =3D 0,
    page =3D 0xffff880227211000,
    changed =3D 0,
    lock =3D {
      seqcount =3D {
        sequence =3D 1624
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
>
>
>>
>> list -H 0xffff8800b96acac0 r1bio.retry_list -s r1bio
>>
>> ffff8800b9791ff8
>> struct r1bio {
>>   remaining =3D {
>>     counter =3D 0
>>   },
>>   behind_remaining =3D {
>>     counter =3D 0
>>   },
>>   sector =3D 18446612141670676480, // corrupted?
>>   start_next_window =3D 18446612141565972992, //ditto
>
> I don't think this is corruption.
>
>> crash> struct r1conf 0xffff8800b9792000
>> struct r1conf {
>   ....
>>   retry_list =3D {
>>     next =3D 0xffff8800afe690c0,
>>     prev =3D 0xffff8800b96acac0
>>   },
>
> The pointer you started at was at the end of the list.
> So this r1bio structure you are seeing is not an r1bio at all but the
> memory out of the middle of the r1conf, being interpreted as an r1bio.
> You can confirm this by noticing that retry_list in the r1bio:
>
>>   retry_list =3D {
>>     next =3D 0xffff8800afe690c0,
>>     prev =3D 0xffff8800b96acac0
>>   },
>
> is exactly the same as the retry_list in the r1conf.
>
> NeilBrown

Oh, thanks for explanation, I notice this coincidence, was curious why.
I still have my hung task machine alive, I can just what ever you
think necessary.

Thanks again for debuging this with me.

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
