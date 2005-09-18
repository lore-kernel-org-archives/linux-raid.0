From: "Jonathan Schmidt" <jon@impact-ltd.ca>
Subject: Re: Good, recent FS comparison?
Date: Sun, 18 Sep 2005 10:54:37 -0700
Message-ID: <dgk9ku$g4o$1@sea.gmane.org>
References: <6d5bedd8050915131148b8108a@mail.gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got the same opportunity as well -- setting up a new RAID, and having 
to choose a filesystem.  I've used reiser3 and liked it, but I'm weary of 
reiser4 just because it's so new.  My one and only concern is data 
integrity.  CPU use, efficiency, etc are of no concern.  It sounds like the 
reason to use XFS is because of speed, so that doesn't interest me.

Are there any filesystems with error-correcting built in?  Reiser4 could 
probably do it with a plugin, but Hans Reiser would probably also tell me 
that error correction has no place in the filesystem code :)  Maybe I'm just 
paranoid.

"Ewan Grantham" <ewan.grantham@gmail.com> wrote in message 
news:6d5bedd8050915131148b8108a@mail.gmail.com...
> I've just setup a nice, 6-disk, USB-2 300 Gig/disk array, and was
> prepared to follow my normal pattern of installing ext3 as the
> filesystem. However, I saw the interview with Hans Reiser about
> ReiserFS4, and am now wondering if reiser has really improved enough
> to use it, or if ext3 is still the way to go?
>
> Any thoughts?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



