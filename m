From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Fri, 9 Dec 2016 16:36:32 +0100
Message-ID: <CAMGffE=K50j1aHhXJXRipt_pKnJ0HbSfRCcLptk79qQSscnJGw@mail.gmail.com>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
 <CAMGffE=L_XziWyV+wCJFqKj+v_ahOPNSugZ3uY1q5ixd4iv2fQ@mail.gmail.com>
 <af7ae0a8-eb73-0070-4280-8758433ad500@suse.de> <CAMGffEmc_6o+Lgq3iJsCUyn6K=5S2w8pnrVDhXNBJxaKxd1Teg@mail.gmail.com>
 <519e773d-e6e6-5d79-7224-ef94ef7c7a93@suse.de> <CAMGffEktp+raca2fYPu8fC5nxUrhGLKwjJhtHwXV2Bh_m5oViA@mail.gmail.com>
 <dd068837-6873-ab1b-3c25-d4dbf4ad2ec4@suse.de> <CAMGffEkbddHsJ4LSWcd1DmueM8XTm1pUiowa=_MUHmysVEFN_w@mail.gmail.com>
 <CAMGffE=T15eLaROLCDGBA_OxQgUZbo22LQZJuSji=Z=rZRGr6Q@mail.gmail.com>
 <871sxj2jpd.fsf@notabene.neil.brown.name> <CAMGffEntREcP-A=td4m3LRp1oHtxR=MMH_=a4N49UPvzFj-02A@mail.gmail.com>
 <87inqt1vzk.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87inqt1vzk.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

On Fri, Dec 9, 2016 at 7:01 AM, NeilBrown <neilb@suse.com> wrote:
> On Thu, Dec 08 2016, Jinpu Wang wrote:
>
>
> This number:
>
>>   nr_pending =3D {
>>     counter =3D 1
>>   },
>
>
>
> and this number:
>
>>   nr_pending =3D {
>>     counter =3D 856
>>   },
>
> might be interesting.
>
> There are 855 requested on the list.  Add the one that is currently
> being retried give 856, which is nr_pending for the device that failed.
> But nr_pending on the device that didn't fail is 1.  I would expect
> zero.
> When a read or write requests succeeds, rdev_dec_pending() is called
> immediately so this should quickly go to zero.
>
> It seems as though there must be a request to the loop device that is
> stuck somewhere between the atomic_inc(&rdev->nr_pending) (possibly
> inside read_balance) and the call to generic_make_request().
> I cannot yet see how that would happen.
>
> Can you check if the is a repeatable observation?  Is nr_pending.counter
> always '1' on the loop device?
>
> Thanks,
> NeilBrown

Hi Neil,

Yes, it's repreatable observation. I triggered again, this time
  nr_pending =3D 1203,
  nr_waiting =3D 8,
  nr_queued =3D 1201,

conf->retry_list has 1175 entries.
on conf->bio_end_io_list has 26 entries.
Totol is 1201, match nr_queued.

in md_rdev healthy one loop1 has 1 nr_pending.
faulty one ibnbd1 has 1076.

crash> struct md_rdev 0xffff880228880400
struct md_rdev {
  same_set =3D {
    next =3D 0xffff88023202a200,
    prev =3D 0xffff8800b64c6018
  },
  sectors =3D 2095104,
  mddev =3D 0xffff8800b64c6000,
  last_events =3D 17764573,
  meta_bdev =3D 0x0,
  bdev =3D 0xffff8800b60ce080,
  sb_page =3D 0xffffea0002bd3040,
  bb_page =3D 0xffffea0002dc76c0,
  sb_loaded =3D 1,
  sb_events =3D 166,
  data_offset =3D 2048,
  new_data_offset =3D 2048,
  sb_start =3D 8,
  sb_size =3D 512,
  preferred_minor =3D 65535,
  kobj =3D {
    name =3D 0xffff880037962af0 "dev-ibnbd0",
    entry =3D {
      next =3D 0xffff880228880480,
      prev =3D 0xffff880228880480
    },
    parent =3D 0xffff8800b64c6050,
    kset =3D 0x0,
    ktype =3D 0xffffffffa0501300 <rdev_ktype>,
    sd =3D 0xffff88022bfc12d0,
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
      next =3D 0xffff8802288804c8,
      prev =3D 0xffff8802288804c8
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
    counter =3D 1176
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
  sysfs_state =3D 0xffff88022bfc1348,
  badblocks =3D {
    count =3D 0,
    unacked_exist =3D 0,
    shift =3D 0,
    page =3D 0xffff8802289aa000,
    changed =3D 0,
    lock =3D {
      seqcount =3D {
        sequence =3D 0
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

crash> struct md_rdev 0xffff88023202a200
struct md_rdev {
  same_set =3D {
    next =3D 0xffff8800b64c6018,
    prev =3D 0xffff880228880400
  },
  sectors =3D 2095104,
  mddev =3D 0xffff8800b64c6000,
  last_events =3D 37178561,
  meta_bdev =3D 0x0,
  bdev =3D 0xffff8800b60d09c0,
  sb_page =3D 0xffffea0008af7580,
  bb_page =3D 0xffffea0002e69380,
  sb_loaded =3D 1,
  sb_events =3D 167,
  data_offset =3D 2048,
  new_data_offset =3D 2048,
  sb_start =3D 8,
  sb_size =3D 512,
  preferred_minor =3D 65535,
  kobj =3D {
    name =3D 0xffff88023521ec30 "dev-loop1",
    entry =3D {
      next =3D 0xffff88023202a280,
      prev =3D 0xffff88023202a280
    },
    parent =3D 0xffff8800b64c6050,
    kset =3D 0x0,
    ktype =3D 0xffffffffa0501300 <rdev_ktype>,
    sd =3D 0xffff88022bc0a708,
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
      next =3D 0xffff88023202a2c8,
      prev =3D 0xffff88023202a2c8
    }
  },
crash> struct md_rdev 0xffff88023202a200
struct md_rdev {
  same_set =3D {
    next =3D 0xffff8800b64c6018,
    prev =3D 0xffff880228880400
  },
  sectors =3D 2095104,
  mddev =3D 0xffff8800b64c6000,
  last_events =3D 37178561,
  meta_bdev =3D 0x0,
  bdev =3D 0xffff8800b60d09c0,
  sb_page =3D 0xffffea0008af7580,
  bb_page =3D 0xffffea0002e69380,
  sb_loaded =3D 1,
  sb_events =3D 167,
  data_offset =3D 2048,
  new_data_offset =3D 2048,
  sb_start =3D 8,
  sb_size =3D 512,
  preferred_minor =3D 65535,
  kobj =3D {
    name =3D 0xffff88023521ec30 "dev-loop1",
    entry =3D {
      next =3D 0xffff88023202a280,
      prev =3D 0xffff88023202a280
    },
    parent =3D 0xffff8800b64c6050,
    kset =3D 0x0,
    ktype =3D 0xffffffffa0501300 <rdev_ktype>,
    sd =3D 0xffff88022bc0a708,
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
      next =3D 0xffff88023202a2c8,
      prev =3D 0xffff88023202a2c8
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
  sysfs_state =3D 0xffff88022bc0a780,
  badblocks =3D {
    count =3D 0,
    unacked_exist =3D 0,
    shift =3D 0,
    page =3D 0xffff88022bff0000,
    changed =3D 0,
    lock =3D {
      seqcount =3D {
        sequence =3D 164
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



Thanks

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
