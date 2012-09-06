From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: RFC: use TRIM data from filesystems to speed up array rebuild?
Date: Thu, 06 Sep 2012 18:17:35 +0100
Message-ID: <5048DAAF.8060300@mpstor.com>
References: <50464322.3010509@genband.com> <5046525E.10500@gmail.com> <20120905062405.3741239a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120905062405.3741239a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Chris Friesen <chris.friesen@genband.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/09/12 21:24, NeilBrown wrote:
> On Tue, 04 Sep 2012 15:11:26 -0400 Ric Wheeler<ricwheeler@gmail.com>  wrote:
>
>> On 09/04/2012 02:06 PM, Chris Friesen wrote:
>>> Hi,
>>>
>>> I'm not really a filesystem guy so this may be a really dumb question.
>>>
>>> We currently have an issue where we have a ~1TB RAID1 array that is mostly
>>> given over to LVM.  If we swap one of the disks it will rebuild everything,
>>> even though we may only be using a small fraction of the space.
>>>
>>> This got me thinking.  Has anyone given thought to using the TRIM information
>>> from filesystems to allow the RAID code to maintain a bitmask of used disk
>>> blocks and only sync the ones that are actually used?
>>>
>>> Presumably this bitmask would itself need to be stored on the disk.
>>>
>>> Thanks,
>>> Chris
>>>
>> Device mapper has a "thin" target now that tracks blocks that are allocated or
>> free (and works with discard).
>>
>> That might be a basis for doing an focused RAID rebuild,
> I wonder how....
> Maybe the block-later interface could grow something equivalent to
> "SEEK_HOLE" and friends so that the upper level can find "holes" and
> "allocated space" in the underlying device.
> I wonder if it is time to discard the 'block device' abstraction and just use
> files every .... but I seriously doubt it.
>
> NeilBrown
Hi,

I've got a brief question about this feature that seems extremely promising:

You mentioned on your blog:

"A 'write' to a non-in-sync region should cause that region to be 
resynced. Writing zeros would in some sense be ideal, but to do that we 
would have to block the write, which would be unfortunate."

So, if we had a write on a "non-in-sync" region (let's imagine the 
bitmap allows for 1M granularity), we would compute the parity of every 
stripe that this write "touches" and update it? Is the solution zeroing 
the area used to save time reading and writing the data on the stripe to 
compute the parity, as well as any other stripes that are referenced by 
this "non-in-sync" region, even if the write wouldn't affect them, 
allowing us to then flip that entire region to "clean"?

Would this open the door to some "thin provisioned" MD RAID, where one 
could grow the underlying devices (in the case of a RAID built ontop of 
say LVM devices), and marking the new "space" as "non-in-sync" without 
disrupting (slowing) operations on the array with a sync?

In any case, seems like a great feature.

Regards,
Ben.
