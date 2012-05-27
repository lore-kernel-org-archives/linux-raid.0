From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Hi! Strange issue with LSR -- bitmaps hadn't been used during 2
 of 3 RAIDs resync
Date: Mon, 28 May 2012 00:10:33 +0800
Message-ID: <CA+sTkh67PwRkuYyXMRHUFmJUmC==9KFJNnpK+SsAhCTB-48UOg@mail.gmail.com>
References: <CA+sTkh74rDvV05pjhVAD5wa4fxXsZE5MLN4y4fMd=Js7_BoTDQ@mail.gmail.com>
 <20120527220007.64fb230b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120527220007.64fb230b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27 May 2012 20:00, NeilBrown <neilb@suse.de> wrote:
> On Sun, 27 May 2012 19:32:40 +0800 Igor M Podlesny <for.poige+lsr@gma=
il.com>
> wrote:
>> =C2=A0 =C2=A0A power outage has happened to system (which was in "su=
spend"
>> state) with RAID-10, RAID-5 and RAID-6. Later on boot, RAID-10 was
>> fast re-synced using bitmap, but both RAID-5 and RAID-6 were in
>> auto-readonly mode with resync=3DDELAYED. When they flipped to
>> Read-Write, LSR started re-syncing not using bitmaps seemingly. A bu=
g?
>
> Maybe. =C2=A0But with so little detail it is hard to say.
> What made you think the bitmaps weren't being used?

   Well, it is reasonable to assume that host being put in suspend
mode wouldn't have much not synced data at all. RAID-10 had been
progressing its resync quite fast, it was obvious that it had been
using bitmaps for that. Moreover =E2=80=94 RAID-10 was the most I/O act=
ive
comparing to others, AFAIR.

> Did that arrays still have their bitmaps?

   I still have that RAID-6, yep:

md127 : active raid6 sdg5[2] sdf5[6] sde5[7] sda5[0] sdd5[3] sdc5[1]
      1071984640 blocks super 1.0 level 6, 1024k chunk, algorithm 2
[6/6] [UUUUUU]
      bitmap: 0/1 pages [0KB], 131072KB chunk

> Where they degraded?

   No way.

> How many bits were set in the bitmaps (probably too late to check now=
)?

   Please see above. And the RAID-5 one was recently dismissed, alas.

> Is it reproducable ? =C2=A0... OK, I don't really expect you to try t=
o reproduce
> it, but if you could that would be awesome!

   Well, might be VirtualBox would allow for such kind of experiment, d=
unno. )

   P. s. Oh, and BTW, I see 2.6.18 supplied by RedHat still has the
bug causing kernel panic when using WIB -- couldn't you please point
out is it due to they're missing some important bugfix you made later?

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
