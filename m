From: Brendan Conoboy <blc@redhat.com>
Subject: Re: Raid over 48 disks
Date: Tue, 18 Dec 2007 13:36:03 -0700
Message-ID: <47682F33.7040701@redhat.com>
References: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Norman Elton <normelton@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Norman Elton wrote:
> We're investigating the possibility of running Linux (RHEL) on top of 
> Sun's X4500 Thumper box:
> 
> http://www.sun.com/servers/x64/x4500/

Neat- 6 8 port SATA controllers!  It'll be worth checking to be sure 
each controller has equal bandwidth.  If some controllers are on slower 
buses than others you may want to consider that and balance the md 
device layout.

> So... we're curious how Linux will handle such a beast. Has anyone run 
> MD software RAID over so many disks? Then piled LVM/ext3 on top of that? 
> Any suggestions?

There used to be a maximum number of devices allowed in a single md 
device.  Not sure if that is still the case.

With this many drives you would be well advised to make smaller raid 
devices then combine them into a larger md device (or via lvm, etc). 
Consider a write with a 48 device raid5- the system may need to read 
blocks from all those drives before a single write!

If it were my system, all ports were equally well connected, I'd create 
3 16 drive RAID5's with 1 hot spare, then combine them via raid 0 or 
lvm.  That's just my usage scenario, though (modest reliability, 
excellent read speed, modest write speed).

If you put ext3 on time, remember to use the stride option when making 
the filesystem.

> Are we crazy to think this is even possible?

Crazy, possible, and fun!

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
