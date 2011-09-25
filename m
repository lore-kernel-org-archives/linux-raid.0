From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: potentially lost largeish raid5 array..
Date: Sun, 25 Sep 2011 18:58:58 -0500
Message-ID: <4E7FC042.7040109@hardwarefreak.com>
References: <201109221950.36910.tfjellstrom@shaw.ca> <201109231022.59437.tfjellstrom@shaw.ca> <4E7D152C.9080704@hardwarefreak.com> <201109231811.08061.tfjellstrom@shaw.ca> <4E7DCA66.4000705@hardwarefreak.com> <j5ksf5$oam$1@dough.gmane.org> <4E7E079C.4020802@hardwarefreak.com> <j5n921$9oj$1@dough.gmane.org> <4E7F3D24.5050300@hardwarefreak.com> <j5ngnt$ms1$1@dough.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j5ngnt$ms1$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/25/2011 10:18 AM, David Brown wrote:
> On 25/09/11 16:39, Stan Hoeppner wrote:
>> On 9/25/2011 8:03 AM, David Brown wrote:
>>> On 24/09/2011 18:38, Stan Hoeppner wrote:
>>>> On 9/24/2011 10:16 AM, David Brown wrote:
>>>>> On 24/09/2011 14:17, Stan Hoeppner wrote:
>>>>>> On 9/23/2011 7:11 PM, Thomas Fjellstrom wrote:
>>>>>>> On September 23, 2011, Stan Hoeppner wrote:
>>>>>>
>>>>>>>> When properly configured XFS will achieve near spindle throughput.
>>>>>>>> Recent versions of mkfs.xfs read the mdraid configuration and
>>>>>>>> configure
>>>>>>>> the filesystem automatically for sw, swidth, number of allocation
>>>>>>>> groups, etc. Thus you should get max performance out of the gate.
>>>>>>>
>>>>>>> What happens when you add a drive and reshape? Is it enough just to
>>>>>>> tweak the
>>>>>>> mount options?
>>>>>>
>>>>>> When you change the number of effective spindles with a reshape, and
>>>>>> thus the stripe width and stripe size, you definitely should add the
>>>>>> appropriate XFS mount options and values to reflect this. Performance
>>>>>> will be less than optimal if you don't.
>>>>>>
>>>>>> If you use a linear concat under XFS you never have to worry about
>>>>>> the
>>>>>> above situation. It has many other advantages over a striped array
>>>>>> and
>>>>>> better performance for many workloads, especially multi user general
>>>>>> file serving and maildir storage--workloads with lots of concurrent
>>>>>> IO.
>>>>>> If you 'need' maximum single stream performance for large files, a
>>>>>> striped array is obviously better. Most applications however don't
>>>>>> need
>>>>>> large single stream performance.
>>>>>>
>>>>>
>>>>> If you use a linear concatenation of drives for XFS, is it not correct
>>>>> that you want one allocation group per drive (or per raid set, if you
>>>>> are concatenating a bunch of raid sets)?
>>>>
>>>> Yes. Normally with a linear concat you would make X number of RAID1
>>>> mirrors via mdraid or hardware RAID, then concat them with mdadm
>>>> --linear or LVM. Then mkfs.xfs -d ag=X ...
>>>>
>>>> Currently XFS has a 1TB limit for allocation groups. If you use 2TB
>>>> drives you'll get 2 AGs per effective spindle instead of one. With some
>>>> 'borderline' workloads this may hinder performance. It depends on how
>>>> many top level directories you have in the filesystem and your
>>>> concurrency to them.
>>>>
>>>>> If you then add another drive
>>>>> or raid set, can you grow XFS with another allocation group?
>>>>
>>>> XFS creates more allocation groups automatically as part of the grow
>>>> operation. If you have a linear concat setup you'll obviously wan to
>>>> control this manually to maintain the same number of AGs per effective
>>>> spindle.
>>>>
>>>> Always remember that the key to linear concat performance with XFS is
>>>> directory level parallelism. If you have lots of top level directories
>>>> in your filesystem and high concurrent access (home dirs, maildir, etc)
>>>> it will typically work better than a striped array. If you have few
>>>> directories and low concurrency, are streaming large files, etc, stick
>>>> with a striped array.
>>>>
>>>
>>> I understand the point about linear concat and allocation groups being a
>>> good solution when you have multiple parallel accesses to different
>>> files, rather than streamed access to a few large files.
>>
>> Not just different files, but files in different top level directories.
>>
>>> But you seem to be suggesting here that accesses to different files
>>> within the same top-level directory will be put in the same allocation
>>> group - is that correct?
>>
>> When you create a top level directory on an XFS filesystem it is
>> physically created in one of the on disk allocation groups. When you
>> create another directory it is physically created in the next allocation
>> group, and so on, until it wraps back to the first AG. This is why XFS
>> can derive parallelism from a linear concat and no other filesystem can.
>> Performance is rarely perfectly symmetrical, as the workload dictates
>> the file, and thus physical IO, access patterns.
>>
>> But, with maildir and similar workloads, the odds are very high that
>> you'll achieve good directory level parallelism because each mailbox is
>> in a different directory. I've previously discussed the many other
>> reasons why XFS on a linear concat beats the stuffing out of anything on
>> a striped array for a maildir workload so I won't repeat all that here.
>>
>>> That strikes me as very limiting - it is far
>>> from uncommon for most accesses to be under one or two top-level
>>> directories.
>>
>> By design or ignorance? What application workload? What are the IOPS and
>> bandwidth needs of this workload you describe? Again, read the paragraph
>> below, which you apparently skipped the first time.
>>
>
> Perhaps I am not expressing myself very clearly. I don't mean to sound
> patronising by spelling it out like this - I just want to be sure I'm
> getting an answer to the question in my mind (assuming, of course, you
> have time and inclination to help me - you've certainly been very
> helpful and informative so far!).
>
> Suppose you have an xfs filesystem with 10 allocation groups, mounted on
> /mnt. You make a directory /mnt/a. That gets created in allocation group
> 1. You make a second directory /mnt/b. That gets created in allocation
> group 2. Any files you put in /mnt/a go in allocation group 1, and any
> files in /mnt/b go in allocation group 2.

