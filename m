From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Basic RAID5/6 reshape question
Date: Fri, 12 Dec 2008 15:27:23 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812121525400.17857@p34.internal.lan>
References: <4940E377.7070907@wasp.net.au> <7d86ddb90812111706t14e7fbdar6bf31a22d510a6b6@mail.gmail.com> <4942B8DD.8090809@wasp.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4942B8DD.8090809@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Ryan Wagoner <rswagoner@gmail.com>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Fri, 12 Dec 2008, Brad Campbell wrote:

> Ryan Wagoner wrote:
>> It takes 3 hours to resync my 3 x 1 TB drive RAID 5 array at a rate of
>> 85MB/s. It shouldn't take 20 hours to write 3 x 1 TB drives. How fast
>> is it progressing? You might consider a PCI-X or PCI Express SATA or
>> SAS controller card. I have my drives connected to an Supermicro LSI
>> 1068 PCI Express SAS card, which performs great.
>> 
>
> I'm using 2 x Marvell 7042 based PCI-E x4 controllers and a SIL 3xxx (I don't 
> recall but its PCI-E x1 and 2 ports). Bandwidth is not an issue.
>
> A resync appears to be a completely different kettle of fish to a reshape. 
> With re-shape it appears to write status data to the raid superblocks 
> periodically. This appears to thrash the heads from the current position to 
> the end of the disk and back. At the start of the reshape I was running about 
> 15-20MB/s to each drive. As the reshape progressed to the end of the disks I 
> was looking at closer to 40MB/s. So obviously the final figure was less than 
> the initial 20 hours, but a hell of a lot slower than a straight resync.
>
> This blind stab at reshape behaviour is absolutely pure conjecture based on a 
> gross guess at what was happening, however it does seem to bear out scrutiny.
>
>> The other option would be to create 2 RAID 5 arrays of 5 drives each.
>> Create the first array and use LVM with the filesystem of your choice.
>> Add the second array later and expand the LVM volume.
>
> Mmm thanks, but no.. to use a car analogy, "I'd like something I can fix with 
> a screwdriver and a hammer". LVM is overcomplicating things way past what I 
> require. In addition, I really like RAID-6. Over the last 4 years with my 15 
> drive RAID-6 I have had two double drive failures. Both times one drive died 
> in a not so nice fashion, and one developed a grown defect during the 
> rebuild. Raid-5 just does not cut the mustard with me anymore.
            ^^^^^^^^^^^^^

Agree with you there, even when you have the data backed up losing and 
having to rebuild everything is such a pain-- RAID-6 has served me quite 
well and I have only started using it recently, it did save me from one 
double-drive failure so far, I have not looked back since.

Justin.
