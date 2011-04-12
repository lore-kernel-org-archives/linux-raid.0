From: David Brown <david@westcontrol.com>
Subject: Re: Growing layered raids
Date: Tue, 12 Apr 2011 10:35:53 +0200
Message-ID: <io12tu$c9m$1@dough.gmane.org>
References: <invsor$qrt$1@dough.gmane.org>	<20110412082719.17fa4ffb@notabene.brown>	<io0239$mu6$1@dough.gmane.org> <20110412095446.18a94107@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110412095446.18a94107@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/04/2011 01:54, NeilBrown wrote:
> On Tue, 12 Apr 2011 01:15:52 +0200 David Brown<david.brown@hesbynett.no>
> wrote:
>
<snip>
>> Thank you for that.  It's a bit late tonight, but I will try your
>> instructions tomorrow.
>>
>> It's just occurred to me what the difference is between this case and my
>> initial testing with the raid5 array build directly on the loopback
>> devices.  In my current case, the raid5's devices haven't changed - they
>> are still the mdpairX arrays, but those devices have grown.  In the
>> previous case, I swapped out the old smaller devices for newer bigger
>> devices - which is not really the same situation.
>
> Correct.
>

Thanks - it is /so/ much better to understand /why/ things are 
different, and not just that they /are/ different.

>>
>> Am I right in thinking that it is best to use metadata format 1.2, which
>> is at the beginning of the array?  Are there any disadvantages to this?
>
> Yes.  1.2 is the default so presumably someone thinks it is best...
>
> The main shortcoming with 1.2 is that with RAID1 array you cannot just use
> one of the devices as a non-raid device, which is sometimes useful.  Of course
> that can also be seen as a strength of 1.2 (and 1.1).
>

Ah, hence the warning when creating the raid1 array that it might be 
incompatible with my bootloader.  With raid1 and metadata format 0.90, 
the bootloader can pretend the partition is just a normal partition, and 
read from it directly.  But for other metadata formats, the bootloader 
must know how to interpret them to be able to boot correctly (such as 
with version 1.99 of grub, according to <http://grub.enbug.org/LVMandRAID>).

mvh.,

David



>>
>> And how do I check the metadata format of the existing arrays - is it
>> the "version" from a "mdadm --detail" report?  (In which case, all my
>> arrays are version 1.2).
>
> The version has (for silly historical reasons) 3 parts:
>    major . minor . patchlevel
>
> The metadata version is the corresponding major . minor
>
> NeilBrown
>
>
>>
>> mvh.,
>>
>> David
>>
>>
>>>
>>>>
>>>>
>>>> If I do the same setup, but build the raid5 array directly from the 128
>>>> MB loopback devices, then add the 160 MB devices, then remove the 128 MB
>>>> devices (after appropriate resyncs, of course), then I can grow the raid
>>>> 5 array as expected.
>>>>
>>>>
>>>> Am I doing something wrong here, or is this a limitation of hierarchical
>>>> raid setups?
>>>>
>>>>
>>

