From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v2 00/12] Partial Parity Log for MD RAID 5
Date: Tue, 03 Jan 2017 10:42:05 -0500
Message-ID: <wrfjzij8ywtu.fsf@redhat.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
        <87fum04m0m.fsf@notabene.neil.brown.name>
        <84c59771-48b7-da47-3497-c82c6c6939c9@intel.com>
        <20161207170906.sthdxswufwk5fqhn@kernel.org>
        <wrfjy3zjq2b3.fsf@redhat.com>
        <20161214194726.4to3rnqyrqlqlx7t@kernel.org>
        <c97a46de-f88a-f8f2-4520-e3c8a57d1b3b@intel.com>
        <20161216232421.x6sb4goclzyasu6k@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161216232421.x6sb4goclzyasu6k@kernel.org> (Shaohua Li's
        message of "Fri, 16 Dec 2016 15:24:21 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shaohua Li <shli@kernel.org> writes:
> On Thu, Dec 15, 2016 at 12:44:57PM +0100, Artur Paszkiewicz wrote:
>> On 12/14/2016 08:47 PM, Shaohua Li wrote:
>> > For the implementation, I don't understand how the ppl works much,
>> > there aren't
>> > many details there. Two things I noted:
>> > 
>> > - The code skips the log for full stripe write. This isn't
>> > good. It would means
>> >   after a unclean shutdown/recovery, one disk has arbitrary data,
>> > not the old
>> >   data and new data. This breaks an assumption in filesystem, after a failed
>> >   write to a sector, the sector has either old or new data. Thinking about a
>> >   write to superblock. The data could be old or new superblock,
>> > but it's still a
>> >   superblock, not something random.
>> > 
>> > - From the patch 6 & 10, looks PPL only help recover unwritten disks. If one
>> >   disk of a stripe is dirty (eg it's written before unclean
>> > shutdown), and it's
>> >   lost in recovery, what will happen? Seems the data of lost disk
>> > will be read as
>> >   0? It will break the assumption above too. If I understand the
>> > code clearly
>> >   (maybe not, need clarification), this is a design flaw.
>> 
>> PPL is only used to update the parity for a stripe, data chunks are not
>> modified at all during PPL recovery. The assumption was that it would
>> protect only from silent data corruption, to eliminate the cases when
>> data that was not touched by a write request could change. So if a dirty
>> disk is lost, no recovery is performed for this stripe (parity is not
>> updated). For full stripe write we only recalculate the parity after a
>> dirty shutdown if all disks are available (like resync). So you are
>> right that it is still possible to have arbitrary data in the written
>> part of a stripe if that disk is lost. In such case the behavior is the
>> same as in plain raid5.
>
> Ok, this matches my understanding. This isn't a completed solution but does
> help a lot. If users want to use this, there is no reason to not support it.
> After you fix the alignment issue and describe the solution in details, I'll
> look at it again.

Artur,

Did you make any progress getting the alignment issue resolved?

I'd really like to get an mdadm release out the door this week, so
getting this resolved would be awesome. Hint hint ;)

Cheers,
Jes
