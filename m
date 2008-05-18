From: David Greaves <david@dgreaves.com>
Subject: Re: questions about softraid limitations
Date: Sun, 18 May 2008 14:00:17 +0100
Message-ID: <48302861.3010607@dgreaves.com>
References: <002801c8b55a$60e4a360$0404a8c0@dcccs> <482AC2BB.5010602@dgreaves.com> <01be01c8b61a$6e616260$9300a8c0@dcccs> <482D479F.3040809@dgreaves.com> <022401c8b739$5262ba80$9300a8c0@dcccs> <482FF2DB.9060604@dgreaves.com> <07b301c8b8d7$f3e6d590$9300a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <07b301c8b8d7$f3e6d590$9300a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janos Haar wrote:
> The actually best way is this:
> 
> blockdev --setro /dev/SOURCE
> blockdev --setra  0 /dev/SOURCE
> ddrescue -v -b 4096 -B 1024 -e 1 -y 0 /dev/SOURCE /dev/TARGET (if you
> dont use a real clean disk with full of zeros, you need the -A option too)
> 
> + need some kernel patch to disable all retry on the source disk.
Is that something you could share?

It sounds like something that would be worth including in the libata error
handling to be controlled by something like /sys/block/sdX/device/ioerr_retry_count

I'd be interested in playing with it and sending to Tejun Heo if you don't have
time.

> The best recovery history is in 3 steps:
> 
[snip]
> 
> There is no easy solution. :-(

OK - I'll put this up on the wiki sometime.

>> Hmm - I wonder if things like ddrescue could work with the md bitmaps
>> to improve
>> this situation?
>> Is this related to David Lethe's recent request?
> 
> I think ddrescue is for copy/rescue the data, not for processing it.
> But can log the errors... ;-)
Yes - I meant to take the ddrescue output and manipulate the bitmap on the
copied drive to mark certain parts as 'bad'.
Ideally this could be done in the event of a dual-failure so that you could
re-add 2 failed drives and the bitmaps could indicate.

This may requires something closer to a bytemap but...


David
