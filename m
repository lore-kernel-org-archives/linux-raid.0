From: Jeff Wiegley <jeffw@csun.edu>
Subject: Re: Repaired the sectors of a drive, how do I get the md to assemble
 and start degraded?
Date: Thu, 24 Apr 2014 21:59:36 -0700
Message-ID: <5359EBB8.1010504@csun.edu>
References: <53592837.8020406@csun.edu> <alpine.DEB.2.02.1404241923510.19744@uplift.swm.pp.se> <53597309.8070506@csun.edu> <alpine.DEB.2.02.1404250526310.19744@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1404250526310.19744@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "linux-raid@vger.kernel.org >> linux-raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you. this one I figured out. The drives are throwing
sector faults that can be automatically reallocated. If you
take such a drive and run is through the SeaTools long fix
it won't "repair" your drive and you will lose the data in
the bad sectors. but you can make the drive usable again
because the fix program will mark the sectors bad and map
those sectors to extra sectors on the drive used for
reallocation.  I have two drives that have been dead a long
time and so are massively out of sync.

I had a third drive die while backing up the array so I could
repair it. this took the entire array offline. But I could
take the recently failed drive which is 100% synced up (just
failed) because I wasn't doing writes during the backup.

I ran that drive through SeaTools to hide/remap the bad sectors.

Then I wanted to know how to force the assembly of the drive
to come up and ignore that this drive had been marked as
out of date.

the answer was to --assemble --force /dev/sd[abcefghiklmno]1
(notice I left out d and j which were the two old very out of
sync drives.)

It therefore thought I had 12 of the 14 drives available.
(it commented that it had no volumes from two of the expected
slots) but it came up anyways.

I then did xfs_check followed by xfs_repair to make sure my
fs wasn't too corrupt and then proceeded to pull all my data
off it successfully. There was some stuff tossed into lost+found
by the repair tool and I'm sure there is some missing or
corrupt files by I'm also sure I recovered 99.99999% of everything
I had on the storage.

Thank you.

- Jeff

Now I just need fix the offset/size/arrangement problem of my
other home machine which is turning out to be very hard :(

On 4/24/2014 8:31 PM, Mikael Abrahamsson wrote:
> On Thu, 24 Apr 2014, Jeff Wiegley wrote:
>
>> I don't want to simply re-add the failed drives as I believe
>> they will start re-syncing won't they? I don't want their data
>> lost and overwritten. I want the drive to be treated like it
>> never failed in the first place.
>>
>> I might have some filesystem corruption but not as much as I
>> will if the entire drive is resynced.
>>
>> I also cannot repair the two other dead drives. So I need this
>> drive treated as is so that array can come up degraded. Then I
>> can get what data I can off it before replacing all drives
>> and probably starting fresh.
>
> What do you mean by "repair"?
>
> Well, anyway, if you --assemble --force with all parity drives gone, no
> resync will be done.
>
> As long as you do not use --create, no "bad" information will be synced
> even if you use the previously failed drives. If their even count is way
> off, then --assemble --force might give you a lot more corruption.
>
> But my original point was that if you have a RAID6 with bitmap and two
> drives are kicked out, but they are not dead, it's better to re-add them
> back in, let things re-sync. You then run a "repair" on the volume so you
> try to make sure that any UNC read errors are repaired by md.
>
> Right now, you have no parity and any other UNC sectors will have to be
> written to in order for you to get your data.
>

