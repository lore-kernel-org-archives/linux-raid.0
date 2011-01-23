From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID6 chunk size change?
Date: Sun, 23 Jan 2011 12:16:57 -0800
Message-ID: <AANLkTikAESsqaB7=6PRou_YwP0_U4oJh8ouB1-eDu3t_@mail.gmail.com>
References: <AANLkTimzLwmtMsrUdsLe9svywTFLbs_pZ8SXTCSyG4f4@mail.gmail.com>
	<AANLkTimRZgzDd5Na_F3XR8x6YE5wTyDjkBnQSCeCFbWe@mail.gmail.com>
	<20110124005204.71688cc2@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110124005204.71688cc2@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jan 23, 2011 at 11:52 AM, Roman Mamedov <rm@romanrm.ru> wrote:
> On Sun, 23 Jan 2011 11:10:40 -0800
> Mark Knecht <markknecht@gmail.com> wrote:
<SNIP>
>>
>> OK, I found a blog of Neil's in which I had read the top but hadn't
>> gone through the comments:
>>
>> http://neil.brown.name/blog/20090817000931
>> It seems he answers my question further down in the comments.
>>
>> Looks like
>>
>> mdadm --grow /dev/md7 --chunk=16
>
> I suggest that you reconsider going with 16K, it is a suboptimal chunk size.
> The older default of 64K seems to be the sweet spot, at least for RAID5/6:
> http://louwrentius.com/blog/2010/05/linux-raid-level-and-chunk-size-the-benchmarks/
>
> --
> With respect,
> Roman
>
Thanks for the link. That's good information.

I have no strong preference for 16K other than I have two RAID6's on
this set of drives and the one that's 16K tests in iozone as about 2
times faster than the 512K one that I want to change.

I can certainly try 64K, see how it works out, and then do the reshape
again if necessary.

My work model for this drive is basically running VMware virtual
machines. The bulk of the files stored on this RAID are 2GB files. I
have no idea how VMware (or Virtualbox which I also us) makes use
those files other than they represent the virtual hard drive.

Again, thanks for the info.

Cheers,
Mark
