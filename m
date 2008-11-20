From: "Max Waterman" <davidmaxwaterman@fastmail.co.uk>
Subject: Re: Backups using RAID1
Date: Thu, 20 Nov 2008 09:28:49 +0200
Message-ID: <d5fe39840811192328r6ddf6840y6f86683401bdf533@mail.gmail.com>
References: <c268e4660811170713y64b2a707p2d0fcfbca0b0d1c6@mail.gmail.com>
	 <62c47030811191213n49a50624k4a0e167f20193a4@mail.gmail.com>
	 <c268e4660811191811y2b3d11d9na6bd3a64b636d217@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660811191811y2b3d11d9na6bd3a64b636d217@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Of course, you could always *not* yank them; instead just fail them
(after unmounting/syncing/whatever) and leave the actual disk in the
machine.

Purists would likely argue this isn't true backup or something, but
backup can be taken to different extremes - it all depends on what
risks you want to protect yourself against.

If you don't care about location-based risks (eg fire), then I don't
see why you would bother removing the drives. Leaving disks in the
machine basically only protects you against 'oops' moments (rm -rf and
such like)., but not much else.

The advantage in RAID1 is that it makes a copy constantly, so it takes
no time to create the backup - using other methods (rsync, tape,
rdiff-backup) with a huge amount of data, this time can be
prohibitive.

Also, I'd say that plugging/unplugging disks would historically be a
problem, but SATA shouldn't be, IMO. Also, there are solutions
specifically designed for plugging/unplugging - which makes the point
moot - so you might consider one of those.

Having saidd that, this is Just my opinion, and I'm no expert...

Max.

2008/11/20 Drew <drew.kay@gmail.com>:
> On Wed, Nov 19, 2008 at 12:13 PM, Linux <linuxlist@gmail.com> wrote:
>>> In recent months I've been exploring low cost solutions for backing up
>>> the data on my home media server. I already run three raid-1 arrays on
>>> this rig to protect against drive failures and a fellow linux user
>>> suggested I consider using the existing raid, just yank the 'backup'
>>> disks as needed, and drop in fresh disks to replace the yanked unit.
>>
>> I guess this is a little risky. Plugging disks too often does not  sound good.
>> Is "rsync" not enough for you?
>
> A year ago my old 10GB Travan & 4 tapes was enough to backup my OS and
> data. In the last year I've seen my data storage jump from 40GB to 2TB
> courtesy of a MythTV installation. I'm still figuring out how to
> manage this large an amount of data and backup solutions are now on
> the table as it's been indicated to me that loss of important 'media'
> will result in a greatly lowered WAF(*).
>
>
> --
> Drew
>
> "Nothing in life is to be feared. It is only to be understood."
> --Marie Curie
>
> (*) WAF: Wife Acceptance Factor
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
