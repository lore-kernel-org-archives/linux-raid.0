From: "Majed B." <majedb@gmail.com>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Wed, 16 Sep 2009 12:31:28 +0300
Message-ID: <70ed7c3e0909160231l4e424ff3y4d4615ebb87c0e82@mail.gmail.com>
References: <h8nbt5$n8p$1@ger.gmane.org> <70ed7c3e0909150340q4ae91cb1j7eaae473c6d94c9a@mail.gmail.com>
	<h8nrkn$n8p$5@ger.gmane.org> <70ed7c3e0909150403s4db60837gfd742d5f6960adf0@mail.gmail.com>
	<70ed7c3e0909151002y5f4690b1j26d33dc297af7795@mail.gmail.com>
	<1253037953.7774.131.camel@kiste> <70ed7c3e0909151114q7296314du77de369f5e4ea695@mail.gmail.com>
	<1253040282.7774.149.camel@kiste>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1253040282.7774.149.camel@kiste>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthias,

I have a question which would probably sound stupid: If I have a bad
blocks output file from dd_rescue, can I reconstruct a bad sector's
data by reading the same sector from all disks (using dd if=/dev/sdx
of=./bbfix_#number bs=512 count=1 skip=bb_number-1), then run an
normal XOR operation, write zeros to the bad block to force sector
remap, then dd the XOR output to the said sector?

On Tue, Sep 15, 2009 at 9:44 PM, Matthias Urlichs <matthias@urlichs.de> wrote:
> On Tue, 2009-09-15 at 21:14 +0300, Majed B. wrote:
>> Hmm, so I guess I'm luckier since I run RAID5? (or not because I have
>> 2 bad disks? :p)
>>
> Well, depends on whether you have two errors in the same sector. If not,
> you're going to be lucky.
>
>> When do you expect to have a working application done, by the way?
>>
> Hopefully later this week. It'll probably be a patch to mdadm's
> development branch of some sort.
>
> Neil: In order to do that, I need to read badblock map files for some
> (or all) disks, in GNU dd_rescue's format preferably. Do you have a
> preference WRT how to tell mdadm about these?
>
> I tend towards "mdadm --recover 0:foo,2:bar DISK_DEVICE...". This would
> tell mdadm that the badblock map for disk 0 is in file 'foo', the map
> for disk 2 is in 'bar', and the other disks are supposed to be cleanly
> read/writeable.
>
> mdadm would then read RAID info from these devices, make sure it's
> consistent (or "mostly consistent" if using --force), read the bad block
> map, recover the data that's indicated to be bad and write it to the
> partitions in question, and zero out the blocks that are unrecoverable
> (and restore P+Q vectors for them).
>
>
>



-- 
       Majed B.
