From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Tue, 21 Jan 2014 11:31:02 -0700
Message-ID: <F3902817-7550-4A04-A606-6B360D9FF485@colorremedies.com>
References: <20140121073540.GF10140@merlins.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140121073540.GF10140@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 21, 2014, at 12:35 AM, Marc MERLIN <marc@merlins.org> wrote:

> Howdy,
> 
> I'm setting up a new array with 5 4TB drives for which I'll use dmcrypt.
> 
> Question #1:
> Is it better to dmcrypt the 5 drives and then make a raid5 on top, or the opposite
> (raid5 first, and then dmcrypt)

I'm pretty sure there are multithreading patches for dmcrypt, but I don't know what versions it's accepted into, and that's the question you need to answer. If the version you're using still only supports one encryption thread per block device, then you want to dmcrypt 5 drives, then create md on top of that. This way you get 5 threads doing encryption rather than 1 thread and hence one core trying to encrypt for 5 drives.


> I suppose that 1 day-ish rebuild times are kind of a given with 4TB drives anyway?

4000000MB / 135MB/s = 8.23 hours. So 24 hours seems like a long time and I'd wonder what the bottleneck is.



> Question #3:
> Since I'm going to put btrfs on top, I'm almost tempted to skip the md raid5
> layer and just use the native support, but the raid code in btrfs still
> seems a bit younger than I'm comfortable with.
> Is anyone using it and has done disk failures, replaces, and all?

Like I mentioned on linux-btrfs@ it's there for testing. If you're prepared to use it with the intent of breaking it and reporting breakage, then great, that's useful. If you're just being impatient, expect to get bitten. And it's undergoing quite a bit of changes in btrfs-next. I'm not sure if those changes will appear in 3.14 or 3.15



Chris Murphy

