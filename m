From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: potentially lost largeish raid5 array..
Date: Sat, 24 Sep 2011 11:38:52 -0500
Message-ID: <4E7E079C.4020802@hardwarefreak.com>
References: <201109221950.36910.tfjellstrom@shaw.ca> <201109231022.59437.tfjellstrom@shaw.ca> <4E7D152C.9080704@hardwarefreak.com> <201109231811.08061.tfjellstrom@shaw.ca> <4E7DCA66.4000705@hardwarefreak.com> <j5ksf5$oam$1@dough.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j5ksf5$oam$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/24/2011 10:16 AM, David Brown wrote:
> On 24/09/2011 14:17, Stan Hoeppner wrote:
>> On 9/23/2011 7:11 PM, Thomas Fjellstrom wrote:
>>> On September 23, 2011, Stan Hoeppner wrote:
>>
>>>> When properly configured XFS will achieve near spindle throughput.
>>>> Recent versions of mkfs.xfs read the mdraid configuration and configure
>>>> the filesystem automatically for sw, swidth, number of allocation
>>>> groups, etc. Thus you should get max performance out of the gate.
>>>
>>> What happens when you add a drive and reshape? Is it enough just to
>>> tweak the
>>> mount options?
>>
>> When you change the number of effective spindles with a reshape, and
>> thus the stripe width and stripe size, you definitely should add the
>> appropriate XFS mount options and values to reflect this. Performance
>> will be less than optimal if you don't.
>>
>> If you use a linear concat under XFS you never have to worry about the
>> above situation. It has many other advantages over a striped array and
>> better performance for many workloads, especially multi user general
>> file serving and maildir storage--workloads with lots of concurrent IO.
>> If you 'need' maximum single stream performance for large files, a
>> striped array is obviously better. Most applications however don't need
>> large single stream performance.
>>
>
> If you use a linear concatenation of drives for XFS, is it not correct
> that you want one allocation group per drive (or per raid set, if you
> are concatenating a bunch of raid sets)?

Yes.  Normally with a linear concat you would make X number of RAID1 
mirrors via mdraid or hardware RAID, then concat them with mdadm 
--linear or LVM.  Then mkfs.xfs -d ag=X ...

Currently XFS has a 1TB limit for allocation groups.  If you use 2TB 
drives you'll get 2 AGs per effective spindle instead of one.  With some 
'borderline' workloads this may hinder performance.  It depends on how 
many top level directories you have in the filesystem and your 
concurrency to them.

> If you then add another drive
> or raid set, can you grow XFS with another allocation group?

XFS creates more allocation groups automatically as part of the grow 
operation.  If you have a linear concat setup you'll obviously wan to 
control this manually to maintain the same number of AGs per effective 
spindle.

Always remember that the key to linear concat performance with XFS is 
directory level parallelism.  If you have lots of top level directories 
in your filesystem and high concurrent access (home dirs, maildir, etc) 
it will typically work better than a striped array.  If you have few 
directories and low concurrency, are streaming large files, etc, stick 
with a striped array.

Also note that a linear concat will only give increased performance with 
XFS, again for appropriate worklods.  Using a linear concat with EXT3/4 
will give you the performance of a single spindle regardless of the 
total number of disks used.  So one should stick with striped arrays for 
EXT3/4.

-- 
Stan
