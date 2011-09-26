From: David Brown <david@westcontrol.com>
Subject: Re: potentially lost largeish raid5 array..
Date: Mon, 26 Sep 2011 12:51:01 +0200
Message-ID: <j5plld$fa1$1@dough.gmane.org>
References: <201109221950.36910.tfjellstrom@shaw.ca> <201109231022.59437.tfjellstrom@shaw.ca> <4E7D152C.9080704@hardwarefreak.com> <201109231811.08061.tfjellstrom@shaw.ca> <4E7DCA66.4000705@hardwarefreak.com> <j5ksf5$oam$1@dough.gmane.org> <4E7E079C.4020802@hardwarefreak.com> <j5n921$9oj$1@dough.gmane.org> <4E7F3D24.5050300@hardwarefreak.com> <j5ngnt$ms1$1@dough.gmane.org> <4E7FC042.7040109@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7FC042.7040109@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/09/2011 01:58, Stan Hoeppner wrote:
> On 9/25/2011 10:18 AM, David Brown wrote:
>> On 25/09/11 16:39, Stan Hoeppner wrote:
>>> On 9/25/2011 8:03 AM, David Brown wrote:

(Sorry for getting so off-topic here - if it is bothering anyone, please 
say and I will stop.  Also Stan, you have been extremely helpful, but if 
you feel you've given enough free support to an ignorant user, I fully 
understand it.  But every answer leads me to new questions, and I hope 
that others in this mailing list will also find some of the information 
useful.)

>> Suppose you have an xfs filesystem with 10 allocation groups, mounted on
>> /mnt. You make a directory /mnt/a. That gets created in allocation group
>> 1. You make a second directory /mnt/b. That gets created in allocation
>> group 2. Any files you put in /mnt/a go in allocation group 1, and any
>> files in /mnt/b go in allocation group 2.
>
> You're describing the infrastructure first. You *always* start with the
> needs of the workload and build the storage stack to best meet those
> needs. You're going backwards, but I'll try to play your game.
>

I agree on your principle here - figure out what you need before trying 
to build it.  But here I am trying to understand what happens if I build 
/this/ way.

>> Am I right so far?
>
> Yes. There are some corner cases but this is how a fresh XFS behaves. I
> should have stated before that my comments are based on using the
> inode64 mount option which is required to reach above 16TB, and which
> yields superior performance. The default mode, inode32, behaves a bit
> differently WRT allocation. It would take too much text to explain the
> differences here. You're better off digging into the XFS documentation
> at xfs.org.
>

I've heard there are some differences between XFS running under 32-bit 
and 64-bit kernels.  It's probably fair to say that any modern system 
big enough to be looking at scaling across a raid linear concat would be 
running on a 64-bit system, and using appropriate make.xfs and mount 
options for 64-bit systems.  But it's helpful of you to point this out.

>> Then you create directories /mnt/a/a1 and /mnt/a/a2. Do these also go in
>> allocation group 1, or do they go in groups 3 and 4? Similarly, do files
>> inside them go in group 1 or in groups 3 and 4?
>
> Remember this is a filesystem. Think of a file cabinet. The cabinet is
> the XFS filesytsem, the drawers are the allocation groups, directories
> are manilla folders, and files are papers in the folders. That's exactly
> how the allocation works. Now, a single file will span more than 1 AG
> (drawer) if the file is larger than the free space available within the
> AG (drawer) when the file is created, or appended.
>
>> To take an example that is quite relevant to me, consider a mail server
>> handling two domains. You have (for example) /var/mail/domain1 and
>> /var/mail/domain2, with each user having a directory within either
>> domain1 or domain2. What I would like to know, is if the xfs filesystem
>> is mounted on /var/mail, then are the user directories spread across the
>> allocation groups, or are all of domain1 users in one group and all of
>> domain2 users in another group? If it is the former, then xfs on a
>> linear concat would scale beautifully - if it is the later, then it
>> would be pretty terrible scaling.
>
> See above for file placement.
>
> With only two top level directories you're not going to achieve good
> parallelism on an XFS linear concat. Modern delivery agents, dovecot for
> example, allow you to store each user mail directory independently,
> anywhere you choose, so this isn't a problem. Simply create a top level
> directory for every mailbox, something like:
>
> /var/mail/domain1.%user/
> /var/mail/domain2.%user/
>

Yes, that is indeed possible with dovecot.

To my mind, it is an unfortunate limitation that it is only top-level 
directories that are spread across allocation groups, rather than all 
directories.  It means the directory structure needs to be changed to 
suit the filesystem.  In some cases, such as a dovecot mail server, 
that's not a big issue.  But in other cases it could be - it is a 
somewhat artificial restraint in the way you organise your directories. 
  Of course, scaling across top-level directories is much better than no 
scaling at all - and I'm sure the XFS developers have good reason for 
organising the allocation groups in this way.

You have certainly answered my question now - many thanks.  Now I am 
clear how I need to organise directories in order to take advantage of 
allocation groups.  Even though I don't have any filesystems planned 
that will be big enough to justify linear concats, spreading data across 
allocation groups will spread the load across kernel threads and 
therefore across processor cores, so it is important to understand it.

>>>>> Also note that a linear concat will only give increased performance
>>>>> with
>>>>> XFS, again for appropriate worklods. Using a linear concat with EXT3/4
>>>>> will give you the performance of a single spindle regardless of the
>>>>> total number of disks used. So one should stick with striped arrays
>>>>> for
>>>>> EXT3/4.
>>>
>>
>> I understand this, which is why I didn't comment earlier. I am aware
>> that only XFS can utilise the parts of a linear concat to improve
>> performance - my questions were about the circumstances in which XFS can
>> utilise the multiple allocation groups.
>
> The optimal scenario is rather simple. Create multiple top level
> directories and write/read files within all of them concurrently. This
> works best with highly concurrent workloads where high random IOPS is
> needed. This can be with small or large files.
>
> The large file case is transactional database specific, and careful
> planning and layout of the disks and filesystem are needed. In this case
> we span a single large database file over multiple small allocation
> groups. Transactional DB systems typically write only a few hundred
> bytes per record. Consider a large retailer point of sale application.
> With a striped array you would suffer the read-modify-write penalty when
> updating records. With a linear concat you simply directly update a
> single 4KB block.
>

When you are doing that, you would then use a large number of allocation 
groups - is that correct?

References I have seen on the internet seem to be in two minds about 
whether you should have many or a few allocation groups.  On the one 
hand, multiple groups let you do more things in parallel - on the other 
hand, each group means more memory and overhead needed to keep track of 
inode tables, etc.  Certainly I see the point of having an allocation 
group per part of the linear concat (or a multiple of the number of 
parts), and I can see the point of having at least as many groups as you 
have processor cores, but is there any point in having more groups than 
that?  I have read on the net about a size limitation of 4GB per group, 
which would mean using more groups on a big system, but I get the 
impression that this was a 32-bit limitation and that on a 64-bit system 
the limit is 1 TB per group.  Assuming a workload with lots of parallel 
IO rather than large streams, are there any guidelines as to ideal 
numbers of groups?  Or is it better just to say that if you want the 
last 10% out of a big system, you need to test it and benchmark it 
yourself with a realistic test workload?

> XFS is extremely flexible and powerful. It can be tailored to yield
> maximum performance for just about any workload with sufficient
> concurrency.
>

I have also read that JFS uses allocation groups - have you any idea how 
these compare to XFS, and whether it scales in the same way?


