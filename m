From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: Ok to go ahead with this setup?
Date: Thu, 22 Jun 2006 20:04:38 +0200
Message-ID: <62b0912f0606221104q2f47f574i86441efed5831957@mail.gmail.com>
References: <bb145bd20606221008p131d4daem289a6b9300757c66@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20606221008p131d4daem289a6b9300757c66@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christian Pernegger wrote:
> Intel SE7230NH1-E mainboard
> Pentium D 930

HPA recently said that x86_64 CPUs have better RAID5 performance.

> Promise Ultra133 TX2 (2ch PATA)
>    - 2x Maxtor 6B300R0 (300GB, DiamondMax 10) in RAID1
>
> Onboard Intel ICH7R (4ch SATA)
>    - 4x Western Digital WD5000YS (500GB, Caviar RE2) in RAID5

Is it a NAS kind of device?

In that case, drop the 2x 300GB disks and get 6x 500GB instead.  You
can partition those so that you have a RAID1 spanning the first 10GB
of all 6 drives for use as the system partition, and use the rest in a
RAID5.

> * Does this hardware work flawlessly with Linux?

No clue.

> * Is it advisable to boot from the mirror?

Should work.

>   Would the box still boot with only one of the disks?

If you configure things correctly - better test it.

> * Can I use EVMS as a frontend?

Yes.

>   Does it even use md or is EVMS's RAID something else entirely?

EVMS uses a lot of underlying software, MD being one component.

> * Should I use the 300s as a single mirror, or span multiple ones over
> the two disks?

What would the purpose be?

> * Am I even correct in assuming that I could stick an array in another
> box and have it work?

Work for what?

> Comments welcome

Get gigabit nics, in case you want to fiddle with iSCSI? :-).
