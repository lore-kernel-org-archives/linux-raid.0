From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Wed, 7 Dec 2016 15:17:18 +0100
Message-ID: <CAMGffE=T15eLaROLCDGBA_OxQgUZbo22LQZJuSji=Z=rZRGr6Q@mail.gmail.com>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
 <CAMGffE=L_XziWyV+wCJFqKj+v_ahOPNSugZ3uY1q5ixd4iv2fQ@mail.gmail.com>
 <af7ae0a8-eb73-0070-4280-8758433ad500@suse.de> <CAMGffEmc_6o+Lgq3iJsCUyn6K=5S2w8pnrVDhXNBJxaKxd1Teg@mail.gmail.com>
 <519e773d-e6e6-5d79-7224-ef94ef7c7a93@suse.de> <CAMGffEktp+raca2fYPu8fC5nxUrhGLKwjJhtHwXV2Bh_m5oViA@mail.gmail.com>
 <dd068837-6873-ab1b-3c25-d4dbf4ad2ec4@suse.de> <CAMGffEkbddHsJ4LSWcd1DmueM8XTm1pUiowa=_MUHmysVEFN_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGffEkbddHsJ4LSWcd1DmueM8XTm1pUiowa=_MUHmysVEFN_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

On Tue, Nov 29, 2016 at 12:15 PM, Jinpu Wang
<jinpu.wang@profitbricks.com> wrote:
> On Mon, Nov 28, 2016 at 10:10 AM, Coly Li <colyli@suse.de> wrote:
>> On 2016/11/28 =E4=B8=8B=E5=8D=885:02, Jinpu Wang wrote:
>>> On Mon, Nov 28, 2016 at 9:54 AM, Coly Li <colyli@suse.de> wrote:
>>>> On 2016/11/28 =E4=B8=8B=E5=8D=884:24, Jinpu Wang wrote:
>>>>> snip
>>>>>>>>
>>>>>>>> every time nr_pending is 1 bigger then (nr_queued + 1), so seems w=
e
>>>>>>>> forgot to increase nr_queued somewhere?
>>>>>>>>
>>>>>>>> I've noticed (commit ccfc7bf1f09d61)raid1: include bio_end_io_list=
 in
>>>>>>>> nr_queued to prevent freeze_array hang. Seems it fixed similar bug=
.
>>>>>>>>
>>>>>>>> Could you give your suggestion?
>>>>>>>>
>>>>>>> Sorry, forgot to mention kernel version is 4.4.28
>>>>>>
>>>>>> This commit is Cced to stable@vger.kernel.org for v4.3+, do you use =
a
>>>>>> stable kernel or a distribution with 4.4.28 kernel ?
>>>>>>
>>>>>> Coly
>>>>>>
>>>>>>
>>>>> Hi Coly,
>>>>>
>>>>> I'm using Debian8 with 4.4.28 kernel.
>>>>
>>>> Hi Jinpu,
>>>>
>>>> Is it possible for your to run a upstream kernel or vanilla kernel to
>>>> test whether the issue still can be reproduced ? Then we can know
>>>> whether it is an upstream bug or a distro issue.
>>>>
>>>> Thanks.
>>>>
>>>> Coly
>>>
>>> Hi Coly,
>>>
>>> I did run kernel 4.4.34 (I download from kernel.org), I can reproduce
>>> the same bug.
>>>
>>> I can also try latest 4.8 or 4.9 rc kernel, if you think it's necessary=
?
>>>
>> Yes, please. If it can be reproduced on upstream kernel by a set of
>> scripts, it will be very helpful to debug and fix this issue.
>>
>> Thanks in advance.
>>
>> Coly
>
> Hi Coly,
>
> I tried with kernel 4.9-cr7, I can't reproduce it with my testcase anymor=
e.
>
> It's hard to say the bug is fixed or harder to reproduce because code
> changed a lot.
>
> --
> Jinpu Wang
> Linux Kernel Developer
>
> ProfitBricks GmbH
> Greifswalder Str. 207
> D - 10405 Berlin
>
> Tel:       +49 30 577 008  042
> Fax:      +49 30 577 008 299
> Email:    jinpu.wang@profitbricks.com
> URL:      https://www.profitbricks.de
>
> Sitz der Gesellschaft: Berlin
> Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
> Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
Hi,

I continue debug the bug:

