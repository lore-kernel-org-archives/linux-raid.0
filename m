From: "Steven Ellis" <steven@openmedia.co.nz>
Subject: Re: Can't resolve mismatch_count > 0 for a raid 1 array
Date: Thu, 9 Apr 2009 12:07:59 +1200 (NZST)
Message-ID: <43631.60.234.49.2.1239235679.squirrel@webmail.stevencherie.net>
References: <F87E9034-BDD7-4D74-8117-3ED1884D4165@openmedia.co.nz>
    <87d4bmg6j5.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d4bmg6j5.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Thu, April 9, 2009 9:49 am, Goswin von Brederlow wrote:
> Steven Ellis <steven@openmedia.co.nz> writes:
>
>> I've resolved most of my raid issues by re-housing the affected system
>> and replacing the motherboard, but across the 3 boards I've tried I
>> always have an issue with my /dev/md1 array producing mismatch_count
>> of 128 or 256.
>>
>> System is running Centos 5.2 with a Xen Dom0 kernel
>>
>> This md1 volume is a pair of 40GB HDs raid1 on an IDE controller which
>> I them have a bunch of LVM's that are my Xen guests.
>>
>> Is there any chance that these mismatch_count values are due to swap
>> partitions for the Xen guests?
>>
>> Steve
>
> Have you repaired the raid or do you just check and check and check?
>

Yes I've repaired the raid several times. Then when I put the Xen guests
under load and re-run check the errors re-appear.

--------------------------------------------
Steven Ellis - Technical Director
OpenMedia Limited - The Home of myPVR
email   - steven@openmedia.co.nz
website - http://www.openmedia.co.nz
