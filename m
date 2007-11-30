From: Neil Brown <neilb@suse.de>
Subject: Re: assemble vs create an array.......
Date: Fri, 30 Nov 2007 16:32:04 +1100
Message-ID: <18255.41044.614676.410107@notabene.brown>
References: <474F869D.5040503@mpigani.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dragos on Thursday November 29
Sender: linux-raid-owner@vger.kernel.org
To: Dragos <dragos@mpigani.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 29, dragos@mpigani.org wrote:
> Hello,
> I had created a raid 5 array on 3 232GB SATA drives. I had created one 
> partition (for /home) formatted with either xfs or reiserfs (I do not 
> recall).
> Last week I reinstalled my box from scratch with Ubuntu 7.10, with mdadm 
> v. 2.6.2-1ubuntu2.
> Then I made a rookie mistake: I --create instead of --assemble. The 
> recovery completed. I then stopped the array, realizing the mistake.
> 
> 1. Please make the warning more descriptive: ALL DATA WILL BE LOST, when 
> attempting to created an array over an existing one.

No matter how loud the warning is, people will get it wrong... unless
I make it actually impossible to corrupt data (which may not be
possible) in which case it will inconvenience many more people.

> 2. Do you know of any way to recover from this mistake? Or at least what 
> filesystem it was formated with.

If you created the same array with the same devices and layout etc,
the data will still be there, untouched.
Try to assemble the array and use "fsck" on it.

When you create a RAID5 array, all that is changed is the metadata (at
the end of the device) and one drive is changed to be the xor of all
the others.

> 
> Any help would be greatly appreciated. I have hundreds of family digital 
> pictures and videos that are irreplaceable.

You have probably heard it before, but RAID is no replacement for
backups. 
My photos are one two separate computers, one with RAID.  And I will
be backing them up to DVD any day now ..... really!!   or maybe next
year, if I remember :-)

NeilBrown
