From: David Brown <david.brown@hesbynett.no>
Subject: Re: RAID 1 partition with hot spare shows [UUU] ?
Date: Wed, 18 Apr 2012 11:09:53 +0200
Message-ID: <4F8E84E1.1040407@hesbynett.no>
References: <4F8DF1EE.70402@reetspetit.net> <20120418091233.23d77dfc@notabene.brown> <4F8E7E73.5070909@reetspetit.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F8E7E73.5070909@reetspetit.net>
Sender: linux-raid-owner@vger.kernel.org
To: John Crisp <john@reetspetit.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/04/2012 10:42, John Crisp wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 18/04/12 01:12, NeilBrown wrote:
>> On Wed, 18 Apr 2012 00:42:54 +0200 John Crisp wrote:
>>>
>>> I don't understand how md1 shows [UUU] ??
>>
>> You have a RAID1 with 3 devices.  What it difficult to comprehend
>> about that.
>
> Probably a misunderstanding of the terminology - in Hicksville where I
> live mirrored usually just means a pair ;-)
>
>> Each block is written to all three devices.
>
> I didn't realise that a RAID 1 could have more than two devices. Most
> documentation around always illustrates a RAID 1 with a pair of drives
> and hence the confusion.
>

A lot of hardware raid systems (and software systems, such as Window's 
"dynamic disks") are limited to 2 devices in a raid1 set.  The world of 
Linux md raid is very different - here flexibility is the key.  Amongst 
other things, you can have raid1 sets with any number of devices - 
you've seen it with 3 devices, but you can also make them with just one 
device.  And you can also use all sorts of different disks in the set, 
not just identical ones.

You might well ask what use a 1-disk raid1 "mirror" is.  The answer is 
not much use on its own - but very useful in that you can add and remove 
disks whenever you want.  Suppose, for example, you have a single disk 
in the machine, and you want to exchange it for a new, bigger disk.  If 
the disk is a 1-disk raid1 mirror, you can do it quickly and safely 
without going off-line (except if you need to power-off to do the actual 
disk swapping).  Attach your new, bigger disk.  Add it to the raid1 
array.  Wait for the sync to complete (using the disk normally all this 
time).  Fail and remove the original disk.  Your new disk is now a 
1-disk "mirror" with the same data.  Grow the raid to fill the new disk, 
then grow your filesystems (or physical volumes for LVM) to use the new 
space.

There are lots of cool things you can do when you are not limited to 
hardware raid mindsets!
