From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: Re: Software RAID on Windows using Embedded Linux?
Date: Sun, 31 Jul 2005 09:22:51 -0500
Message-ID: <6d5bedd805073107225b180bb@mail.gmail.com>
References: <6d5bedd8050724070995073e1@mail.gmail.com>
	 <62b0912f050724075638c18d91@mail.gmail.com>
Reply-To: Ewan Grantham <ewan.grantham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f050724075638c18d91@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Well, the past couple of days have been quite a learning experience for me...

To begin with, and to show I'm not totally pig headed, I tried the
Tom's Hardware approach. Turns out that it doesn't work in multiple
ways in my situation. Specifically:

- Dynamic Disks aren't supported in XP Home, not even with the hacked files

- While Dynamic Disks are supported in Pro and Server, you can't make
firewire or USB-2 disks dynamic in any version of windows. There is a
registry hack to make firewire disks capable of being made dynamic in
Win XP, but there is no such hack for USB-2

IOW, in my situation, these answers aren't an option.

So I got coLinux setup with samba and raid. Does it work? Yes. Is it
fast enough? Well, that depends on your needs. For just plain copying
files around, it's about 1/3 the speed of a native copy for large
files between external disks. For playing back music, this is fast
enough. For playing back video, it isn't.

Which brings me back to the question - would I see any better
performance with QEMU and the preliminary version of the accelerator
for Windows, or am I just going to have to accept that I need another
machine if I want a RAID array? Not that I expect anyone else here has
tried this, but figured y'all might find this to be useful info. Of
course if someone who's already more familiar with QEMU did want to
try this and let me know if it works... :-)

Thanks again,
Ewan
