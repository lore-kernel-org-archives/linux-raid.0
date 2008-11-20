From: "Max Waterman" <davidmaxwaterman@fastmail.co.uk>
Subject: Re: Backups using RAID1
Date: Thu, 20 Nov 2008 18:12:27 +0200
Message-ID: <d5fe39840811200812t4ce197dav8f5fffc275029408@mail.gmail.com>
References: <c268e4660811170713y64b2a707p2d0fcfbca0b0d1c6@mail.gmail.com>
	 <62c47030811191213n49a50624k4a0e167f20193a4@mail.gmail.com>
	 <c268e4660811191811y2b3d11d9na6bd3a64b636d217@mail.gmail.com>
	 <d5fe39840811192328r6ddf6840y6f86683401bdf533@mail.gmail.com>
	 <c268e4660811200724x5a6a1fffueb2741ccc20006b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660811200724x5a6a1fffueb2741ccc20006b1@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2008/11/20 Drew <drew.kay@gmail.com>:
>> The advantage in RAID1 is that it makes a copy constantly, so it takes
>> no time to create the backup - using other methods (rsync, tape,
>> rdiff-backup) with a huge amount of data, this time can be
>> prohibitive.
>
> That was part of why I was looking at RAID for the backup. I've also
> had a few suggestions about getting an external eSATA drive and
> leaving it plugged in overnight. Just have a cron job do a nightly
> rsync or such and *if* I have to evacuate, hopefully rsync will be
> complete.

Well, I would have thought making your eSATA drive part of the RAID1
array would be plausible....even a good solution.

>
>> Also, I'd say that plugging/unplugging disks would historically be a
>> problem, but SATA shouldn't be, IMO. Also, there are solutions
>> specifically designed for plugging/unplugging - which makes the point
>> moot - so you might consider one of those.
>
> My SATA controller supports hot plugging so I'm not worried there.

I don't think the controller was the concern, though I could be wrong
- my take was it was more that the connectors might wear out or
something along those lines. Either a removable hard drive chassis or
an external eSATA drive would seem to fit the bill from that point of
view...

Max.
