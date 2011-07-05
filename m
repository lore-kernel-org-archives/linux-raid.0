From: "Cal Leeming [Simplicity Media Ltd]"
	<cal.leeming@simplicitymedialtd.co.uk>
Subject: Re: Curious problem with asynchronous RAID1 rebuild operations
Date: Tue, 5 Jul 2011 11:52:38 +0100
Message-ID: <CALvtuFR82Sg+M9x3NKYA0bRXvoFGvp=Gs_TuChwJ7FsRwtGSaw@mail.gmail.com>
References: <CALvtuFQ_c_-8DqKGaTV6LjL0JXC=8VKPKyx5U1Be49fepLcWzg@mail.gmail.com>
	<20110705103404.0ed0e9bb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110705103404.0ed0e9bb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the reply.

Sadly, this specific server is 150 miles away in colo, and only has a
single on-board controller (it's a Dell R310).

I'd be surprised if it was controller/contention related, but I
certainly won't rule it out.

Cal

On Tue, Jul 5, 2011 at 1:34 AM, NeilBrown <neilb@suse.de> wrote:
> On Sat, 2 Jul 2011 12:07:54 +0100 "Cal Leeming [Simplicity Media Ltd]=
"
> <cal.leeming@simplicitymedialtd.co.uk> wrote:
>
>> Hi all,
>>
>> I tried to rebuild/sync two RAID1 arrays at the same time, with stra=
nge results.
>>
>> When a new drive was added into md0, it started to sync fine at
>> 123,000kb/sec. Whilst that was running, I also added a new drive int=
o
>> md1, and this causes both arrays sync speed to slow down to
>> 20,000kb/sec. I checked the=A0/proc/sys/dev/raid/speed_limit_{min|ma=
x}
>> and these were both set fine.
>>
>> I removed the drive from md1, and the md0 sync went back to the norm=
al speed.
>>
>> RAID Setup:
>> md0 - 2 drives (2TB Western Digital)
>> md1 - 2 drives (500GB M3 SDD)
>>
>> So my question is, does anyone know why the sync speed (on all array=
s)
>> slowed down to almost 6-7 times the norm, when two (or more?) sync
>> operations are taking place?
>>
>
> Dodgy controller? =A0I assume both arrays are on the same controller.
>
> Can you plug in a separate controller even if only temporarily and se=
e what
> happens?
>
> I can see how any interaction with md would have this effect.
>
> NeilBrown
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
