From: David Brown <david.brown@hesbynett.no>
Subject: Re: potentially lost largeish raid5 array..
Date: Mon, 26 Sep 2011 22:29:25 +0200
Message-ID: <j5qnb5$c9j$1@dough.gmane.org>
References: <201109221950.36910.tfjellstrom@shaw.ca> <201109231022.59437.tfjellstrom@shaw.ca> <4E7D152C.9080704@hardwarefreak.com> <201109231811.08061.tfjellstrom@shaw.ca> <4E7DCA66.4000705@hardwarefreak.com> <j5ksf5$oam$1@dough.gmane.org> <4E7E079C.4020802@hardwarefreak.com> <j5n921$9oj$1@dough.gmane.org> <4E7F3D24.5050300@hardwarefreak.com> <j5ngnt$ms1$1@dough.gmane.org> <4E7FC042.7040109@hardwarefreak.com> <j5plld$fa1$1@dough.gmane.org> <4E80D815.9080005@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E80D815.9080005@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/09/11 21:52, Stan Hoeppner wrote:
> On 9/26/2011 5:51 AM, David Brown wrote:
>> On 26/09/2011 01:58, Stan Hoeppner wrote:
>>> On 9/25/2011 10:18 AM, David Brown wrote:
>>>> On 25/09/11 16:39, Stan Hoeppner wrote:
>>>>> On 9/25/2011 8:03 AM, David Brown wrote:
>>
>> (Sorry for getting so off-topic here - if it is bothering anyone, please
>> say and I will stop. Also Stan, you have been extremely helpful, but if
>> you feel you've given enough free support to an ignorant user, I fully
>> understand it. But every answer leads me to new questions, and I hope
>> that others in this mailing list will also find some of the information
>> useful.)
>
> I don't mind at all. I love 'talking shop' WRT storage architecture and
> XFS. Others might though as we're very far OT at this point. The proper
> place for this discussion in the XFS mailing list. There are folks there
> far more knowledgeable than me and could thus answer your questions more
> thoroughly, and correct me if I make an error.
>

I will stop after this post (at least, I will /try/ not to continue...). 
  I've got all the information I was looking for now, and if I need more 
details I'll take your advice and look at the XFS mailing list.  Before 
that, though, I should really try it out a little first - I don't have 
any need of a big XFS system at the moment, but it is on my list of 
"experiments" to try some quiet evening.

> <snip for brevity>
>
>>
>> To my mind, it is an unfortunate limitation that it is only top-level
>> directories that are spread across allocation groups, rather than all
>> directories. It means the directory structure needs to be changed to
>> suit the filesystem.
>
> That's because you don't yet fully understand how all this XFS goodness
> works. Recall my comments about architecting the storage stack to
> optimize the performance of a specific workload? Using an XFS+linear
> concat setup is a tradeoff, just like anything else. To get maximum
> performance you may need to trade some directory layout complexity for
> that performance. If you don't want that complexity, simply go with a
> plain striped array and use any directory layout you wish.
>

I understand this - tradeoffs are inevitable.  It's a shame that it is a 
necessary tradeoff here.  I can well see that in some cases (such as a 
big dovecot server) the benefits of XFS + linear concat outweigh the 
(real or perceived) benefits of a domain/user directory structure.  But 
that doesn't stop me wanting both!

> Striped arrays don't rely on directory or AG placement for performance
> as does a linear concat array. However, because of the nature of a
> striped array, you'll simply get less performance with the specific
> workloads I've mentioned. This is because you will often generate many
> physical IOs to the spindles per filesystem operation. With the linear
> concat each filesystem IO generates one physical IO to one spindle. Thus
> with a highly concurrent workload you get more real file IOPS than with
> a striped array before the disks hit their head seek limit. There are
> other factors as well, such as latency. Block latency will usually be
> lower with a linear concat than with a striped array.
>
> I think what you're failing to fully understand is the serious level of
> flexibility that XFS provides, and the resulting complexity of
> understanding required by the sysop. Other Linux filesystem offer zero
> flexibility WRT optimizing for the underlying hardware layout. Because
> of XFS' architecture one can tailor its performance characteristics to
> many different physical storage architectures, including standard
> striped arrays, linear concats, a combination of the two, etc, and
> specific workloads. Again, an XFS+linear concat is a specific
> configuration of XFS and the underlying storage, tailored to a specific
> type of workload.
>
>> In some cases, such as a dovecot mail server,
>> that's not a big issue. But in other cases it could be - it is a
>> somewhat artificial restraint in the way you organise your directories.
>
> No, it's not a limitation, but a unique capability. See above.
>

Well, let me rephrase - it is a unique capability, but it is limited to 
situations where you can spread your load among many top-level directories.

>> Of course, scaling across top-level directories is much better than no
>> scaling at all - and I'm sure the XFS developers have good reason for
>> organising the allocation groups in this way.
>
>> You have certainly answered my question now - many thanks. Now I am
>> clear how I need to organise directories in order to take advantage of
>> allocation groups.
>
> Again, this directory layout strategy only applies when using a linear
> concat. It's not necessary with XFS atop a striped array. And it's only
> a good fit for high concurrency high IOPS workloads.
>

Yes, I understand that.

>> Even though I don't have any filesystems planned that
>> will be big enough to justify linear concats,
>
> A linear concat can be as small as 2 disks, even 2 partitions, 4 with
> redundancy (2 mirror pairs). Maybe you meant workload here instead of
> filesystem?
>

Yes, I meant workload :-)


