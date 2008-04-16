From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Mapping physical disk block to logical block to selectively repair w/o forcing rescan
Date: Tue, 15 Apr 2008 17:35:15 -0700
Message-ID: <e9c3a7c20804151735n6793339dl764c0d57aedabc57@mail.gmail.com>
References: <A49AB75A717185448F69082E969E536B03C2647E@34093-EVS1C2.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A49AB75A717185448F69082E969E536B03C2647E@34093-EVS1C2.exchange.rackspace.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 15, 2008 at 1:47 PM, David Lethe <david@santools.com> wrote:
> I have some code that does some background media scanning that results in a list of physical disks and block numbers that are known bad. I want to repair the logical (md) block(s) that they correspond to (assuming not RAID0, of course) without a draconian full repair/rescan.  As such, I need a physical to logical mapping technique.  It doesn't appear that there is a built-in mechanism in mdadm or by echoing a command to the /proc/mdstat, or anything else to force the md subsystem to repair the (parity protected) logical block associated with the physical disk and block that is known bad.
>
>  (raid5extend.c has a phys2log function that seems to take everything into consideration, and RAID1 is a non-issue,  but as long as I am going to do this, then might as well cover all the bases and make sure it is done right)
>
>  Has anybody written a script or something, or is there a technique I have missed that will provide block-level mapping?  I don't want to muck with modifying the md driver ... a shell script would be fine as this would be a rare occurrence, and since the disk will take billions of clock cycles to remap a bad sector, then an inefficient mapping script will hardly be noticeable.
>
>  Also, assuming I have to write such a script and now know that block X on /dev/mdY needs to be repaired, then is there any risk of data corruption if I simply issue a read  dd if=/dev/md$Y of=/dev/null count=1 skip=$X to force the md driver to repair the stripe?
>  (Actually, count should be increased large enough to force a non-cached read, and I think block number might need to be examined to make sure that it is not associated with a block that contains parity information, otherwise, the md engine might not detect the problem and force parity rebuild).
>
>  Any advice, comments, code will be appreciated.
>

raid5_compute_sector() in drivers/md/raid5.c maps the logical RAID
block to the physical block.  Is that what you are looking for?

--
Dan
