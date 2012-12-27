From: Mark Knecht <markknecht@gmail.com>
Subject: Re: md: kicking non-fresh sdf3 from array!
Date: Thu, 27 Dec 2012 13:38:17 -0800
Message-ID: <CAK2H+eftxdnkg3nFU=3NnH-7RQ0pcoYNdbDgMLyFpOzhCcg5Dw@mail.gmail.com>
References: <CAK2H+effDWFWP32wO4vXPSQ16tgZKdBwvQRRiq+Qpy03VCE6xA@mail.gmail.com>
	<50DCA819.80809@turmel.org>
	<CAK2H+ecBALbrpshYQ5TZhuOJh_kgXqi_C90Zp-FtCgaE4dEgSw@mail.gmail.com>
	<50DCAE69.1080003@turmel.org>
	<50DCAEAD.3090205@turmel.org>
	<CAK2H+efAsceZge7==Y8KrXE0AKJJqRZH0G4SCzzdUewStGTqkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+efAsceZge7==Y8KrXE0AKJJqRZH0G4SCzzdUewStGTqkg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 27, 2012 at 12:52 PM, Mark Knecht <markknecht@gmail.com> wrote:
> On Thu, Dec 27, 2012 at 12:25 PM, Phil Turmel <philip@turmel.org> wrote:
>> Whoops!  The list was dropped...
>>
>> On 12/27/2012 03:24 PM, Phil Turmel wrote:
>>> On 12/27/2012 03:20 PM, Mark Knecht wrote:
>>>> Thanks Phil,
>>>>    I've added the device back in and the rebuild is proceeding.
>>>>
>>>>    So the new piece of info here for me is this idea of a bitmap. I'll
>>>> have to go look into that, but a quick question - is that something
>>>> that can be added to the RAID6 at this time, or can you only do that
>>>> when you first build it? As I have some issue with my (possibly)
>>>> initramfs I expect I'll kick the devices a few more times before I get
>>>> it worked out. Would be nice if putting the disk back in didn't take
>>>> so long.
>>>
>>> You can add a bitmap to any v1.x array after the fact with "--grow".  It
>>> does add a little overhead to the write path, so you might not want it
>>> in a heavily loaded server.  For a test-bed or other system prone to
>>> crashes, it's a godsend.
>>>
>>> Phil
>
>
> So it was. Thanks for catching that.
>
> OK, so adding the bitmap looks straight-forward
>
> mdadm --grow --bitmap=internal /dev/md3
>
> and then wait, although I think I can continue to use the RAID while
> this is progressing.
>
> I cannot see that someone like me (or rather my usage model - home
> compute server doing 2 or 3 fairly heavily loaded Windows VMs most of
> the day) would want anything other than an internal bitmap, correct?
> Note that the VM files actually reside on a different RAID, which is
> rather unfortunately part of the same set of disks but different
> partitions. As I said, this has been a learning process. (!) My hope
> is that over time I can move all of these different things to this one
> RAID6, reclaim disk space, grow the RAID6, etc., until I get the whole
> disk back.
>
> Thanks,
> Mark

So I went ahead and tried adding it, first to md6 which has a
different usage and then to md3. It only takes a couple of seconds to
add and no problems so far.

- Mark
