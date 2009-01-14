From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: trouble adding spare
Date: Wed, 14 Jan 2009 08:39:21 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901140830280.11696@p34.internal.lan>
References: <496DB3A4.4090605@fastmail.co.uk> <alpine.DEB.1.10.0901140654100.11696@p34.internal.lan> <496DE2BD.6070905@fastmail.co.uk> <496DE763.9010300@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496DE763.9010300@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 14 Jan 2009, Max Waterman wrote:

> Max Waterman wrote:
>>> I would try:
>>> 
>>> 1. mdadm --examine --scan
>>> 2. Put that info into mdadm.conf.
> It's already there - I think that's how I got the line in the first place.
>>> 4. Otherwise, remove the spare from the array, zero the mdadm superblock.
> How would I do this? I tried :
>
> $ sudo /sbin/mdadm /dev/sdi --zero-superblock --force
> mdadm: /dev/sdi does not appear to be an md device
>
> Max.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Output from when I have run this in the past:
p34:~# mdadm --zero-superblock /dev/hde1
p34:~#

If that does not work, clean the drive out manually after removing it as 
a spare from the array:
dd if=/dev/zero of=/dev/sdi bs=1M

Then try to re-add it.

If that still does not work you may need to modify some additional bits 
possibly with/in regards to the spare itself, I only have one spare in my 
array and I use a partition with type (fd) for the spare.

The only other thing I can think of is the events for that spare were 
0.123 (example) and then after you installed OSX onto the drive, it could 
have deleted the superblock for mdadm from when it was created as a spare.

I have not fixed this problem in any of my use-cases, but it may(?) be 
necessary to re-write that superblock onto the spare so it is identified 
as such, however, how to do this, is a good question, it would probably be 
assembly or if that does not work you would need to create the array, 
assume clean (as you originally created it before) so the superblock is 
written to the spare.  This all seems too complicated though, there should 
(and probably) is a simpler way.

Justin.