You're describing the infrastructure first.  You *always* start with the 
needs of the workload and build the storage stack to best meet those 
needs.  You're going backwards, but I'll try to play your game.

> Am I right so far?

Yes.  There are some corner cases but this is how a fresh XFS behaves. 
I should have stated before that my comments are based on using the 
inode64 mount option which is required to reach above 16TB, and which 
yields superior performance.  The default mode, inode32, behaves a bit 
differently WRT allocation.  It would take too much text to explain the 
differences here.  You're better off digging into the XFS documentation 
at xfs.org.

> Then you create directories /mnt/a/a1 and /mnt/a/a2. Do these also go in
> allocation group 1, or do they go in groups 3 and 4? Similarly, do files
> inside them go in group 1 or in groups 3 and 4?

Remember this is a filesystem.  Think of a file cabinet.  The cabinet is 
the XFS filesytsem, the drawers are the allocation groups, directories 
are manilla folders, and files are papers in the folders.  That's 
exactly how the allocation works.  Now, a single file will span more 
than 1 AG (drawer) if the file is larger than the free space available 
within the AG (drawer) when the file is created, or appended.

> To take an example that is quite relevant to me, consider a mail server
> handling two domains. You have (for example) /var/mail/domain1 and
> /var/mail/domain2, with each user having a directory within either
> domain1 or domain2. What I would like to know, is if the xfs filesystem
> is mounted on /var/mail, then are the user directories spread across the
> allocation groups, or are all of domain1 users in one group and all of
> domain2 users in another group? If it is the former, then xfs on a
> linear concat would scale beautifully - if it is the later, then it
> would be pretty terrible scaling.

See above for file placement.

With only two top level directories you're not going to achieve good 
parallelism on an XFS linear concat.  Modern delivery agents, dovecot 
for example, allow you to store each user mail directory independently, 
anywhere you choose, so this isn't a problem.  Simply create a top level 
directory for every mailbox, something like:

/var/mail/domain1.%user/
/var/mail/domain2.%user/

>>>> Also note that a linear concat will only give increased performance
>>>> with
>>>> XFS, again for appropriate worklods. Using a linear concat with EXT3/4
>>>> will give you the performance of a single spindle regardless of the
>>>> total number of disks used. So one should stick with striped arrays for
>>>> EXT3/4.
>>
>
> I understand this, which is why I didn't comment earlier. I am aware
> that only XFS can utilise the parts of a linear concat to improve
> performance - my questions were about the circumstances in which XFS can
> utilise the multiple allocation groups.

The optimal scenario is rather simple.  Create multiple top level 
directories and write/read files within all of them concurrently.  This 
works best with highly concurrent workloads where high random IOPS is 
needed.  This can be with small or large files.

The large file case is transactional database specific, and careful 
planning and layout of the disks and filesystem are needed.  In this 
case we span a single large database file over multiple small allocation 
groups.  Transactional DB systems typically write only a few hundred 
bytes per record.  Consider a large retailer point of sale application. 
  With a striped array you would suffer the read-modify-write penalty 
when updating records.  With a linear concat you simply directly update 
a single 4KB block.

XFS is extremely flexible and powerful.  It can be tailored to yield 
maximum performance for just about any workload with sufficient concurrency.

-- 
Stan
