From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: Re: RAID 10 and Persistent Superblock
Date: Fri, 31 Oct 2003 12:33:59 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1067621639.6601.5.camel@localhost.localdomain>
References: <c6.2446066e.2cd3d85c@aol.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c6.2446066e.2cd3d85c@aol.com>
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 56-disk RAID10 and I have persistent superblocks on all of the
md devices.  I believe the RAID code is smart enough to know that a
superblock already exists and places a new superblock 'before' the other
one.

So the end of your disk should look like the following drawing:

-----------------------------------|
   DATA    |  RAID0SB  |   RAID1SB |
-----------------------------------|

When I created my RAID10 array, I believe that the superblocks were
created in this fashion.  Any RAID guru care to comment?

Regards,
Andy.


On Fri, 2003-10-31 at 10:23, AndyLiebman@aol.com wrote:
> A "simple" question regarding RAID 10. When I make a RAID 0 on top of three 
> RAID 1 arrays, should I use "persistent superblock = 1" in that top level 
> array? Won't that confuse the RAID software by putting two different UUIDs on the 
> drives -- one for the RAID 1 arrays and one for the RAID 0 array? 
> 
> As long as I have UUIDs for the three lower level RAID 1 arrays, I should be 
> able to start those arrays with mdadm even if my device ids change. 
> 
> Then shouldn't I be able to start the top level array without a UUID -- just 
> by referring to the mdX numbers? In other words, if md0, md1, md2 start, there 
> shouldn't be any confusion about which are the correct devices to start up 
> md3. Or am I missing something?
> 
> Appreciate your answers. 
> 
> Andy Liebman
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 

Regards,
Andrew Rechenberg
Infrastructure Team, Sherman Financial Group
