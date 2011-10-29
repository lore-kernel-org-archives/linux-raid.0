From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid(1) and block caching
Date: Sat, 29 Oct 2011 00:20:12 -0500
Message-ID: <4EAB8D0C.90908@hardwarefreak.com>
References: <CAGqmV7p+GP-Ou-zUhq2rBb_9_tAEX6PRtQatvLCG9=FuOPNsow@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7p+GP-Ou-zUhq2rBb_9_tAEX6PRtQatvLCG9=FuOPNsow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/28/2011 11:49 PM, CoolCold wrote:
> Hello!
> 
> There is holywar once again on nginx maillist about standalone drives
> vs raid1 arrays for serving static files. By standalone drives it is
> assumed that file "Filename1" exist on /mnt/disk1, /mnt/disk2,
> /mnt/diskN where /mnt/diskX is mountpoint for drives /dev/sdY.
> 
> As there are some pros and cons on both sides (at least theoretically)
>  I have dumb question - let's say our array md1 consists on 3 drives -
> /dev/sd{a,b,c} - and when data read from md1 occurs, which block is
> cached in VFS (or may be other cache in system, it would be nice to
> know which part of system is doing caching)  - the block from md1
> itself or from certain drive? If it is drive-based block cache, it's
> gonna be potentially memory wasting to keep 3 similar data copies, so
> I assume md does data reads with something like O_DIRECT flag, but as
> I 1) don't know C 2) don't know kernel, I'm asking this on the list to
> make this clean for myself.

If this is for a single web server, who cares?  If this is a farm,
again, who cares?  In the case of a single server you're not concerned
with performance or you'd have a farm.  In the case of a farm, one will
store all of the static content on a central NFS/SMB server for easy
administration of content.  In the NFS/SMB case you can even PXE boot
diskless farm servers.  Now, does it make a difference where the cached
files/blocks reside, or simply that we've cached them in RAM for faster
access?  And does it make a difference which kernel component is doing
the caching, and whether it's block or file level caching?  I say it
doesn't matter one bit in the real world.

If one is *that* concerned with file access latency one will pre-load
all the static files into a RAMdisk anyway, eliminating this argument
altogether.

-- 
Stan
