From: Drew <drew.kay@gmail.com>
Subject: Re: "Missing" RAID devices
Date: Tue, 21 May 2013 14:02:22 -0700
Message-ID: <CACJz6QvU_o=mbSwaUEdE3WyD2ytipBYPch7pjBuov=NoxofhJg@mail.gmail.com>
References: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com>
 <519B9F8C.3080104@redhat.com> <CACJz6Qvpf9yTzHTE6f5pErny1DLh7BvV3S+Q-Ekbb_-CEtKW1w@mail.gmail.com>
 <519BDC8C.1040202@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <519BDC8C.1040202@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Jim Santos <iluvgadgets@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 21, 2013 at 1:43 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 5/21/2013 12:03 PM, Drew wrote:
>> Hi Jim,
>>
>> The other question I'd ask is why do you have 10 raid1 arrays on those
>> two disks?
>
> No joke.  That setup is ridiculous.  RAID exists to guard against a
> drive failure, not as a substitute for volume management.
>
>> Given you have an initramfs, at most you should have separate
>> partitions (raid'd) for /boot & root. Everything else should be broken
>> down using LVM. Way more flexible to move things around in future as
>> required.
>
> LVM isn't even required.  Using partitions (atop MD) or a single large
> filesystem (XFS) with quotas works just as well.

Agreed. For simple setups, a single boot & root is just fine.

I'd assumed the OP's reasons for using multiple partitions was valid,
so keeping those partitions over top a single raid array meant LVM was
the best choice.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
