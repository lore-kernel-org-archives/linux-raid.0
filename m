From: Doug Dumitru <doug@easyco.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Mon, 4 Jan 2016 11:13:37 -0800
Message-ID: <CAFx4rwQ+3w3v-QmiYoQu=5aApc4KyiykF+KdtMUG4v6-fBh22g@mail.gmail.com>
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
 <CAFx4rwQvTrUEskJxdc6CpvGu3uVYOJWEvHmMkqmNbmTgTVT0-Q@mail.gmail.com> <F7761B9B1D11B64BBB666019E9378117FE79E5@CFWEX01.americas.cray.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FE79E5@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robert,

The "FastWrite" code requires a complete stripe all contained inside
of a single BIO.  Depending on your drive count and stripe size, you
could end up above the BIO size limit (1MB for most kernels).  You
might try a smaller chunk size.

Our "application" calls this from a kernel thread, so there may be
other issue that happen if you drive this from user space.  I would
have thought that O_DIRECT would work OK from user space, but have not
tried it.

There is a huge if statement that tests for the FastWrite leg in the
patch.  Pretty much all of the planets need to align for the code to
get used.  printk statements are your friend ;)

Your code changes were probably mostly "bi_iter" stuff with the new
bio iterator structure.  If the code compiles, you probably made the
correct changes.  Plus, it did not crash (this is where a serial
console is helpful ;) ).

Doug

On Mon, Jan 4, 2016 at 10:56 AM, Robert Kierski <rkierski@cray.com> wrote:
> Hey Doug,
>
> I'm trying to get the patch to work and not having much luck.
>
> I'm guessing that you're using the generic CentOS 7 kernel (3.10).  I'm using a 3.18.4 kernel, so there were a few changes I had to make to get the patch to apply.  But they weren't significant as far as I can tell, and shouldn't have caused the FastWrite code to be ignored.
>
> There must be additional changes in the kernel that are necessary.  When I create the special case MDRaid, and then use the special case IO pattern, I see only the debug messages indicating that the FastWrite code was ignored.
>
> I've added more debugging code to try to understand what's going on.  It turns out that no matter what I do, no matter how I configure the MDRaid, and no matter what IO pattern I use, the size of the IO is such that it doesn't conform to the criteria required to call FastWrite.  It seems that in the 3.18 .4 kernel, IO's are broken up before calling MDRaid's make_request function.  There doesn't seem to be an obvious relationship between the size being passed in, and the chunk size that's configured by mdadm.
>
> At first, it appeared that it was the minimum IO size being used.  But then I tried setting the minimum IO and optimal IO to the same thing.  The resulting IO's are now 1/2 the size of the minimum IO.... which is not the size of the optimal IO (which is the chunk size * number of data disks).
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
