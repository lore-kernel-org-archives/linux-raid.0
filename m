From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: md raid behavior, bad sector uncorrectable read error
Date: Sun, 19 Aug 2012 10:54:40 +0200
Message-ID: <CAGkViCFBqJJWeaA1Wrpc_BBw=wd1wV3nVrArEB51LJpJsrmsug@mail.gmail.com>
References: <3E06D7FC-092A-4CB6-B79C-7EC94424DEEE@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E06D7FC-092A-4CB6-B79C-7EC94424DEEE@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From what I know (and please correct me if I'm wrong), the drive
happily remaps the sector to a different, spare, location. Only when
it can't do that it throws an error status back. Mind you, more than
10 years ago I had a scsi disk in a linux machine which suddenly broke
down. Checking the logs I saw a lot of remap messages in the log in
the weeks before. So it maybe that the drive gives warnings back up
the controller chain.
If this is true, what is md doing with this? If the remaps increase on
that particular drive does i throw it out of the raid set?

Curious on what actually happens, interesting question.

Just my two cents,

Albert

On 19 August 2012 00:40, Chris Murphy <lists@colorremedies.com> wrote:
> I'm not experiencing this at the moment, but I'm curious about what happens if it were to happen.
>
> A drive detects a sector error, but can't correct it, and returns an 0x40 error to the system.
>
> Presumably md raid (any RAID I would think) becomes aware of this error, as the chunk is incomplete without the sector. Next, does md raid rebuild the affected chunk from parity on-the-fly? Or is the entire drive dropped from the array and placed into degraded mode?
>
> If the affected chunk is rebuilt from parity (or copy in case of mirror), does md raid issue a write command to write the rebuilt chunk back to the disk at the same LBAs? If so, shouldn't this force the drive to determine if the sector error is transient or persistent, and if persistent the disk firmware will remap the bad sector to a reserve sector?
>
> Thanks,
>
> Chris Murphy
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
