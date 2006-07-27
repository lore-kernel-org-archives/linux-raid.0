From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH] md: new bitmap sysfs interface
Date: Thu, 27 Jul 2006 10:55:32 -0400
Message-ID: <44C8D3E4.8040600@steeleye.com>
References: <44C5BA6F.3010404@steeleye.com>	 <170fa0d20607261430n3e9d3962xeef50669ce0d1996@mail.gmail.com>	 <44C8248B.7010501@steeleye.com> <170fa0d20607270728y176c3faega872bfa031342485@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20607270728y176c3faega872bfa031342485@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Mike Snitzer wrote:
> On 7/26/06, Paul Clements <paul.clements@steeleye.com> wrote:

>> Right. At the time of the failover, there were (probably) blocks that
>> were out of sync between the primary and secondary.
> 
> OK, so now that I understand the need to merge the bitmaps... the
> various scenarios that create this (potential) inconsistency are still
> unclear to me when you consider the different flavors of raid1.  Is
> this inconsistency only possible if using async (aka write-behind)
> raid1?

No. Even with a synchronous (normal) raid1, you will probably have 
blocks that are out of sync when one disk (or server) fails. This is 
true even of raid1's using internal disks. That's why you resync the 
array after a failure (of the system or of one of the disks). That's 
exactly what the bitmap is for -- to optimize that resync.

--
Paul
