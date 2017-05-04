From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RAID creation resync behaviors
Date: Thu, 4 May 2017 16:50:38 +0100
Message-ID: <590B4DCE.3070801@youngman.org.uk>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
 <fe3c30e4-b0dd-639e-7db7-344aa93ce198@hesbynett.no>
 <20170504015454.d4obiuume6e3yrdv@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170504015454.d4obiuume6e3yrdv@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org, jes.sorensen@gmail.com, neilb@suse.de
List-Id: linux-raid.ids

On 04/05/17 02:54, Shaohua Li wrote:
> On Wed, May 03, 2017 at 11:06:01PM +0200, David Brown wrote:
>> On 03/05/17 22:27, Shaohua Li wrote:
>>> Hi,
>>>
>>> Currently we have different resync behaviors in array creation.
>>>
>>> - raid1: copy data from disk 0 to disk 1 (overwrite)
>>> - raid10: read both disks, compare and write if there is difference (compare-write)
>>> - raid4/5: read first n-1 disks, calculate parity and then write parity to the last disk (overwrite)
>>> - raid6: read all disks, calculate parity and compare, and write if there is difference (compare-write)
>>>
>>> Write whole disk is very unfriendly for SSD, because it reduces lifetime. And
>>> if user already does a trim before creation, the unncessary write could make
>>> SSD slower in the future. Could we prefer compare-write to overwrite if mdadm
>>> detects the disks are SSD? Surely sometimes compare-write is slower than
>>> overwrite, so maybe add new option in mdadm. An option to let mdadm trim SSD
>>> before creation sounds reasonable too.
>>>
>>
>> When doing the first sync, md tracks how far its sync has got, keeping a
>> record in the metadata in case it has to be restarted (such as due to a
>> reboot while syncing).  Why not simply /not/ sync stripes until you first
>> write to them?  It may be that a counter of synced stripes is not enough,
>> and you need a bitmap (like the write intent bitmap), but it would reduce
>> the creation sync time to 0 and avoid any writes at all.
> 
> For raid 4/5/6, this means we always must do a full stripe write for any normal
> write if it hits a range not synced. This would harm the performance of the
> norma write. For raid1/10, this sounds more appealing. But since each bit in
> the bitmap will stand for a range. If only part of the range is written by
> normal IO, we have two choices. sync the range immediately and clear the bit,
> this sync will impact normal IO. Don't do the sync immediately, but since the
> bit is set (which means the range isn't synced), read IO can only access the
> first disk, which is harmful too.
> 
We're creating the array, right? So the user is sitting in front of
mdadm looking at its output, right?

So we just print a message saying "the disks aren't sync'd. If you don't
want a performance hit in normal use, fire up a sync now and take the
hit up front".

The question isn't "how do we avoid a performance hit?", it's "we're
going to take a hit, do we take it up-front on creation or defer it
until we're using the array?".

Cheers,
Wol

