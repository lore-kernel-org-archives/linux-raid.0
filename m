From: Aaron Scheiner <blue@aquarat.za.net>
Subject: Re: Grub-install, superblock corrupted/erased and other animals
Date: Tue, 2 Aug 2011 23:13:00 +0200
Message-ID: <CADz4AWErquXh=UszTKrMg7QkT4XbXVdDTa82Nj9Or1huHXQ3bQ@mail.gmail.com>
References: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com>
 <20110802163907.29fc40b4@notabene.brown> <4E37AEE8.1080108@hardwarefreak.com>
 <CADz4AWFJHah=OkZ0JaC8ZZD+E13D6tOvhz7cRR0oc19OfsOQew@mail.gmail.com> <4E3828B5.2050202@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E3828B5.2050202@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oh right, I see, my mistake.

The file is just one of a set of files that I duplicated across two
arrays. The entire folder (with almost all the duplicated files in it)
was approximately 2TBs in size. The file I'm using for comparison is
11GBs in size.
The array was originally 8TBs in size, but I upgraded it recently (May
2011) to 16TBs (using 2TB drives). As part of the upgrade process I
copied all the data from the older array to the new array in one large
cp command.I expect this would have had the effect of defragmenting
the files... which is great seeing as I'm relying on low fragmentation
for this process :P .

So there's a good chance then that searching on all the drives for
512-byte samples from various points in the "example" file will allow
me to work out the order of the drives.

Scalpel is 70% through the first drive. Scans of both the first and
second drives should be complete by tomorrow morning (my time) yay :)
=2E

Just of interest; machines on a Gigabit LAN used to be able to read
data off the array at around 60MB/sec... which I was very happy with.
Since the upgrade to 2TB drives the array has been reading at over
100MB/sec, saturating the ethernet interface. Do you think the new
drives are the reason for the speed increase ? (the new drives are
cheap Seagate 5900 rpm drives "Green Power", the old drives were
Samsung 7200 rpm units) or do you think the switch from JFS to XFS
(and aligning partitions with cylinder boundaries) may have been part
of it ?

On Tue, Aug 2, 2011 at 6:41 PM, Stan Hoeppner <stan@hardwarefreak.com> =
wrote:
> On 8/2/2011 11:24 AM, Aaron Scheiner wrote:
>> wow... I had no idea XFS was that complex, great for performance,
>> horrible for file recovery :P . Thanks for the explanation.
>>
>> Based on this the scalpel+lots of samples approach might not work...
>> I'll investigate XFS a little more closely, I just assumed it would
>> write big files in one continuous block.
>
> Maybe I didn't completely understand what you're trying to do...
>
> As long as there is enough free space within an AG, any newly created
> file will be written contiguously (from the FS POV). =A0If you have 1=
5
> extent AGs and write 30 of these files, 2 will be written into each A=
G.
> =A0There will be lots of free space between the last file in AG2 and =
AG3,
> on down the line. =A0When I said the data would not be contiguous, I =
was
> referring to the overall composition of the filesystem, not individua=
l
> files. =A0Depending on their size, individual files will be broken up
> into, what, 128KB chunks, and spread across the 8 disk stripe, by mdr=
aid.
>
>> This makes a lot of sense; I reconstructed/re-created the array usin=
g
>> a random drive order, scalpel'ed the md device for the start of the
>> video file and found it. I then dd'ed that out to a file on the hard
>> drive and then loaded that into a hex editor. The file ended abruptl=
y
>> after about +/-384KBs. I couldn't find any other data belonging to t=
he
>> file within 50MBs around the the sample scalpel had found.
>
> What is the original size of this video file?
>
>> Thanks again for the info.
>
> Sure thing. =A0Hope you get it going.
>
> --
> Stan
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
