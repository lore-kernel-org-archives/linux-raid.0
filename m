From: dean gaudet <dean@arctic.org>
Subject: Re: safest way to swap in a new physical disk
Date: Sat, 18 Nov 2006 10:55:12 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611181052440.15092@twinlark.arctic.org>
References: <6D7E98FD-D24F-402D-A7F0-63179FA3C49E@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6D7E98FD-D24F-402D-A7F0-63179FA3C49E@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Will Sheffler <willsheffler@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 14 Nov 2006, Will Sheffler wrote:

> Hi.
> 
> What is the safest way to switch out a disk in a software raid array created
> with mdadm? I'm not talking about replacing a failed disk, I want to take a
> healthy disk in the array and swap it for another physical disk. Specifically,
> I have an array made up of 10 250gb software-raid partitions on 8 300gb disks
> and 2 250gb disks, plus a hot spare. I want to switch the 250s to new 300gb
> disks so everything matches. Is there a way to do this without risking a
> rebuild? I can't back everything up, so I want to be as risk-free as possible.
> 
> I guess what I want is to do something like this:
> 
> (1) Unmount the array
> (2) Un-create the array
> (3) Somehow exactly duplicate partition X to a partition Y on a new disk
> (4) Re-create array with X gone and Y in it's place
> (5) Check if the array is OK without changing/activating it
> (6) If there is a problem, switch from Y back to X and have it as though
> nothing changed
> 
> The part I'm worried about is (3), as I've tried duplicating partition images
> before and it never works right. Is there a way to do this with mdadm?

if you have a recent enough kernel (2.6.15 i think) and recent enough 
mdadm (2.2.x i think) you can do this all online without losing redundancy 
for more than a few seconds... i placed a copy of instructions and further 
discussions of what types of problems this method has here:

http://arctic.org/~dean/proactive-raid5-disk-replacement.txt

it's actually perfect for your situation.

-dean
