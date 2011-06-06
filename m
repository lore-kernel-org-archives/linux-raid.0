From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Mon, 06 Jun 2011 23:20:05 +0800
Message-ID: <4DECF025.9040006@fnarfbargle.com>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com> <BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com> <BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Durval Menezes <durval.menezes@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/06/11 23:02, Drew wrote:
>> I understand that, if I do it the "standard" way (ie, power down the
>> system, remove the failing disk, add the replacement disk, then boot
>> up and use "mdadm --add" to add the new disk to the array) I run the
>> risk of running into unreadable sectors on one of the other two disks,
>> and then my RAID5 is kaput.
>>
>> What I would really like to do is to be able to add the new HD to the
>> array WITHOUT removing the failing HD, somehow sync it with the rest,
>> and THEN remove the failing HD: that way, an eventual failed read from
>> one of the two other HDs could possibly be satisfied from the failing
>> HD (unless EXACTLY that same sector is also unreadable on it, which I
>> find unlikely), and so avoid losing the whole array in the above case.
> A reshape from RAID5 ->  RAID6 ->  RAID5 will hammer your disks so if
> either of the other two are ready to die, this will most likely tip
> them over the edge.
>
> A far simpler way would be to take the array offline, dd (or
> dd_rescue) the old drive's contents onto the new disk, pull the old
> disk, and restart the array with the new drive in it's place. With
> luck you won't need a resync *and* you're not hammering the other two
> drives in the process.
<afterthought>
Bear with me, I've had a few scotches and this might not be as coherent as it might be, but I think 
I spot a very, very fatal flaw in your plan.
</afterthought>

I thought this initially also, except it blows up in the scenario where the dud sectors are data and 
not parity.

If you do it the way you suggest and choose dd_rescue in place of dd, dodgy data from the dud 
sectors will be replicated as kosher sectors on the replacement disk (or zero, or random or whatever)

If you execute a "repair" first, it will strike the dud sectors, see they are toast, re-calculate 
them from parity and write them back forcing a reallocation.

You can then replicate the failing disk using "dd", *not* dd_rescue. If dd fails due to a read error 
then you know that part of your data is likely to be toast on the replaced disk, and you can go 
about making provisions for a backup/restore operation using the original disk (which will likely 
succeed as the data read from the array will be re-built from parity where required).

dd_rescue is a blessing and a curse. It's _very_ good at getting you access to data that you have no 
backup of, and you have no other way of getting back. On the other hand, it will happily go and 
replicate whatever trash it happens to get back from the source disk, or skip those sectors and 
leave you with an incomplete copy that will leave no trace of it being incomplete until you find 
chunks missing (like superblocks or your formula for a zero cost petroleum replacement).

If your array works, but has a badly failing drive you are far better to buy some cheap 2TB disks 
and back it up, then restore it onto a re-created array than chance losing chunks of data by using a 
dd_rescue'd clone disk.

Now, if I'm off the wall and missing something blindingly obvious feel free to thump me with a clue 
bat (it would not be the first time).

I've lost 2 arrays recently. 8TB to a dodgy controller (thanks SIL), and 2TB to complete idiocy on 
my part, so I know the sting of lost or corrupted data.

Brad
