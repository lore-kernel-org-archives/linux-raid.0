From: Matt Tehonica <matt.tehonica@mac.com>
Subject: Re: RAID5 won't mount after reducing disks from 8 to 6
Date: Wed, 16 Feb 2011 21:22:13 -0500
Message-ID: <33846214-7C11-4F61-8EE7-927237D594ED@mac.com>
References: <C2D86BF5-AECE-49B3-B139-1CD6375DCFC9@mac.com>
 <20110217124214.00ad25dd@notabene.brown>
 <00E3AF11-6D18-4C5D-A165-56C86823A6D2@mac.com>
 <20110217131453.39444287@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20110217131453.39444287@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yeah, I'm definitely not putting mdadm at fault for my screw up. I realize mdadm can't check to make sure you resized the filesystem. I'll check with the xfs crew and see if there is anything xfs_repair can do. 

Sent from my iPhone

On Feb 16, 2011, at 9:14 PM, NeilBrown <neilb@suse.de> wrote:

> On Wed, 16 Feb 2011 20:47:08 -0500 Matt Tehonica <matt.tehonica@mac.com>
> wrote:
> 
>> To be honest, I couldn't find good directions on how exactly to resize an array to be smaller so I put some bits and pieces together to do it.  Guess I didn't understand everything beforehand because I didn't read anything about resizing the file system.  I thought setting the "array-size" would take care of moving data before rebuilding onto the 6 disks.
> 
> The next release of mdadm will be a bit more explicit in the man page about
> the need to resize the filesystem first - you aren't the first person to do
> this.
> 
>> 
>> Since I haven't resized the XFS filesystem, any recommendations on what to do next?  Think it's possible to recover any of the data?  For what it's worth, I haven't done anything to the 2 disks that I was going to remove.
> 
> 8 to 6 disks in a RAID6 means 6 to 4 data disks, so 1/3 of the space is gone.
> And it really is gone,  Little bits of it might be on the two devices that
> you were going to remove, but I doubt it would be usable, and it would be
> very hard to recover.
> 
> So your best bet it to convince xfs_repair to work with what you've got and
> try to knit together as much as it can  - which may be nothing, I really
> don't know.
> 
> Maybe you could ask on an XFS list somewhere.
> 
> But if you have any backups - I suggest they are by far your best bet.
> 
> I'm sorry, but it isn't really possible for mdadm to detect that you haven't
> resized your filesystem and warn you about it :-(
> 
> NeilBrown
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
