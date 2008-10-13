From: Neil Brown <neilb@suse.de>
Subject: Re: /sys/block/md0 still present after mdadm -S and -r
Date: Mon, 13 Oct 2008 11:56:50 +1100
Message-ID: <18674.40146.187485.200241@notabene.brown>
References: <8CAEDF2F5FF1BF0-E4C-2919@WEBMAIL-MY17.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from thomas62186218@aol.com on Friday September 26
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 26, thomas62186218@aol.com wrote:
> Hi All,
> 
> I created an md device as follows:
> 
> mdadm -C -f -e 1.0 -R /dev/md0 -l 0 -n 2 -c 32 /dev/sdc1 /dev/sdg1
> 
> It was successful and started.
> 
> I then want to delete this md device and did as follows:
> 
> mdadm -S /dev/md0
> mdadm /dev/md0 -r
> mdadm --zero-superblock /dev/sdc1
> mdadm --zero-superblock /dev/sdg1
> 
> I did not receive any errors. Afterwards, md0 was no longer visible in 
> /proc/mdstat.
> 
> However, there is still /sys/block/md0 entry, as well as an /dev/md0 
> entry. I would have expected these to be gone.
> 
> Is my md0 not getting fully deleted?

The array is completely gone.  That fact that you can still see
/sys/block/md0 is an implementation artifact.  It is very difficult to
make it go away in a race-free way, and there is little cost is
leaving it there.

NeilBrown

