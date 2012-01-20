From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: Raid 6--best practices
Date: Fri, 20 Jan 2012 08:20:07 +0100
Message-ID: <4F1915A7.6040906@stud.tu-ilmenau.de>
References: <4F173D3D.6070902@npr.org>,<CF17461882827E43AD7DF6E471FFA903834EFD7853@EXCHANGE.ads.npr.org> <CF17461882827E43AD7DF6E471FFA903834EFD7858@EXCHANGE.ads.npr.org>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CF17461882827E43AD7DF6E471FFA903834EFD7858@EXCHANGE.ads.npr.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shain Miley <SMiley@npr.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Shain,

Am 20.01.2012 03:54, schrieb Shain Miley:
> Hello all,
> I have been doing some research into possible alternatives to our
> OpenSolaris/ZFS/Gluster file server.  The main reason behind this is,
> due to RedHat's recent purchase of Gluster, our current configuration
> will no longer be supported and even before the acquisition, the upgrade
> path for the OpenSolaris/ZFS stack was murky at best.
> 
> The current servers in question consist of a total of 48, 2TB drives.
> My thought was that I would setup a total of 6 RAID-6 arrays (each
> containing 7 drives + a spare or a flat 8 drive RAID-6 config) and place
> LVM + XFS on top of that.
> 
> My questions really are:
> 
> a)    What is the maximum number of drives typically seen in a RAID-6
> setup like this?  I noticed when looking at the Backblaze blog, that
> they are using RAID-6 with 15 disks (13 + 2 for parity).  That number seemed 
> kind of high to me....but I was wondering what others on the list thought.
> 
Typically RAID6 Arrays are most optimized with 2^n+2 drives, as in that
case the stripe-size * data-disks adds up to a "good" big-block-size of
a power of 2.  A rule of thumb is to have one redundancy for any 4
disks.  That makes a 6-drive RAID6 over-redundant and a 10-drive RAID6
"best to do".  Next would be an 18-drive RAID6 - which compromizes the
redundancy-rule big time.  So I'd go for a 40-drive RAID60 and see what
to do with the rest of the drives...

> b)    Would you recommend using any specific Linux distro over any other?  
> Right now I am trying to decide between Debian and Ubuntu....but I would be open to 
> any others...if there was a legitimate reason to do so (performance, stability, etc) in terms of the Raid codebase.

This question isn't easy to answer - it depends on your needs.  For
storage systems I typically recommend open-e (www.open-e.com), because
that's what we sell most (see www.exomium.com).  It's also most stable
as open-e does heavy QA on kernel and features.
> 
> Thanks in advance,
> 
> Shain
> 
Hope this was helpful,

Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

