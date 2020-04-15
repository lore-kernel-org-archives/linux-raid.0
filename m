From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Wed, 15 Apr 2020 17:53:17 +0200
Message-ID: <71886beb-495f-d7d5-75f2-f91a53ed4bd3@peter-speer.de>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <394a3255-251c-41d1-8a65-2451e5503ef9@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <394a3255-251c-41d1-8a65-2451e5503ef9@teksavvy.com>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: "J. Brian Kelley" <jbk@teksavvy.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 15.04.20 17:02, J. Brian Kelley wrote:
> As for the final heresy, BTRFS, really not the time or place...
> 
>    - But it does provide a 'swap FILE' capability (more memory is still 
> preferable).
>    - RAID1 is not affected by the "write-hole".
>    - extremely efficient snapshots
>    - everything in the file system (no LVM, no MDADM)
> 
> The only concern is that you MUST instruct BTRFS to NOT use the entire 
> available partition (btrfs shrink) to allow leeway for a resize.

I was thinking about using btrfs too, but I am afraid of loosing data 
and making inreversable faults which could cause data loss/fragmentation 
(for databases and kvm-images, i.e.) and so on.

I have found a lot of relevant information how to use it somewhere in 
the net and how to do this and that but not the one place where all the 
dos and donts are collected to start with :-(

Your hint about btrfs is new to me also even I read the docs in their 
wiki before. I bet I will find myself in a situation/environment which 
will be hard to administrate because of a gap of information I was 
overseeing when I took an action which I shouldn't.
