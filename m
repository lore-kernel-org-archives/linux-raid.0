From: Doug Dumitru <doug@easyco.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Mon, 4 Jan 2016 11:43:47 -0800
Message-ID: <CAFx4rwSo3MNqJGNQ3wHe49F+xQ6559aZdikPL4M3+HuD6uRz-Q@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
 <CAK2H+ed-3Z8SR20t8rpt3Fb48c3X2Jft=qZoiY9emC2nQww1xQ@mail.gmail.com>
 <CAE9DZUQHBycc5+Z2YrJtWZRYxOUMu3pgnaEQSrsyeCZEv8vndA@mail.gmail.com>
 <CAE9DZUT1v+CFZOs33CC+JrWcX_WHBu+WW78AynkWqJN+LLoqDA@mail.gmail.com>
 <CAK2H+ecMvDLdYLhMtMQbP7Ygw-VohG7LGZ2n7H+LAXQ1waJK3A@mail.gmail.com>
 <CAE9DZUSbt7Kfwd9S3K_SXY7fVRk-vq5RhrPzKs4XO8uhyfPh3Q@mail.gmail.com>
 <CAE9DZUQxT_5L0bW5m9SZ_d2GU6sZS8k0qD=g+o112qM4V=cJkw@mail.gmail.com>
 <22128.11867.847781.946791@quad.stoffel.home> <CAE9DZURepRB3k-pBnRg2Tx8GCzAr6zCzv+LJy4mK4CDdAkBYVQ@mail.gmail.com>
 <22128.35881.182823.556362@quad.stoffel.home> <CAE9DZUQNBPNXFs69JRU0Q82TQ4RjAgpsc7voMgEzuhSZhmDjig@mail.gmail.com>
 <CAE9DZUQqeCY__+8Fwg51PJc6zAk0J2Apm2TE3CRvxbFUf-xDKQ@mail.gmail.com>
 <CAK2H+eeD2k4yzuvL4uF_qKycp6A=XPe8pVF_J-7Agi8Ze89PPQ@mail.gmail.com>
 <5672BB7A.4050808@turmel.org> <CAE9DZUQj2TNX4Wpk5xbaCVzEgPq2D6Co7ZDNaAy-TOaB4hwZeA@mail.gmail.com>
 <567339F0.9000209@turmel.org> <CAE9DZUS+gmgTLr_4EUgLcPCPWknoqg640mCMZX46cxXeyT6RQA@mail.gmail.com>
 <CAE9DZUQoYtt3U5rGBAUtTuLS2N2uA80e=EcDD73fHq0qn6YH2w@mail.gmail.com>
 <CAFx4rwT8xgwZ0OWaLLsZvhMskiwmY54MzHgnnEPaswByeRrXxQ@mail.gmail.com>
 <CAFx4rwTUiMo=1+JXpY3P5BhZYSQC8MVYhTJfdJd7gL6r9WSAiA@mail.gmail.com>
 <CAE9DZUQoNh2uU1h4okY0Fz5wzVv6-ZTnet9tS-dNQRHsLnPvNg@mail.gmail.com>
 <CAFx4rwQvTrUEskJxdc6CpvGu3uVYOJWEvHmMkqmNbmTgTVT0-Q@mail.gmail.com>
 <F7761B9B1D11B64BBB666019E9378117FE79E5@CFWEX01.americas.cray.com>
 <CAFx4rwQ+3w3v-QmiYoQu=5aApc4KyiykF+KdtMUG4v6-fBh22g@mail.gmail.com> <F7761B9B1D11B64BBB666019E9378117FE7AB1@CFWEX01.americas.cray.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FE7AB1@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robert,

I have a C benchmark program that opens a block device with O_DIRECT
(040000 on x86 and 0200000 on arm) and reads/writes with 4K aligned
buffers show up as BIOs as hoped.

One easy way to "test" this is to add debug code to "dm-zero" and use
it as a way to watch IOs as they get to the block stack.

Doug


On Mon, Jan 4, 2016 at 11:33 AM, Robert Kierski <rkierski@cray.com> wrote:
> Hey Doug,
>
> I tried all sorts of things... even things that seemed rather backwards.  I tried a variety of disk count's, chunk sizes, IO sizes, IO Counts, etc.
>
> Yes...the changes were adding the bi_iter (mostly).
>
> I also eliminated the limit of 10 printk's so that I could try various MDRaid configurations and various block size and counts without having to reboot.
>
> I would have thought that the OS would pass the IO from user space to the driver without modification.  But it appears that's not the case.
>
> Bob Kierski
> Senior Storage Performance Engineer
> Cray Inc.
> 380 Jackson Street
> Suite 210
> St. Paul, MN 55101
> Tele: 651-967-9590
> Fax:  651-605-9001
> Cell: 651-890-7461
>



-- 
Doug Dumitru
EasyCo LLC
