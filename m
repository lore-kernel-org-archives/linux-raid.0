From: Wiliam Colls <william.colls@rogers.com>
Subject: Re: Raid 6--best practices
Date: Fri, 20 Jan 2012 00:28:12 -0500
Message-ID: <4F18FB6C.2090803@rogers.com>
References: <4F173D3D.6070902@npr.org>,<CF17461882827E43AD7DF6E471FFA903834EFD7853@EXCHANGE.ads.npr.org> <CF17461882827E43AD7DF6E471FFA903834EFD7858@EXCHANGE.ads.npr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CF17461882827E43AD7DF6E471FFA903834EFD7858@EXCHANGE.ads.npr.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shain Miley <SMiley@npr.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/19/2012 09:54 PM, Shain Miley wrote:
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
> b)    Would you recommend using any specific Linux distro over any other?
> Right now I am trying to decide between Debian and Ubuntu....but I would be open to
> any others...if there was a legitimate reason to do so (performance, stability, etc) in terms of the Raid codebase.
>
> Thanks in advance,
>
> Shain
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

No comment on the Raid6 question.

I have been using Ubuntu for the last 4 or 5 years. For my money, the 
best feature is the defined release intervals, and the Long Term Support 
(LTS) commitment of 5 years for specified releases, and easy upgrade 
path when moving to a new release.

Just my $0.02 Cdn.

-- 
I know that you believe that you understand what you think I said, but I 
am not sure that you realise that what you heard was not what I meant.
