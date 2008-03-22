From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Redundancy check using "echo check > sync_action": error    
  reporting?
Date: Sat, 22 Mar 2008 13:13:23 -0400
Message-ID: <47E53E33.70800@tmr.com>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak>    <47E26775.3000500@tuxes.nl>    <20080320134747.GA28114@cthulhu.home.robinhill.me.uk>    <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu>    <20080320173906.GN32242@skl-net.de> <20080320180241.GJ13719@mit.edu> <42039.192.168.1.70.1206130781.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42039.192.168.1.70.1206130781.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Theodore Tso <tytso@MIT.EDU>, Andre Noll <maan@systemlinux.org>, Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> My problem with this is that I don't have a good model for what might
> cause the error, so I cannot reason about what responses are justifiable.
>
> The analogy with ECC memory is, I think, poor.  With ECC memory there are
> electro/physical processes which can cause a bit to change independently
> of any other bit with very low probability, so treating an ECC error as
> a single bit error is reasonable.
>
> The analogy with a disk drive would be a media error.  However disk drives
> record CRC (or similar) checks so that media errors get reported as errors,
> not as incorrect data.  So the analogy doesn't hold.
>
> Where else could the error come from?  Presumably a bit-flip on some
> transfer bus between main memory and the media.  There are several
> of these busses (mem to controller, controller to device, internal to
> device).  The corruption could happen on the write or on the read.
> When you write to a RAID6 you often write several blocks to different
> devices at the same time.  Are these really likely to be independent
> events wrt whatever is causing the corruption?
>   

Based on what I have read and seen, some of these errors come in pairs 
and are caused by a drive just writing to the wrong sector. This can 
come from errors in the O/S (unlikely), disk hardware (unlikely), or 
disk firmware (least unlikely). So you get the data written to the wrong 
place (makes that stripe invalid) and parity change or mirror copies 
written to the right place(s). Thus, two bad stripes to be detected on 
"check," neither of which will return a hardware error on a read.
> I don't know.  But without a clear model, it isn't clear to me that
> any particular action will be certain to improve the situation in
> all cases.
>
>   
Agreed, the only cases I've identified where improvement is possible is 
in the case of raid1 with multiple copies, and raid6. Doing the recovery 
I outlines the other day will not make things better in all cases, but 
will never make things worse (statistically) and should recover both 
failures if the cause is "single misplaced write."

> And how often does silent corruption happen on modern hard drives?
> How often do you write something and later successfully read something
> else when it isn't due to a major hardware problem that is causing
> much more that just occasional errors?
>
>   
Very seldom, all my critical data is checked by software CRC, and these 
failures just don't happen. But I have owned drives in the past which 
had software revisions which had error rates as high as 2/10TB, which 
went away on the same drives after firmware updates. So while it is 
rare, it can and does happen occasionally.

> So yes: there are lots of things that *could* be done.  But without
> a model for the "threat", an analysis of how the remedy would actually
> affect every different possible scenario, and some idea of the
> probability of the remedy being needed, it is very hard to
> justify a change of this sort.
>   

I hope I have provided a plausible model for one error source. If I have 
identified the model correctly, errors will always happen in pairs, in 
normal operation rather than during some unclean system shutdown due to 
O/S crash or power failure.

> And there are plenty of other things to be coded that are genuinely
> useful - like converting a RAID5 to a RAID6 while online...
>   

I would suggest that upgrading an array to larger drives is more common, 
having a fully automated upgrade path would be useful to far more users. 
So if I have (example) four 320GB drives, I want to upgrade to 500GB 
drives, I attacha 500GB drive and say something like "on /dev/md2 
migrate /dev/sda1 to /dev/sde1" and have it done in such a way that it 
will fail safe and at the end sda1 will be out of the array and sde1 
will be in, without having to enter multiple commands per drive to get 
this done.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


