From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Software, Raid 5, Different Size Drives.
Date: Mon, 17 Aug 2009 10:17:29 +0200
Message-ID: <87hbw6vopy.fsf@frosties.localdomain>
References: <914153.25662.qm@web51308.mail.re2.yahoo.com>
	<47af6defcf34329212cd18ef65edad38.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47af6defcf34329212cd18ef65edad38.squirrel@neil.brown.name>
	(NeilBrown's message of "Mon, 17 Aug 2009 08:45:11 +1000 (EST)")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"NeilBrown" <neilb@suse.de> writes:

> On Sun, August 16, 2009 4:54 am, Jon Hardcastle wrote:
>> Hi quick Q.. I have a 6 drive array made up of 4 500GB's and 2 750GB's.
>>
>> I know the array will only take on a size based on the smallest drive. To
>> that end as I phase drives out based on usage etc I replace them with the
>> best value drive I can lay my hands on (upto 1TB~ as i have read a raid 5
>> array of drives over that size approx start to cause problems with read
>> failures on re-builds - but that is for another thread)
>>
>> So my array is currently ~2.5GB with 2x250GB currently not in use and I am
>> about to phase out a 500GB and replace with a 1TB. Now i have read that
>> you are better of creating a auto detect raid partition on the drive and
>> adding that rather than adding the entire drive (so sda1 not sda). This is
>> where my question comes in. I have read that 2 1TB(or whatever size) can
>> be different block sizes and hence adding a partition that is the entire
>> drive can cause problems as these sizes will differ.
>
> This was a topic of a recent thread on this list.  Apparently there is an
> industry standard which sets out exactly how many sectors a 1TB or 2TB
> drive should be, and it seems that all drive manufactures adhere to this.

Also note that raid on sda or sda1 both have exactly the same problem.
You can not use a disk smaller than the minimum disk used in the raid.
Really makes no difference if it is partitioned or not.

If you fear size problems then look up the industry standard size and
check your disk follows that. I've never seen a disk smaller than that
size, only bigger.

>> Can anyone tell me what truth there is in this? Should I actually create a
>> partition  that is always going to be a nice multiple size smaller so i
>> can smooth over the bumps?
>
> Personally I never create a single partition for an md array.  I either
> use the whole drive, or create a number of partitions for different
> arrays.  I also avoid in-kernel autodetect.
>
> The question of what "best" may well come down to the start up scripts
> that your distro uses and any hidden assumptions that might be in them...
>
> I guess that isn't very helpful though... I can say that either approach
> can be made to work fine.  The one issue that you particularly need to be
> careful off is the boot sector.  Partitions always leave room for a boot
> sector.  If you don't use partitions and you want a separate boot sector,
> then v1.2 metadata is the thing to choose....

That is actually a verry important thing. Putting your raid on sda
without leaving space for the bootloader is rather dangerous. Over
time it is easy for the bootloader to get installed on the wrong disk
because sda and sdb switched places or you forgot which drive is the
boot drive and so on.

I now actually put the bootloader on all my drives and all are setup
to have space there. That way the system boots even if I rearange
disks or the boot drive fails and so on.

MfG
        Goswin
