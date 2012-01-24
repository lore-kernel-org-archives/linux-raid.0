From: David Brown <david.brown@hesbynett.no>
Subject: Re: nonstandard raid(4-ish) scheme
Date: Tue, 24 Jan 2012 21:51:45 +0100
Message-ID: <jfn5l1$g4n$1@dough.gmane.org>
References: <20120124030015.GQ11921@wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120124030015.GQ11921@wantstofly.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/01/12 04:00, Lennert Buytenhek wrote:
> (I'm not on the list, please CC on replies.)
>
> Hi!
>
> While recently setting up a media server for a HTPC, I was wondering
> whether it'd be possible to set things up so that most disks can be
> kept spun down most of the time.
>
> Since the majority of the I/O on this sort of server is reads, the
> first idea was to store (directories of) media files entirely on
> individual disks, i.e. to not distribute them over all disks by
> striping, as that would require spinning up each disk on reads.  So,
> creating a large RAID(5/6) array out of all of the disks wouldn't be
> option here.
>
> RAID1ing pairs of disks would work, but this is somewhat wasteful,
> as it eats up half of your space.
>
> The ideal way of doing this would be to take N-1 disks out of your N
> disk set, and create separate filesystems on each of the disks, and
> store different sets of files on them, while using the last disk,
> disk N, as a parity disk of the N-1 data disks.
>
> This is equivalent to raid4 with the stripe size equal the size of
> one disk, and where the data disks get individual /dev/mdX entries
> instead of being concatenated into one large /dev/mdX.
>
> Would this be easy to implement?
>
>
> thanks,
> Lennert

What about a raid5 with a truly massive chunk size?  Brute force and 
inelegant, but simple to try.




