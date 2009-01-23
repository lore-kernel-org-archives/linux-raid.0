From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: system upgrade reordered drives, confused software raid-1
Date: Fri, 23 Jan 2009 07:57:46 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901230754400.10635@p34.internal.lan>
References: <6d344ffd0901192019t2e9f1e59q862fed68a68ea4a@mail.gmail.com>  <alpine.DEB.1.10.0901200613230.14067@p34.internal.lan> <6d344ffd0901221058j3c82e8e5ye4c31593c4a2fba4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d344ffd0901221058j3c82e8e5ye4c31593c4a2fba4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Troy Cauble <troycauble@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 22 Jan 2009, Troy Cauble wrote:

> On Tue, Jan 20, 2009 at 6:14 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>
>>
>> On Mon, 19 Jan 2009, Troy Cauble wrote:
>>
>>> I recently upgraded an Ubuntu box and noticed that my drives got reordered
>>> (possibly by a SATA driver change) and my RAID-1 is degraded.
>>>
>> 1. mdadm /dev/md0 --fail /dev/sdb1
>> 2. mdadm /dev/md0 -r /dev/sdb1
>> 3. sfdisk -d /dev/sda | sfdisk /dev/sdb
>> 4. mdadm /dev/md0 -a /dev/sdb1
>> 5. mdadm --examine --scan >> /etc/mdadm/mdadm.conf
>>
>> Justin.
>
> Thanks very much!
>
> If I understand the documentation, this is essentially treating
> sdb1 as a new drive and sda1 will be copied too it.
Yep.

>
> I'd also like to understand if/when --assemble might be appropriate for
> these scenarios.  The man page says Assemble means
>
> "Assemble  the  components  of a previously created array into an
>              active array."
I would not recommend it because you would probably need to --force it [1]
and then run fsck on the filesystem [2] because you're syncing an old (dirty)
disk with a new one, why risk it if you do not have to (in this scenario?)

>
> My two drives were part of a previous array that are no longer
> associated for some reason.  I *assume* that sdb1 still has a
> good file system, just slightly out of date files, since I used the
> degraded array.
The system is still running right?  So that is the disk that you would use
to syncronize from, the running disk.

>
> Is it that assemble wouldn't know which version is correct?
See above.

> Is it that assemble isn't used for recovery scenarios?
Not recommended for this scenario.

> Is it that sdb1 might be worse than I assume?
There were some changes made to the disk that md does not like, fix using
the steps above.  Then let us know if all issues are resolved.

Justin.

