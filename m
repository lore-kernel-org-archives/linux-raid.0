From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: Odd --examine output
Date: Mon, 15 Apr 2013 18:06:36 +0200
Message-ID: <516C258C.7070406@schinagl.nl>
References: <CD917B51.41713%michael.vanhorn@wright.edu> <10112252.14.1366051374769.JavaMail.root@zimbra> <20844.24431.814932.275104@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20844.24431.814932.275104@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Mike Vanhorn <michael.vanhorn@wright.edu>, Phil Turmel <philip@turmel.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15-04-13 22:13, John Stoffel wrote:
>>>>>> "Roy" == Roy Sigurd Karlsbakk <roy@karlsbakk.net> writes:
>>>> NOT a guess. Back up what you can, while you can, and start over. Use
>>>> "fdisk -u" so you can ensure partitions start on multiples of eight
>>>> (8)
>>>> sectors. (Modern fdisk uses 1MB alignment by default. Highly
>>>> recommended.)
>>>>
>>>>
>>> So, if I start the partition at sector 64 (rather than 63), that's
>>> better,
>>> right (since 64 is a multiple of 8)? Or is there more math to do and
>>> I'm still not getting it?
> Roy> I still don't understand why people use partitions for RAID when
> Roy> the whole drive is used anyway. Partitions were invented to
> Roy> partition things up and are of no use if you want to spend the
> Roy> whole drive's space for RAID use (or otherwise).
>
> Because if I take a 2tb disk a I put a partition on there which is a
> bit smaller than the full disk, if I then add a new 2tb (or any other
> size) disk which says it's 2tb, but it's really a bit smaller, then
> I'm not screwed.  I've had it happen.
Or if you use them for your OS, and have several raids for /, /usr, /var 
etc.
Or you buy 2 or 3 batches of disks, all varying sizes (1TB != 1TB) and 
having partitions allows you to at least align them all to the same size.
And its even possible to buy a replacement disk, that's actually larger 
but cheaper as prices came down.
A strange use case could be that 1 disk split into 2 partitions could be 
a hot-spare for 2 arrays.

When using 1MiB offsets for partitions, I don't think there's any 
performance loss at all (due to alignment) nor will it slow down 
anything because md is on a partition rather then a disk. Wasting 1 MiB 
per disk is really not significant.

And when using raid1/10 it allows you in theory to wipe the superblock 
and make the partition point tot he real data;   though there's very 
little use for that imo.

I personally, don't see why you want to use the entire disk, is there 
any advantage?
>
> John
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

