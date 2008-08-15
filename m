From: Neil Brown <neilb@suse.de>
Subject: Re: single RAID slower than aggregate multi-RAID?
Date: Sat, 16 Aug 2008 08:02:09 +1000
Message-ID: <18597.64737.508658.390657@notabene.brown>
References: <alpine.DEB.1.10.0808151607560.5400@kurp.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jan Wagner on Friday August 15
Sender: linux-raid-owner@vger.kernel.org
To: Jan Wagner <jwagner@kurp.hut.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 15, jwagner@kurp.hut.fi wrote:
> Hi,
> 
> at work we have been experimenting with SATA-II port multipliers and SATA 
> controllers (FIS-based). For some reason the RAID-0 performance is 
> relatively awful.
> 
> We have one 4xeSATA controller card ADSA3GPX8-4E, twelve SpinPoint F1 
> disks that handle ~110MB/sec, and four port Addonics port multiplier 
> boxes. Ubuntu, kernel 2.6.24-19-generic x86_64, 2 x AMD2212 Opteron on an 
> Asus L1N64-SLI WS.
> 
> We did two sequential writing tests. One test with all 12 disks 
> behind the controller placed into one mdadm RAID-0, 512k..2048k 
> chunksize. We get ~475 MB/s.
> 
> The second test used four "mdadm --create"'s to reassign the 12 drives 
> into four RAID-0 with 3 disks in each. All four raids were simultaneously 
> written to. We get ~250 MB/s/raid and 1000 MB/s aggregate.
> 
> So the controller can handle at least 1000 MB/s.
> 
> My question is why is the single RAID setup more than half slower? Any 
> ideas?
> 
> Is there some kernel per-device bandwidth throttling?

Yes, but it shouldn't be affecting you.
The kernel only allows 40% (/proc/sys/vm/dirty_ratio) of memory to be
dirty.  Once you have more than that, writes will be throttled to
avoid dirtying all of memory.  Writes to devices which are slower will
be allowed a smaller share of the 40%.
You should only need about 12Meg of dirty memory to keep your RAID0
busy, and I doubt that is even 1% of your memory.

md/raid0 has very little overhead.  It just encourages the filesystem
to send requests that are aligned with the chunks, and then sends each
request on to the target drive without any further intervention.   So
the queue for each device should be kept full, and the individual
devices should be going at full speed.

So to make sure I'm not misunderstanding you description, could you
run the two tests again: 12disk raid0 and 4*3disk raid0,  and for
each report
  mdadm -D   of each array
  output of  
     time dd if=/dev/zero of=/dev/mdXX bs=1024k
  on all arrays in parallel
Using a chunksize of 1024.

While doing this, watch the values of "Dirty" and "Writeback" in
/proc/meminfo and see how high they get.  And report MemTotal just to
get a complete picture.

Thanks,
NeilBrown
