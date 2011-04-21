From: David Brown <david.brown@hesbynett.no>
Subject: Re: Direct disk access on IBM Server
Date: Thu, 21 Apr 2011 13:36:34 +0200
Message-ID: <iop4s2$cjp$1@dough.gmane.org>
References: <iok28i$tp6$1@dough.gmane.org> <4DADEBC3.9060404@hardwarefreak.com> <iomfkq$qqr$1@dough.gmane.org> <4DAEC627.3030904@grumpydevil.homelinux.org> <iomj0a$e5m$1@dough.gmane.org> <4DAFCDB0.9070609@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DAFCDB0.9070609@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/04/11 08:24, Stan Hoeppner wrote:
> David Brown put forth on 4/20/2011 7:21 AM:
>
>> It's true that boot loaders and software raid can be an awkward
>> combination.
> ...
>> Yes, it's a few extra steps.
>
> More than a few. :)  With an LSI RAID card, I simply create a drive
> count X RAID5/6/10 array, set to initialize in the background, reboot
> the machine with my Linux install disk, create my partitions, install
> the OS ... done.  And I never have to worry about the bootloader
> configuration.
>
>> Okay, that's good to know.  LSI raid controllers are not hard to get, so
>
> And they're the best cards overall, by far, which is why all the tier 1s
> OEM them, including IBM, Dell, HP, etc.
>

That's also good to know.

>> I am not afraid of being able to find a replacement.  What I was worried
>> about is how much setup information is stored on the disks, and how much
>> is stored in the card itself.
>
> This information is duplicated in the card NVRAM/FLASH and on all the
> drives--been this way with most RAID cards for well over a decade.
> Mylex and AMI both started doing this in the mid/late '90s.  Both are
> now divisions of LSI, both being acquired in the early 2000s.  FYI the
> LSI "MegaRAID" brand was that of AMI's motherboard and RAID card products.
>

OK.

>> Yes, the raid card I have can do RAID10.  But it can't do Linux md style
>> raid10,far - I haven't heard of hardware raid cards that support this.
>
> What difference does this make?  You already stated you're not concerned
> with performance.  The mdraid far layout isn't going to give you any
> noticeable gain with real world use anyway, only benchmarks, if that.
>

I'm trying first to learn here (and you and the others on this thread 
have been very helpful), and establish my options.  I'm not looking for 
the fastest possible system - it's not performance critical.

But on the other hand, if I can get a performance boost for free, I'd 
take it.  That's the case with md raid10,far - for the same set of 
disks, using the "far" layout rather than a standard layout will give 
you faster performance on most workloads for the same cost, capacity and 
redundancy.  It's most relevant on 2 or 3 disks systems, I think.

> Some advice:  determine how much disk space you need out of what you
> have.  If it's less than the capacity of two of your 4 drives, use
> hardware RAID10 and don't look back.  If you need the capacity of 3,
> then use hardware RAID 5.  You've got a nice hardware RAID card, so use it.
>

I'm leaning heavily towards taking that advice.

>> For most uses, raid10,far is significantly faster than standard raid10
>
> Again, what difference does this make?  You already stated performance
> isn't a requirement.  You're simply vacillating out loud at this point.
>
>> It is certainly possible to do MD raid on top of HW raid.  As an
>> example, it would be possible to put a raid1 mirror on top of a hardware
>> raid, and mirror it with a big external drive for extra safety during
>> risky operations (such as drive rebuilds on the main array).  And if I
>> had lots of disks and wanted more redundancy, then it would be possible
>> to use the hardware raid to make a set of raid1 pairs, and use md raid5
>> on top of them (I don't have enough disks for that).
>
> With 4 drives, you could create two hardware RAID 0 arrays and mirror
> the resulting devices with mdraid, or vice versa.  And you'd gain
> nothing but unnecessary complexity.
>
> What is your goal David?  To vacillate, mentally masturbate this for
> weeks with no payoff?  Or build the array and use it?
>

My goal here is to understand my options before deciding.  I've had a 
bit of space between getting the machine and actually having the time to 
put it into service, so I've tested a bit and thought a bit and 
discussed a bit on this mailing list.  I'll probably go for hardware 
raid5 - which I could have done in the beginning.  But now I know more 
about why that's the sensible choice.

>> It is not possible to put an MD raid /under/ the HW raid.  I started
>> another thread recently ("Growing layered raids") with an example of
>> putting a raid 5 on top of a set of single-disk raid1 "mirrors" to allow
>> for safer expansion.
>
> I think the above answers my question.  As you appear averse to using a
> good hardware RAID card as intended, I'll send you my shipping address
> and take this problem off your hands.  Then all you have to vacillate
> about is what mdraid level to use with your now mobo connected drives.
>

Maybe I've been wandering a bit much with vague thoughts and ideas, and 
thinking too much about flexibility and expansions.  Realistically, when 
I need more disk space I can just add more disks to the array - and when 
that's not enough, it's probably time for a new server anyway.

You've given me a lot of good practical advice, which I plan to take. 
Many thanks,

David

