From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Backups using RAID1
Date: Thu, 20 Nov 2008 17:20:00 -0500
Message-ID: <4925E290.4060500@tmr.com>
References: <c268e4660811170713y64b2a707p2d0fcfbca0b0d1c6@mail.gmail.com>	 <62c47030811191213n49a50624k4a0e167f20193a4@mail.gmail.com>	 <c268e4660811191811y2b3d11d9na6bd3a64b636d217@mail.gmail.com>	 <d5fe39840811192328r6ddf6840y6f86683401bdf533@mail.gmail.com> <c268e4660811200724x5a6a1fffueb2741ccc20006b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660811200724x5a6a1fffueb2741ccc20006b1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Drew wrote:
>> If you don't care about location-based risks (eg fire), then I don't
>> see why you would bother removing the drives. Leaving disks in the
>> machine basically only protects you against 'oops' moments (rm -rf and
>> such like)., but not much else.
>>     
>
> In this instance location based risks (fire, earthquake) are a
> concern. My original idea when I started exploring backup ideas was
> something I could leave unattended to start when I went to bed and if
> for some reason I was forced to evacuate in the wee hours of the
> morning all I had to do was yank the drives from the server and leave.
>
> As far as oops moments, only the applications have direct access to
> files on disk. All user access to disks is via Samba and I've enabled
> the recycle bin vfs module.
>
>   
>> The advantage in RAID1 is that it makes a copy constantly, so it takes
>> no time to create the backup - using other methods (rsync, tape,
>> rdiff-backup) with a huge amount of data, this time can be
>> prohibitive.
>>     
>
> That was part of why I was looking at RAID for the backup. I've also
> had a few suggestions about getting an external eSATA drive and
> leaving it plugged in overnight. Just have a cron job do a nightly
> rsync or such and *if* I have to evacuate, hopefully rsync will be
> complete.
>
>   
If you are that paranoid about the backup, get two and use a different 
one each night. You can run a cron job to back stuff up (I've done it) 
every half hour or so, given three checks: (a) is the last one finished, 
(b) is the last modified time > 30 minutes (ie. is it done), and (c) has 
it been modified more recently than the last backup (touch a file at the 
end of backup).

Having dealt with both fire and earthquake, I doubt your wife will worry 
about the recordings, just getting the people and pets out, and whatever 
paperwork you have in your fireproof safe (in case time is tight).
>> Also, I'd say that plugging/unplugging disks would historically be a
>> problem, but SATA shouldn't be, IMO. Also, there are solutions
>> specifically designed for plugging/unplugging - which makes the point
>> moot - so you might consider one of those.
>>     
>
> My SATA controller supports hot plugging so I'm not worried there.
>
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


