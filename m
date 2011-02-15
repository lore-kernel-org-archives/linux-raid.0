From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: high throughput storage server?
Date: Tue, 15 Feb 2011 14:48:05 +0100
Message-ID: <4D5A8415.5000905@gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dne 15.2.2011 0:59, Matt Garman napsal(a):
> For many years, I have been using Linux software RAID at home for a
> simple NAS system.  Now at work, we are looking at buying a massive,
> high-throughput storage system (e.g. a SAN).  I have little
> familiarity with these kinds of pre-built, vendor-supplied solutions.
> I just started talking to a vendor, and the prices are extremely high.
> 
> So I got to thinking, perhaps I could build an adequate device for
> significantly less cost using Linux.  The problem is, the requirements
> for such a system are significantly higher than my home media server,
> and put me into unfamiliar territory (in terms of both hardware and
> software configuration).
> 
> The requirement is basically this: around 40 to 50 compute machines
> act as basically an ad-hoc scientific compute/simulation/analysis
> cluster.  These machines all need access to a shared 20 TB pool of
> storage.  Each compute machine has a gigabit network connection, and
> it's possible that nearly every machine could simultaneously try to
> access a large (100 to 1000 MB) file in the storage pool.  In other
> words, a 20 TB file store with bandwidth upwards of 50 Gbps.
> 
> I was wondering if anyone on the list has built something similar to
> this using off-the-shelf hardware (and Linux of course)?
> 
> My initial thoughts/questions are:
> 
>     (1) We need lots of spindles (i.e. many small disks rather than
> few big disks).  How do you compute disk throughput when there are
> multiple consumers?  Most manufacturers provide specs on their drives
> such as sustained linear read throughput.  But how is that number
> affected when there are multiple processes simultanesously trying to
> access different data?  Is the sustained bulk read throughput value
> inversely proportional to the number of consumers?  (E.g. 100 MB/s
> drive only does 33 MB/s w/three consumers.)  Or is there are more
> specific way to estimate this?
> 
>     (2) The big storage server(s) need to connect to the network via
> multiple bonded Gigabit ethernet, or something faster like
> FibreChannel or 10 GbE.  That seems pretty straightforward.
> 
>     (3) This will probably require multiple servers connected together
> somehow and presented to the compute machines as one big data store.
> This is where I really don't know much of anything.  I did a quick
> "back of the envelope" spec for a system with 24 600 GB 15k SAS drives
> (based on the observation that 24-bay rackmount enclosures seem to be
> fairly common).  Such a system would only provide 7.2 TB of storage
> using a scheme like RAID-10.  So how could two or three of these
> servers be "chained" together and look like a single large data pool
> to the analysis machines?
> 
> I know this is a broad question, and not 100% about Linux software
> RAID.  But I've been lurking on this list for years now, and I get the
> impression there are list members who regularly work with "big iron"
> systems such as what I've described.  I'm just looking for any kind of
> relevant information here; any and all is appreciated!
> 
> Thank you,
> Matt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

If you really need to handle 50Gbit/s storage traffic, then it's not so
easy for hobby. For good price you probably want multiple machines with
lots hard drives and interconnects..

Might be worth to ask here:
Newsgroups: gmane.comp.clustering.beowulf.general

HTH, Z.

