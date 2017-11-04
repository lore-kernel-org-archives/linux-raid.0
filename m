From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid 6 recovery
Date: Sat, 4 Nov 2017 12:46:58 +0000
Message-ID: <59FDB6C2.1040800@youngman.org.uk>
References: <cf135ab9-1111-65cd-1074-5259a7eb133d@safeandsoundit.co.uk>
 <59F8A47E.2000405@youngman.org.uk>
 <1f997b50-f271-a238-2d7e-1684a0c64e66@safeandsoundit.co.uk>
 <59F8BCE9.1070607@youngman.org.uk> <59FBAE95.6010206@youngman.org.uk>
 <778940c7-cd7c-bda7-4db6-1e1b605a9557@safeandsoundit.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <778940c7-cd7c-bda7-4db6-1e1b605a9557@safeandsoundit.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Crisp <jcrisp@safeandsoundit.co.uk>, linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 03/11/17 10:44, John Crisp wrote:
> On 03/11/17 00:47, Wols Lists wrote:
>> On 31/10/17 18:11, Wols Lists wrote:
>>> It's possible - I wouldn't know - that the existence of the MBR stops
>>> mdadm looking for a superblock that applies to the whole drive, which
>>> could explain why those drives have disappeared.
>>
>> Just been digging in the code - function check_raid - I think if you
>> pass a drive to mdadm it checks the drive for a superblock, and doesn't
>> look for whether a partition table exists. So I think that's that
>> explanation blown out the water ... :-(
>>
> 
> :-) Thanks for looking.
> 
> As I mentioned, I think I created the array via Xubuntu.
> 
> As far as I remember I didn't partition any of the drives - just added
> them to the array and I think it effectively created one partition
> across the whole array (which would make sense why you can't see
> partitions on individual drives)
> 
> I am pretty sure that is trashed, but I like to try and understand these
> things !
> 
More for Neil, this, but I've had a nasty thought. Did you reboot at all
(as in clean shutdown, not crash and restart) at any point during this?
I get the impression you might not have.

Because that *could* explain the missing superblocks! I think raid
updates the superblock every time it moves the rebuild window, so it
should get rewritten to disk regularly. BUT. Is it possible that it was
sitting in the disk cache when the system crashed?

I find it hard to believe that's the case, but it could explain at least
some of it (doesn't explain why those drives had mbr's, though).

Cheers,
Wol

