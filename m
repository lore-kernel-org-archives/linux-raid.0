From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Life's too short ...(Raid 1 sync times)
Date: Sun, 29 Feb 2004 20:47:34 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0402292047030.1674@unicorn.drogon.net>
References: <40423D29.1050401@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40423D29.1050401@sauce.co.nz>
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 1 Mar 2004, Richard Scobie wrote:

> I have tested with software RAID5 and have just attempted to do the same
> for software RAID 10. Unfortunately, it is going to take 31000 minutes,
> or around 21 days to sync this array and I wish to test 3 different
> stripe sizes. Is there some way to allow more bandwidth for the sync up?

echo 999999 > /proc/sys/dev/raid/speed_limit_max

Gordon