>> spreading data across
>> allocation groups will spread the load across kernel threads and
>> therefore across processor cores, so it is important to understand it.
>
> While this is true, and great engineering, it's only relevant on systems
> doing large concurrent/continuous IO, as in multiple GB/s, given the
> power of today's CPUs.
>
> The XFS allocation strategy is brilliant, and simply beats the stuffing
> out of all the other current Linux filesystems. It's time for me to stop
> answering your questions, and time for you to read:
>
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide//tmp/en-US/html/index.html
>
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html
>
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_Labs/tmp/en-US/html/index.html
>

These will keep me busy for a little while.

> If you have further questions after digesting these valuable resources,
> please post them on the xfs mailing list:
>
> http://oss.sgi.com/mailman/listinfo/xfs
>
> Myself and others would be happy to respond.
>
>>> The large file case is transactional database specific, and careful
>>> planning and layout of the disks and filesystem are needed. In this case
>>> we span a single large database file over multiple small allocation
>>> groups. Transactional DB systems typically write only a few hundred
>>> bytes per record. Consider a large retailer point of sale application.
>>> With a striped array you would suffer the read-modify-write penalty when
>>> updating records. With a linear concat you simply directly update a
>>> single 4KB block.
>
>> When you are doing that, you would then use a large number of allocation
>> groups - is that correct?
>
> Not necessarily. It's a balancing act. And it's a rather complicated
> setup. To thoroughly answer this question will take far more list space
> and time than I have available. And given your questions the maildir
> example prompted, you'll have far more if I try to explain this setup.
>
> Please read the docs I mentioned above. They won't directly answer this
> question, but will allow you to answer it yourself after you digest the
> information.
>

Fair enough - thanks for those links.  And if I have more questions, 
I'll try the XFS list - if nothing else, it will give you a break!

>> References I have seen on the internet seem to be in two minds about
>> whether you should have many or a few allocation groups. On the one
>> hand, multiple groups let you do more things in parallel - on the other
>
> More parallelism only to an extent. Disks are very slow. Once you have
> enough AGs for your workload to saturate your drive head actuators,
> additional AGs simply create a drag on performance due to excess head
> seeking amongst all your AGs. Again, it's a balancing act.
>
>> hand, each group means more memory and overhead needed to keep track of
>> inode tables, etc.
>
> This is irrelevant. The impact of these things is infinitely small
> compared to the physical disk overhead caused by too many AGs.
>

OK.

One of the problems with reading stuff on the net is that it is often 
out of date, and there is no one checking the correctness of what is 
published.

>> Certainly I see the point of having an allocation
>> group per part of the linear concat (or a multiple of the number of
>> parts), and I can see the point of having at least as many groups as you
>> have processor cores, but is there any point in having more groups than
>> that?
>
> You should be realizing about now why most people call tuning XFS a
> "Black art". ;) Read the docs about allocation groups.
>
>> I have read on the net about a size limitation of 4GB per group,
>
> You're read in the wrong place, read old docs. The current AG size limit
> is 1TB, has been for quite some time. It will be bumped up some time in
> the future as disk sizes increase. The next limit will likely be 4TB.
>
>> which would mean using more groups on a big system, but I get the
>> impression that this was a 32-bit limitation and that on a 64-bit system
>
> The AG size limit has nothing to do with the system instruction width.
> It is an 'arbitrary' fixed size.
>

OK.

>> the limit is 1 TB per group. Assuming a workload with lots of parallel
>> IO rather than large streams, are there any guidelines as to ideal
>> numbers of groups? Or is it better just to say that if you want the last
>> 10% out of a big system, you need to test it and benchmark it yourself
>> with a realistic test workload?
>
> There are no general guidelines here, but for the mkfs.xfs defaults.
> Coincidentally, recent versions of mkfs.xfs will read the mdadm config
> and build the filesystem correctly, automatically, on top of striped md
> raid arrays.
>

Yes, I have read about that - very convenient.

> Other than that, there are no general guidelines, and especially none
> for a linear concat. The reason is that all storage hardware acts a
> little bit differently and each host/storage combo may require different
> XFS optimizations for peak performance. Pre-production testing is
> *always* a good idea, and not just for XFS. :)
>
> Unless or until one finds that the mkfs.xfs defaults aren't yielding the
> required performance, it's best not to peek under the hood, as you're
> going to get dirty once you dive in to tune the engine. ;)
>

I usually find that when I get a new server to play with, I start poking 
around, trying different fancy combinations of filesystems and disk 
arrangements, trying benchmarks, etc.  Then I realise time is running 
out before it all has to be in place, and I set up something reasonable 
with default settings.  Unlike a car engine, it's easy to put the system 
back to factory condition with a reformat!

>>> XFS is extremely flexible and powerful. It can be tailored to yield
>>> maximum performance for just about any workload with sufficient
>>> concurrency.
>
>> I have also read that JFS uses allocation groups - have you any idea how
>> these compare to XFS, and whether it scales in the same way?
>
> I've never used JFS. AIUI it staggers along like a zombie, with one dev
> barely maintaining it today. It seems there hasn't been real active
> Linux JFS code work for about 7 years, since 2004, only a handful of
> commits, all bug fixes IIRC. The tools package appears to have received
> slightly more attention.
>

That's the impression I got too.

> XFS sees regular commits to both experimental and stable trees, both bug
> fixes and new features, with at least a dozen or so devs banging on it
> at a given time. I believe there is at least one Red Hat employee
> working on XFS full time, or nearly so. Christoph is a kernel dev who
> works on XFS, and could give you a more accurate head count. Christoph?
>
> BTW, this is my last post on this subject. It must move to the XFS list,
> or die.
>

Fair enough.

Many thanks for your help and your patience.

