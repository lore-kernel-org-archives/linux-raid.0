From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: "Missing" RAID devices
Date: Tue, 21 May 2013 17:06:59 -0500
Message-ID: <519BF003.5080005@hardwarefreak.com>
References: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com> <519B9F8C.3080104@redhat.com> <CACJz6Qvpf9yTzHTE6f5pErny1DLh7BvV3S+Q-Ekbb_-CEtKW1w@mail.gmail.com> <519BDC8C.1040202@hardwarefreak.com> <CACJz6QvU_o=mbSwaUEdE3WyD2ytipBYPch7pjBuov=NoxofhJg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACJz6QvU_o=mbSwaUEdE3WyD2ytipBYPch7pjBuov=NoxofhJg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Jim Santos <iluvgadgets@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 5/21/2013 4:02 PM, Drew wrote:
> On Tue, May 21, 2013 at 1:43 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 5/21/2013 12:03 PM, Drew wrote:
>>> Hi Jim,
>>>
>>> The other question I'd ask is why do you have 10 raid1 arrays on those
>>> two disks?
>>
>> No joke.  That setup is ridiculous.  RAID exists to guard against a
>> drive failure, not as a substitute for volume management.
>>
>>> Given you have an initramfs, at most you should have separate
>>> partitions (raid'd) for /boot & root. Everything else should be broken
>>> down using LVM. Way more flexible to move things around in future as
>>> required.
>>
>> LVM isn't even required.  Using partitions (atop MD) or a single large
>> filesystem (XFS) with quotas works just as well.
> 
> Agreed. For simple setups, a single boot & root is just fine.
> 
> I'd assumed the OP's reasons for using multiple partitions was valid,
> so keeping those partitions over top a single raid array meant LVM was
> the best choice.

We don't have enough information yet to make such a determination.
Multiple LVM devices may most closely mimic his current setup, but that
doesn't mean it's the best choice.  It doesn't mean it's not either.  We
simply haven't been informed why he was using 10 md/RAID1 devices.  My
gut instinct says it's simply a lack of education, not a special
requirement.

The principal reason for such a setup is to prevent runaway processes
from filling the storage.  Thus /var which normally contains the logs
and mail spool is often put on a separate partition.  This problem can
also be addressed using filesystem quotas.

There is more than one way to skin a cat, as they say.  If he's using
these 10 partitions simply for organization purposes, then there's no
need for 10 LVM devices nor FS quotas on a single FS, but simply a good
directory hierarchy.

-- 
Stan

