From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Array created by mdadm 3.2 & 3.3 have different array size
Date: Thu, 27 Mar 2014 00:52:06 -0500
Message-ID: <5333BC86.8090205@hardwarefreak.com>
References: <tencent_66C345191B9B49B92956F243@qq.com> <alpine.DEB.2.02.1403261937480.747@uplift.swm.pp.se> <loom.20140326T205013-837@post.gmane.org> <53334347.4050108@hardwarefreak.com> <loom.20140327T033039-0@post.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20140327T033039-0@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tide <lovetide@qq.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/26/2014 9:44 PM, Tide wrote:
> Stan Hoeppner <stan <at> hardwarefreak.com> writes:
>>
>> On 3/26/2014 3:00 PM, Tide wrote:
>> ...
>>> =================
>>> Array 2 (RAID 6):
>>> =================
>>> # mdadm --examine /dev/sdb1
>> ...
>>>      Raid Level : raid6
>>>    Raid Devices : 5
>> ...
>>>   Bad Block Log : 512 entries available at offset 72 sectors
>>
>> The RAID6 array has sectors on each drive reserved for bad block
>> reassignment.  The RAID5 array does not.
>>
>> This is the answer to your mystery.


> "The RAID6/RAID5 array", do you mean my RAID array (just this instance), or
> you mean "all RAID6/RAID5 arrays created by mdadm" ?

My reply above is unambiguous.  I quoted your array data and gave an
answer that applies to your provided array data.

WRT your other questions, I do not have time to research the answer to
those, and wouldn't spend it on that if I did.  I have never used CentOS
nor Fedora, and don't plan to ever use either.  For those answers,
either wait for someone to answer, or research it yourself.

Cheers,

Stan
