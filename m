From: Bostjan Skufca <bostjan@a2o.si>
Subject: Re: Raid 1 vs Raid 10 single thread performance
Date: Thu, 11 Sep 2014 07:20:48 +0200
Message-ID: <CAEp_DRBOeg8r8qUnMKM7tR9YbcP6Yb2HupUzSb1zzFPv7Q3ePA@mail.gmail.com>
References: <CAEp_DRAVPBvA34kgdjWqO6f6489SbmHQf-dFXC_SwSQd8e0C2w@mail.gmail.com>
	<20140911103110.42449c9e@notabene.brown>
	<CAEp_DRANDtdBCmRCqfiMeyfDg2+-q_EGsrs97QcE744Otqg0Og@mail.gmail.com>
	<20140911145911.47c0d857@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140911145911.47c0d857@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11 September 2014 06:59, NeilBrown <neilb@suse.de> wrote:
> On Thu, 11 Sep 2014 06:48:31 +0200 Bostjan Skufca <bostjan@a2o.si> wrote:
>
>> On 11 September 2014 02:31, NeilBrown <neilb@suse.de> wrote:
>> > On Wed, 10 Sep 2014 23:24:11 +0200 Bostjan Skufca <bostjan@a2o.si> wrote:
>> >> What does "properly" actually mean?
>> >> I was doing some benchmarks with various raid configurations and
>> >> figured out that the order of devices submitted to creation command is
>> >> significant. It also makes raid10 created in such mode reliable or
>> >> unreliable to a device failure (not partition failure, device failure,
>> >> which means that two raid underlying devices fail at once).
>> >
>> > I don't think you've really explained what "properly" means.  How exactly do
>> > you get better throughput?
>> >
>> > If you want double-speed single-thread throughput on 2 devices, then create a
>> > 2-device RAID10 with "--layout=f2".
>>
>> I went and retested a few things and I see I must have done something
>> wrong before:
>> - regardless whether I use --layout flag or not, and
>> - regardless of device cli arg order at array creation time,
>> = I always get double-speed single-thread throughput. Yaay!
>>
>> Anyway, the thing is that regardless of -using -layout=f2 or not,
>> redundancy STILL depends on the order of command line arguments passed
>> to mdadm --create.
>> If I do:
>> - "sda1 sdb1 sda2 sdb2" - redundandcy is ok
>> - "sda1 sda2 sdb1 sdb2" - redundancy fails
>>
>> Is there a flag that ensures redundancy in this particular case?
>> If not, don't you think the naive user (me, for example) would assume
>> that code is smart enough to ensure basic redundancy, if there are at
>> least two devices available?
>
> I cannot guess what other people will assume.  I certainly cannot guard
> against all possible incorrect assumptions.
>
> If you create an array which doesn't have true redundancy you will get a
> message from the kernel saying:
>
>   %s: WARNING: %s appears to be on the same physical disk as %s.
>   True protection against single-disk failure might be compromised.
>
> Maybe mdadm could produce a similar message...

I've seen it. Kernel produces this message in both cases.


>> Because, if someone wants only performance and no redundancy, they
>> will look no further than raid 0. But raid10 strongly hints at
>> redundancy being incorporated in it. (I admit this is anecdotal, based
>> on my own experience and thought flow.)
>
> I really don't think there is any value is splitting a device into multiple
> partitions and putting more than one partition per device into an array.
> Have you tried using just one partition per device, making a RAID10 with
> --layout=f2 ??

Yep, I tried raid10 on 4 devices with layout=f2, it works as expected.
No problem there.
And I know it is better if you have 4 devices for raid10, you are
right there. That is the expected use case.

But if you only have 2, you are limited to the options with those two.
Now, if I create raid1 on those two, I get bad single-threaded read
performance. This usually does not happen with hardware RAIDs.

This is the reason I started looking into posibility of using multiple
partitions per disk, to get something which reads off both disks even
for single "client". Raid10 seemed an option, and it works, albeit a
bit hackish ATM.

This is also the reason I asked for code locations, to look at it and
maybe send in patches for review which make a bit more inteligent
data-placement guesses in the case mentioned above. Would this be an
option of interest to actually pull it it?

b.
