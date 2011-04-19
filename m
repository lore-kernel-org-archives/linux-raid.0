From: Gordon Henderson <gordon@drogon.net>
Subject: Re: debian software raid1
Date: Tue, 19 Apr 2011 22:10:14 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1104192148270.4097@unicorn.drogon.net>
References: <1303215166.2809.8.camel@valio> <BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com> <4DADB24F.2030300@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DADB24F.2030300@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 19 Apr 2011, Iordan Iordanov wrote:

> There is a lot of information, but also, I suspect there is a lot of 
> disagreement. One thing that I could not find a definitive answer on was the 
> question of whether or not to mirror swap.
>
> There are articles that propose mirroring partitions independently (rather 
> than the entire disk), and not mirroring swap, but adding two swap partitions 
> with equal priority. On the other hand, there are people who point out that 
> in the event where one of the disks in the mirror dies, the machine may cease 
> to function, because a part of its "memory" will have disappeared. However, 
> making swap part of the mirror opens a whole new can of worms. For instance, 
> could there be a deadlock possibility (for example after a suspend/resume 
> cycle) where mdadm is waiting for something which is swapped out onto swap 
> which is mirrored?
>
> It would be nice to have a discussion among people who have experience with 
> all of this.

I've not been active here for a long time - mostly because as far as I'm 
concerned Linux-Raid "just works" and it's as stable as I need it to be, 
however this subject caught my eye, so I'll add in my 2 penneth 
worth...

I've been putting swap on mirrored, and raided drives for as long as I've 
been using the MD stuff, and that's now well over 10 years now.

I do recall that there were such deadlock issues in the early days, but 
I'm also sure these were resolved very quickly indeed. MD has certianly 
saved my bacon when a disk has failled - and that includes swap 
partitions.

An example - swap on a 5-drive RAID-6 system:

   cat /proc/swaps
   Filename                                Type            Size    Used    Priority
   /dev/md2                                partition       2987704 1720    -1

and:

   md2 : active raid6 sde2[4] sdd2[3] sdc2[2] sdb2[1] sda2[0]
       2987712 blocks level 6, 64k chunk, algorithm 2 [5/5] [UUUUU]

another: (RAID1 - mirrored)

   cat /proc/swaps
   Filename                                Type            Size    Used    Priority
   /dev/md2                                partition       2007992 0       -1

and:

   md2 : active raid1 sdb2[0] sda2[1]
       2008000 blocks [2/2] [UU]

however just because I do it, doesn't mean it's perfect - but I can say 
that I've never had a server panic or otherwise crash due to me having 
swap on MD - at least not that I've been aware of. (but also note that 
I've never used MD on a system that I'd ever suspend or hibernate, but I 
have used MD with drive spin-down software with no ill effects!)

I'm actually of the opinion that to NOT put swap on RAID in an otherwise 
RAIDed system is just plain silly. Do it. You know it makes sense!

Gordon
