From: Bostjan Skufca <bostjan@a2o.si>
Subject: Re: Raid 1 vs Raid 10 single thread performance
Date: Tue, 16 Sep 2014 09:48:28 +0200
Message-ID: <CAEp_DRAifxNPscq_jUuUM9+1r_1aJzi-W1UnH=jTYa3oxRspqg@mail.gmail.com>
References: <CAEp_DRAVPBvA34kgdjWqO6f6489SbmHQf-dFXC_SwSQd8e0C2w@mail.gmail.com>
	<5412B38E.5040205@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5412B38E.5040205@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David and Neil, thanks for hints!

(I was busy with other things lately, but believe it or not I got the
"why not try raid 10 with only 2 partitions" idea just last night,
tested it a couple of minutes ago with fascination, and now here I am
reading your emails - please do not remind me again of time wasted :)

The write performance is curious though:
- f2: 147 MB/s
- n2: 162 MB/s
I was expecting greater difference (bu I must admit this was not
tested on the whole 3TB disk, just 400GB partition on it).

b.


On 12 September 2014 10:49, David Brown <david.brown@hesbynett.no> wrote:
> On 10/09/14 23:24, Bostjan Skufca wrote:
>> Hi,
>>
>> I have a simple question:
>> - Where is the code that is used for actual RAID 10 creation? In
>> kernel or in mdadm?
>>
>>
>> Explanation:
>>
>> I was dissatisfied with single-threaded RAID 1 sequential read
>> performance (basically boils down to the speed of one disk). I figured
>> that instead of using level 1 I could create RAID level 10 and use two
>> equally-sized partitions on each drive (instead of one).
>>
>> It turns out that if array is created properly, it is capable of
>> sequential reads at almost 2x single device speed, as expected (on
>> SSD!) and what would anyone expect from ordinary RAID 1.
>>
>> What does "properly" actually mean?
>> I was doing some benchmarks with various raid configurations and
>> figured out that the order of devices submitted to creation command is
>> significant. It also makes raid10 created in such mode reliable or
>> unreliable to a device failure (not partition failure, device failure,
>> which means that two raid underlying devices fail at once).
>>
>> Sum:
>> - if such array is created properly, it has redundancy in place and
>> performs as expected
>> - if not, it performs as raid1 and fails with one physical disk failure
>>
>> I am trying to find the code responsible for creation of RAID 10 in
>> order to try and make it more inteligent about where to place RAID 10
>> parts if it gets a list of devices to use, and some of those devices
>> are on the same physical disks.
>>
>> Thanks for hints,
>> b.
>>
>>
>>
>> PS: More details about testing is available here, but be warned, it is
>> still a bit hectic to read:
>> http://blog.a2o.si/2014/09/07/linux-software-raid-why-you-should-always-use-raid-10-instead-of-raid-1/
>
>
> Hi,
>
> First let me applaud your enthusiasm for trying to inform people about
> raid in your blog, your interest in investigating different ideas in the
> hope of making md raid faster and/or easier and/or safer.
>
> Then let me tell you your entire blog post is wasted, because md already
> has a solution that is faster, easier and safer than anything you have
> come up with so far.
>
> You are absolutely correct about the single-threaded read performance of
> raid1 pairs - for a number of reasons, a single thread read will get
> reads from only one disk.  This is not a problem in many cases, because
> you often have multiple simultaneous reads on "typical" systems with
> raid1.  But for some cases, such as a high performance desktop, it can
> be a limitation.
>
> You are also correct that the solution is basically to split the drives
> into two parts, pair up halves from each disk as raid1 mirrors, and
> stripe the two mirrors as raid0.
>
> And you are correct that you have to get the sets right, or you will may
> lose redundancy and/or speed.
>
> Fortunately, Neil and the other md raid developers are way ahead of you.
>
> Neil gave you the pointers in one of his replies, but I suspect you did
> not understand that Linux raid10 is not limited to the arrangement of
> traditional raid10, and thus did not see his point.
>
> md raid and mdadmin already support a very flexible form of raid10.
> Unlike traditional raid10 that requires a multiple of 4 disks, Linux
> raid10 can work with /any/ number of disks greater than 1.  There are
> various layouts that can be used for this - the Wikipedia entry gives
> some useful diagrams:
>
> <http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10>
>
> You can also read about it in the mdadm manual page, and various
> documents and resources around the web.
>
>
> In your particular case, what you want is to use "--layout raid10,f2" on
> your two disks.  This asks md to split each disk (or the partitions you
> use) into two parts, without creating any new partitions.  The first
> half of disk 1 is mirrored with the second half of disk 2, and vice
> versa, then these mirrors are striped.  This is very similar to the
> layout you are trying to achieve, except for four points:
>
> The mirrors are crossed-over, so that a first half is mirrored with a
> second half.  This makes no difference on an SSD, but makes a huge
> difference on a hard disk.
>
> mdadm and md raid get the ordering right every time - there is no need
> to worry about the ordering of the two disks.
>
> You don't have to have extra partitions, automatic detection works, and
> the layout has one less layer, meaning less complexity and lower latency
> and overheads.
>
> md raid knows more about the layout, and can use it to optimise the speed.
>
>
> In particular, md will (almost) always read from the outer halves of the
> disks.  On a hard disk, this can be twice the speed of the inner layers.
>
> Obviously you pay a penalty in writing when you have such an arrangement
> - writes need to go to both disks, and involve significant head
> movement.  There are other raid10 layouts that have lower streamed read
> speeds but also lower write latencies (choose the balance you want).
>
>
> With this in mind, I hope you can try out raid10,f2 layout on your
> system and then change your blog to show how easy this all is with md
> raid, how practical it is for a fast workstation or desktop, and how
> much faster such a setup is than anything that can be achieved with
> hardware raid cards or anything other than md raid.
>
> mvh.,
>
> David
>
