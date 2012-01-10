From: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: Giving top priority to a rebuild instead of serving userland?
Date: Tue, 10 Jan 2012 02:42:09 +0200
Message-ID: <4F0B8961.80308@iki.fi>
References: <20120109142116.GA34289@cons.org> <CAGRgLy65r4DsK0_tL57J9=iB+JvDiZ-0ZxZfbtkC44TcQvRa2Q@mail.gmail.com> <20120109215759.GA85361@cons.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120109215759.GA85361@cons.org>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Cracauer <cracauer@cons.org>
Cc: Alexander Lyakas <alex.bolshoy@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09.01.2012 23:57, Martin Cracauer wrote:
> Alexander Lyakas wrote on Mon, Jan 09, 2012 at 10:40:49PM +0200: 
>> Hi,
>>
>> Have you tried to play with:
>> /proc/sys/dev/raid/speed_limit_max
>> /proc/sys/dev/raid/speed_limit_min
>> /sys/block/mdXXX/md/sync_speed_min
>> /sys/block/mdXXX/md/sync_speed_max
>>
>> For me these work very well. You can also set min > max, in which case
>> max is totally ignored.
>> According to the kernel code, md keeps submitting sync requests until
>> it reaches the minimum speed, and then it checks the "userland" IO and
>> the high speed limit.
> 
> Looks like what I need.  Thanks so much.
> 
> These two sets are identical in functionality (other than one being
> per-set), right?

Yes.

I also often set minimum sync speed for the same reasons as you (i.e.
there is light-to-moderate unimportant userspace I/O going on which
slows down reshape/rebuild considerably), however, at least in the past
I could stall the userspace processes (almost?) completely by setting a
too high minimum sync speed, so I had to leave some significant margin
for userspace I/O and speed fluctuation.

It'd be nice if md could handle the kind of prioritizing you describe
itself dynamically (if it is reasonably possible, that is), but I guess
that would be very low-priority feature request as changing the min sync
speed usually suffices :)

> Martin
> 
>> Alex.
>>
>>
>> On Mon, Jan 9, 2012 at 4:21 PM, Martin Cracauer <cracauer@cons.org> wrote:
>>> I am doing a resize on a 4 x 1 TB raid5 array (going to 5x 1 TB).
>>>
>>> When there is no userland I/O it reports about 1000 minutes to
>>> rebuild. ?However, minor amount of userland demand makes it shoot up
>>> to 3500-4000 as the rebuild puts it's own interests behind.
>>>
>>> However, the I/O there is garbage, in this case a disk-noisy web
>>> browser. ?Can I tell md to give priority to it's rebuild and serve
>>> userland as it pleases with -say- a maximum of 10% rebuild time
>>> increase? Yes I know that'll make the system very sluggy.
>>>
>>> I would be finished already but overnight I left a browser tab open
>>> that caused according to iostat 400-500 Blk_wrtn contiguously. ?That
>>> is when *not* actually using the browser (I'll report that as a bug).
>>> Now I am still at 38% rebuild. ?Didn't seem worth the price I payed :-)
>>>
>>> Martin
>>> --
>>> %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
>>> Martin Cracauer <cracauer@cons.org> ? http://www.cons.org/cracauer/
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at ?http://vger.kernel.org/majordomo-info.html
> 


-- 
Anssi Hannula
