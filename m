From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: New raid level suggestion.
Date: Thu, 30 Dec 2010 19:47:10 +1100
Message-ID: <4D1C470E.4080406@crc.id.au>
References: <20101230082356.GC2986@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101230082356.GC2986@bitwizard.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/12/2010 7:23 PM, Rogier Wolff wrote:
>
> Hi,
>
> A friend has a webserver. He has 4 drive bays and due to previous
> problems he's not content to have 3 or 4 drives in a raid5
> configuration, but he wants a "hot spare" so that when it takes him a
> week to find a new drive and some time to drive to the hosting
> company, he isn't susceptible to a second drive crashing in the
> meantime.
>
> So in principle he'll build a 3-drive RAID5 with a hot spare....
>
> Now we've been told that raid5 performs badly for the workload that is
> expected. It would be much better to run the system in RAID10. However
> if he'd switch to RAID10, after a single drive failure he has a window
> of about a week where he has a 33% chance of a second drive failure
> being "fatal".
>
> So I was thinking.... He's resigned himself to a configuration where
> he pays for 4x the disk space and only gets 2x the available space.
>
> So he could run his array in RAID10 mode, however when a drive fails,
> a fallback to raid5 would be in order. In this case, after the resync
> a single-drive-failure tolerance is again obtained.
>
> In practise scaling down to raid5 is not easy/possible. RAID4 however
> should be doable.
>
> In fact this can almost be implemented entirely in userspace. Just
> remove the mirror drive from the underlying raid0, and reinitialize as
> raid4. If you do this correctly the data will still be there....
>
> Although doing this with an active filesystem running on these drives
> is probably impossible due to "device is in use" error messages....
>
> So: Has anybody tried this before?
> Can this be implemented without kernel support?
> Anybody feel like implementing this?
>
> 	Roger.
>

Maybe I'm not quite understanding right, however you can easily do RAID6 
with 4 drives. That will give you two redundant, effectively give you 
RAID5 if I drive fails, and save buttloads of messing around...


-- 
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299
