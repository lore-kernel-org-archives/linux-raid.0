From: Karl Newman <siliconfiend@gmail.com>
Subject: Re: [BISECT] Kernel panic, RIP bitmap_create
Date: Wed, 2 May 2012 23:14:09 -0700
Message-ID: <CAOOwNtK0xKg9E=gS46GR8uDVvjPqqL7+FbufY2d7iuW7yZgVwQ@mail.gmail.com>
References: <CAOOwNtJhFa67EFTs5AdgSHzFseBr9xJGTsaEOyYnaYYNCeUMAQ@mail.gmail.com>
	<CAOOwNt+wjMU9+Dzrr3+d3dwML2_Q_CgT4X5OgiKvPA_bBoTYcg@mail.gmail.com>
	<20120503155850.2900067d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120503155850.2900067d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 2, 2012 at 10:58 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 2 May 2012 22:05:44 -0700 Karl Newman <siliconfiend@gmail.com=
> wrote:
>
>> Hi,
>>
>> I'm attempting to use kernel 3.4-rc? but keep running into a kernel =
panic on
>> boot, with RIP pointing to bitmap_create. I tried 3.4-rc1, 3.4-rc4 a=
nd
>> 3.4-rc5 and they all have the kernel panic, while 3.3.4 boots fine. =
I have
>> my root on raid 5 with an internal bitmap, and the kernel panic occu=
rs if I
>> use the built-in kernel autodetect or during the root array assembly=
 via
>> mdadm inside a dracut-generated initramfs. I bisected it down to the
>> following commit:
>> 61a0d80ce4ab5b4fb9ecb38f1fb19654778b71ed
>>
>> md/bitmap: discard CHUNK_BLOCK_SHIFT macro
>>
>> Be redefining ->chunkshift as the shift from sectors to chunks rathe=
r than
>> bytes to chunks, we can just use "bitmap->chunkshift" which is short=
er than
>> the macro call, and less indirect.
>>
>> Signed-off-by: NeilBrown <neilb@suse.de>
>>
>> My bisect testing including a scary commit where 2 of 3 drives had t=
heir
>> UUIDs zeroed when I booted with it! Fortunately I found the mailing =
list
>> archives with the solution and I was able to recover everything and =
keep
>> bisecting (although I was tempted to quit and just give the range of
>> commits...).
>>
>> I hope this fix can make it into the next 3.4-rc kernel.
>
> I do too, but first I would need to know what the fix is, and I canno=
t see
> anything in that commit what would change the behaviour of md at all.
>
> Do you have a copy of the full stack trace provided when Linux crashe=
d? =A0That
> could be useful.
> Also what bitmap chunk size are you using? Maybe the output of
> =A0mdadm -X
> and
> =A0mdadm -E
>
> of one of the devices in the array would help.
>
> Thanks a lot for the report and going to the trouble of bisecting, it=
 is
> really appreciated.
>
> NeilBrown

I'm not sure how to go about getting the full stack trace. The
motherboard has no serial port, so that's not an option. Unless the
kernel supports USB to serial adapters for that purpose, in which case
I might be able to borrow a couple Keyspans. Or I could sit and try
and transcribe the whole thing...(!) I'm a little nervous about
tripping the all-zeros UUID bug again, although it only happened once
and it doesn't seem to be related to that commit. Anyway, here's some
data from the array:

# mdadm -E /dev/sda3
/dev/sda3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 60bf4ee8:e6e3e14f:073e21cd:ed2abb54
  Creation Time : Wed May  2 20:22:47 2012
     Raid Level : raid5
  Used Dev Size : 29302400 (27.94 GiB 30.01 GB)
     Array Size : 58604800 (55.89 GiB 60.01 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 127

    Update Time : Wed May  2 23:01:45 2012
          State : active
Internal Bitmap : present
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 863c968f - correct
         Events : 2

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       8        3        0      active sync   /dev/sda3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8       35        2      active sync   /dev/sdc3

# mdadm -X /dev/sda3
        Filename : /dev/sda3
           Magic : 6d746962
         Version : 4
            UUID : 60bf4ee8:e6e3e14f:073e21cd:ed2abb54
          Events : 1
  Events Cleared : 1
           State : OK
       Chunksize : 64 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 29302400 (27.94 GiB 30.01 GB)
          Bitmap : 448 bits (chunks), 0 dirty (0.0%)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
