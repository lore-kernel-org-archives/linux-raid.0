From: "Thomas C. Bishop" <bishop@latech.edu>
Subject: Re: raid5 messed up
Date: Wed, 6 Sep 2017 18:00:26 -0500
Message-ID: <44cd847f-8be8-ee8b-0dd2-136ba2676675@email.latech.edu>
References: <fdbb6bf6-357c-781e-beee-d8589cbb299d@email.latech.edu>
 <20170902002452.GA26288@metamorpher.de>
Reply-To: bishop@latech.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170902002452.GA26288@metamorpher.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, "Thomas C. Bishop" <bishop@latech.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

note the smartctl report is

"failure  prediction"
on two HDs not failed.

I used the scterc option (see Phil's recommend so the smart is cut-off. I 'll check his full ist of options.

smartctl -iA -l scterc /dev/sdXn


Tom
On 09/01/2017 07:24 PM, Andreas Klauer wrote:
> On Fri, Sep 01, 2017 at 03:15:41PM -0500, Thomas C. Bishop wrote:
>> I messed up my raid5 array .
> That's an understatement...
>
>> I know a two of HDs are "failure
>> prediction" and one is out..
> RAID 5 with three failed drives, chances of survival are very low.
> You should never let things get this far. Timeouts? Doesn't matter!
> You either have no disk monitoring at all or never acted on it.
>
> ddrescue the broken drives to new ones first.
> Then always use overlays for recovery experiments.
>
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
>
> Experiments for example could be:
>
>   *) --assemble --force
>   *) --assemble --update=force-no-bbl
>   *) --create --metadata=1.0 --chunk=128 with one 'missing' drive
>
> Again, use overlays for everything.
>
>>     Bad Block Log : 512 entries available at offset -8 sectors - bad
>> blocks present.
> You have bbl entries on more than one drive, use --examine-badblocks
> to see if they are identical. You have to clear those or md will
> either not work at all or always give read errors even after replacing
> the drives. Bad block list issues were previously discussed on the list,
> you might find it when searching for "no-bbl".
>
>> === START OF READ SMART DATA SECTION ===
>> SMART Health Status: OK
> Never trust this unconditionally. It's a false friend.
> Always look at the detailed output with reallocated etc. sectors.
> Run selftests regularly, detect disk errors early, replace drives immediately.
>
> Good luck
> Andreas Klauer

-- 
     ***********************************
          Thomas C. Bishop
Hazel Stewart Garner Associate Professor
         Chemistry & Physics
          Tel: 318-257-5209
          Fax: 318-257-3823
         www.latech.edu/~bishop
     ***********************************

