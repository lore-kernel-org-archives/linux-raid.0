From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 00/11] Various cleanups and minor fixes
Date: Wed, 21 Mar 2012 08:58:09 +0100
Message-ID: <4F698A11.7020505@redhat.com>
References: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com> <20120321081130.239d577a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120321081130.239d577a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/20/12 22:11, NeilBrown wrote:
> On Tue, 20 Mar 2012 17:54:05 +0100 Jes.Sorensen@redhat.com wrote:
> 
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> This patch set implements a number of smaller cleanups, as well as
>> fixing a couple of cases where we don't zero out the full buffer we
>> just obtained via malloc.
> 
> All applied and push out - thanks.  There were a few conflict which some
> stuff I was working on, but nothing serious.

Excellent, thanks!

>> The most controversial is probably patch 06 which caches the device
>> block size for aligned read/writes in super1.c to avoid calling the
>> ioctl() on each write.
> 
> Yeah, it's a bit ugly, but seems reasonable.

Yeah, I was trying to find the cleanest way of doing it. I am
contemplating whether it makes sense to try and push this up the stack,
but I figured starting out small like this would be better.

> I think it might be nearly time for 3.2.4.  Do you have any thoughts about
> that?

I think it would be a good time - I have found it relatively quiet on
the bug report front since the 3.2.3 update, so jumping to 3.2.4 sounds
good.

Cheers,
Jes
