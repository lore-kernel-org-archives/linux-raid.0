From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Recommended filesystem for RAID 6
Date: Tue, 11 Aug 2020 20:57:15 +0200
Message-ID: <ea7232af-a411-6b16-d03e-6b21c14cc5be@thelounge.net>
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
 <20200811212305.02fec65a@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200811212305.02fec65a@natsu>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, George Rapp <george.rapp@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 11.08.20 um 18:23 schrieb Roman Mamedov:
> On Tue, 11 Aug 2020 00:42:33 -0400
> George Rapp <george.rapp@gmail.com> wrote:
> 
>> Use case is long-term storage of many small files and a few large ones
>> (family photos and videos, backups of other systems, working copies of
>> photo, audio, and video edits, etc.)? Current usable space is about
>> 10TB but my end state vision is probably upwards of 20TB. I'll
>> probably consign the slowest working disks in the server to an archive
>> filesystem, either RAID 1 or RAID 5, for stuff I care less about and
>> backups; the archive part can be ignored for the purposes of this
>> exercise.
>>
>> My question is: what filesystem type would be best practice for my use
>> case and size requirements on the big array? (I have reviewed
>> https://raid.wiki.kernel.org/index.php/RAID_and_filesystems, but am
>> looking for practitioners' recommendations.)  I've run ext4
>> exclusively on my arrays to date, but have been reading up on xfs; is
>> there another filesystem type I should consider? Finally, are there
>> any pitfalls I should know about in my high-level design?
> 
> Whichever filesystem you choose, you will end up with a huge single point of
> failure, and any trouble with that FS or the underlying array put all your
> data instantly at risk. 

calling an array where you can lose *two* disks as
single-point-of-failure is absurd

no raid can replace backups anyways

> Most likely you do not. And the RAID's main purpose in that case is to just
> have a unified storage pool, for the convenience of not having to manage free
> space across so many drives. But given the above, I would suggest leaving the
> drives with their individual FSes, and just running MergerFS on top: 
> https://www.teknophiles.com/2018/02/19/disk-pooling-in-linux-with-mergerfs/

you just move the complexity to something not used by many people for
what exactly to gain? the rives are still in the same machine

"Secondly -- if all of this... is BACKED UP ANYWAY, why even run RAID?"
is pure nosense! the best backups are the ones you never need and before
i setup up something where a dying drive take smore actions then swap
iot i would commit suicide
