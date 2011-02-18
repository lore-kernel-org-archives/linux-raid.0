From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: mdadm / force parity checking of blocks on all reads?
Date: Fri, 18 Feb 2011 12:07:04 +0000
Message-ID: <4D5E60E8.2070509@anonymous.org.uk>
References: <4D5DD3C0.3020804@chaven.com> <20110218142536.04d35fe5@notabene.brown> <4D5E544F.4090707@chaven.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5E544F.4090707@chaven.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Costaras <stevecs@chaven.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/02/2011 11:13, Steve Costaras wrote:
> On 2011-02-17 21:25, NeilBrown wrote:
>> On Thu, 17 Feb 2011 20:04:48 -0600 Steve Costaras<stevecs@chaven.com>
>> wrote:
>>> I'm looking at alternatives to ZFS since it still has some time to go
>>> for large scale deployment as a kernel-level file system (and brtfs has
>>> years to go). I am running into problems with silent data corruption
>>> with large deployments of disks. Currently no hardware raid vendor
>>> supports T10 DIF (which even if supported would only work w/ SAS/FC
>>> drives anyway) nor does read parity checking.
>> Maybe I'm just naive, but find it impossible to believe that "silent data
>> corruption" is ever acceptable. You should fix or replace your hardware.
>>
>> Yes, I know silent data corruption is theoretically possible at a very
>> low
>> probability and that as you add more and more storage, that
>> probability gets
>> higher and higher.
>>
>> But my point is that the probability of unfixable but detectable
>> corruption
>> will ALWAYS be much (much much) higher than the probability of silent
>> data
>> corruption (on a correctly working system).
>>
>> So if you are getting unfixable errors reported on some component,
>> replace
>> that component. And if you aren't then ask your vender to replace the
>> system, because it is broken.
>>
>>
> Would love to, do you have the home phone #'s of all the drive
> manufacturer's CTO's so I can talk to them?
> It's a fact of life across /ALL/ drives. This is 'SILENT' corruption,
> i.e. it's not reported by anything in the I/O chain as all systems
> 'assume' the data is good in the request. This concept has been proved
> flawed.
>
> You can discover this by running (like we do here, sha1 hashes of all
> files and compare them over time). We find on our 40TB arrays (this on
> drives w/ 10^15 BER and 1TB drives (seagate & hitachi) about 1-2
> mis-matches per month.

I thought the BER was for reported uncorrectable errors? Or it might 
include the silent ones but they ought to be thousands or possibly 
millions of times rarer - I don't know what ECC techniques they're using 
but presumably the manufacturers presumably don't quote a BER for silent 
corruption?

I did some sums a while ago and found that with current drives you've an 
evens chance of getting a bit error with every ~43TB you read, with a 1 
in 10^15 BER. I assumed that the drive would report it, allowing md or 
any other RAID setup to reconstruct the data and re-write it.

Can you estimate from your usage of your 40TB arrays what your "silent 
BER" is?

[...]
>  The only large capacity
> drive I've found that seems to have some additional protections is the
> Seagate ST32000444SS sas drive as it does ECC checks of each block at
> read time and tries to correct it.

Again in theory don't all drives do ECC all the time to even reach their 
1 in 10^15 BER? Do those Seagates quote a much better BER? Ooh no but 
they do also quote a miscorrected BER of 1 in 10^21, which is something 
I haven't seen quoted before, and they also note that these rates only 
apply with the drive is doing "full read retries", so presumably 
wouldn't apply to a RAID setup using shortened SCT ERC timeouts.

[...]
> This is the real driving factor for ZFS as it does not require T10 DIF
> (fat sectors) or high BER drives (as manufacturers are not making them,
> a lot of 2TB and 3TB drives are rated even at 10^14!!!! ) ZFS works by
> creating it's own raid checksum and checking it on every transaction
> (read/write) at least in regards to this type of problem. This same
> level of assurance can be accomplished by /any/ type of raid as the data
> is also already there but it needs to be checked on every transaction to
> verify it's integrity and if wrong corrected BEFORE handing it to user
> space.
>
> If this is not something that is planned for mdadm then I'm back to
> solaris or freebsd for the mean time until native zfs is up to snuff.

A separate device-mapper target which did another layer of ECC over hard 
drives has been suggested here and I vaguely remember seeing a patch at 
some point, which would take (perhaps) 64 sectors of data and add an ECC 
sector. Such a thing should work well under RAID. But I don't know what 
(if anything) happened to it.

Cheers,

John.

