From: Philip Molter <philip@corp.texas.net>
Subject: Re: Force parity resync on raid5?
Date: Tue, 10 Aug 2004 07:03:52 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4118B9A8.2040102@corp.texas.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson wrote:

> On Mon, 9 Aug 2004, Philip Molter wrote:
> 
> 
>>How do I force a parity resync on a raid5 array?  Under 2.4, I would do
>>this by hard cycling the box and when it came back up, it would
>>automatically resync the array.  Under 2.6, this appears to have gone away.
> 
> 
> I don't know about 2.6, (still living with 2.4) but can't you simply do:
> 
>   raidhotremove /dev/mdX /dev/hdYZ
> 
> followed by
> 
>   raidhotadd /dev/mdX /dev/hdYZ
> 
> or /dev/sdYZ if SCSI disks...
> 
> However, picking the right disk to remove might be tricky... And if you
> were at all unsure about data on the disks, maybe rebooting and doing a
> hard fsck of the partition(s) in maintenance mode might be a good thing
> too...

Nope, I want something that will specifically resync the parity from the
known good data on the disks.  Thanks to the raid5 resync bug from
earlier 2.6 kernels, I have hundreds of systems with terabytes of data
that have perfectly good data sitting on raid5 arrays with corrupt
parity.  If I remove a drive to force a resync, the data is immediately
corrupted.

Linux RAID *has* to have sort of way to force a parity resync.  If it
doesn't have one, it needs one.  That's a glaring omission to make.

Philip


