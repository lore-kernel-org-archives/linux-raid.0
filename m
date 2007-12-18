From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Raid over 48 disks
Date: Tue, 18 Dec 2007 13:27:14 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712181325480.13538@p34.internal.lan>
References: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Norman Elton <normelton@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 18 Dec 2007, Norman Elton wrote:

> We're investigating the possibility of running Linux (RHEL) on top of Sun's 
> X4500 Thumper box:
>
> http://www.sun.com/servers/x64/x4500/
>
> Basically, it's a server with 48 SATA hard drives. No hardware RAID. It's 
> designed for Sun's ZFS filesystem.
>
> So... we're curious how Linux will handle such a beast. Has anyone run MD 
> software RAID over so many disks? Then piled LVM/ext3 on top of that? Any 
> suggestions?
>
> Are we crazy to think this is even possible?
>
> Thanks!
>
> Norman Elton
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

It sounds VERY fun and exciting if you ask me!  The most disks I've used 
when testing SW RAID was 10 with various raid settings.  With that many 
drives you'd want RAID6 or RAID10 for sure incase more than one failed at 
the same time and definitely XFS/JFS/EXT4(?) as EXT3 is capped to 8TB.

I'd be curious what kind of aggregate bandwidth you can get off of it with 
that many drives.

Justin.