20161207
crash> struct r1conf 0xffff8800b9792000
struct r1conf {
  mddev =3D 0xffff88022db03800,
  mirrors =3D 0xffff880227729200,
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
    next =3D 0xffff8800afe690c0,
    prev =3D 0xffff8800b96acac0
  },
  bio_end_io_list =3D {
    next =3D 0xffff8800b96ac2c0,
    prev =3D 0xffff88003735f140
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
      next =3D 0xffff880221bc7770,
      prev =3D 0xffff8800ad44bc88
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
  nr_pending =3D 948,
  nr_waiting =3D 9,
  nr_queued =3D 946, // again we need one more to finished wait_event.
  barrier =3D 0,
  array_frozen =3D 1,
  fullsync =3D 0,
  recovery_disabled =3D 2,
  poolinfo =3D 0xffff88022c567580,
  r1bio_pool =3D 0xffff88022fdccea0,
  r1buf_pool =3D 0x0,
  tmppage =3D 0xffffea0002bf1600,
  thread =3D 0x0,
  cluster_sync_low =3D 0,
  cluster_sync_high =3D 0
}
crash> exit

on conf->bio_end_io_list we have 91 entries.
crash> list -H 0xffff88003735f140
ffff8800b9792048
ffff8800b96ac2c0
ffff8800b96ac1c0

snip
ffff88022243dfc0
ffff88022243dc40
crash>

on conf->retry_list we have 855
crash> list -H 0xffff8800b96acac0
ffff8800b9792038
ffff8800afe690c0
snip

list -H 0xffff8800b96acac0 r1bio.retry_list -s r1bio

ffff8800b9791ff8
struct r1bio {
  remaining =3D {
    counter =3D 0
  },
  behind_remaining =3D {
    counter =3D 0
  },
  sector =3D 18446612141670676480, // corrupted?
  start_next_window =3D 18446612141565972992, //ditto
  sectors =3D 2,
  state =3D 18446744073709527039, // ditto
  mddev =3D 0xffffffffffffffff,
  master_bio =3D 0x0,
  read_disk =3D 0,
  retry_list =3D {
    next =3D 0xffff8800afe690c0,
    prev =3D 0xffff8800b96acac0
  },
  behind_bvecs =3D 0xffff8800b96ac2c0,
  behind_page_count =3D 926282048,
  bios =3D 0xffff8800b9792058
}
ffff8800afe69080
struct r1bio {
  remaining =3D {
    counter =3D 0
  },
  behind_remaining =3D {
    counter =3D 0
  },
  sector =3D 1566,
  start_next_window =3D 0,
  sectors =3D 128,
  state =3D 257,
  mddev =3D 0xffff88022db03800,
  master_bio =3D 0xffff8800371c1f00,
  read_disk =3D 0,
  retry_list =3D {
    next =3D 0xffff8800ad41a540,
    prev =3D 0xffff8800b9792038
  },
  behind_bvecs =3D 0x0,
  behind_page_count =3D 0,
  bios =3D 0xffff8800afe690e0
}

check conf->bio_end_io_list
list -H 0xffff88003735f140 r1bio.retry_list -s r1bio

ffff8800b9792008
struct r1bio {
  remaining =3D {
    counter =3D 661819904
  },
  behind_remaining =3D {
    counter =3D -30718
  },
  sector =3D 2,
  start_next_window =3D 18446744073709527039, // corrupted?
  sectors =3D -1,                                                 // corrup=
ted?
  state =3D 0,
  mddev =3D 0x0,                                               // corrupted=
?
  master_bio =3D 0xffff8800afe690c0,
  read_disk =3D -1184183616,                             // ?
  retry_list =3D {
    next =3D 0xffff8800b96ac2c0,
    prev =3D 0xffff88003735f140
  },
  behind_bvecs =3D 0x0,
  behind_page_count =3D 0,
  bios =3D 0xffff8800b9792068
}
ffff8800b96ac280
struct r1bio {
  remaining =3D {
    counter =3D 0
  },
  behind_remaining =3D {
    counter =3D 0
  },
  sector =3D 980009,
  start_next_window =3D 0,
  sectors =3D 16,
  state =3D 257,
  mddev =3D 0xffff88022db03800,
  master_bio =3D 0xffff8800370b0600,
  read_disk =3D 0,
  retry_list =3D {
    next =3D 0xffff8800b96ac1c0,
    prev =3D 0xffff8800b9792048
  },
  behind_bvecs =3D 0x0,
  behind_page_count =3D 0,
  bios =3D 0xffff8800b96ac2e0
}

I still have no clue what it could be, any one has idea?

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
