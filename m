From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: high throughput storage server?
Date: Fri, 18 Feb 2011 14:49:20 +0100 (MET)
Message-ID: <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 14 Feb 2011, Matt Garman wrote:

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

Well, this seems fairly close to the LHC data analysis case, or HPC usage 
in general, both of which I'm rather familiar with.

> My initial thoughts/questions are:
>
>    (1) We need lots of spindles (i.e. many small disks rather than
> few big disks).  How do you compute disk throughput when there are
> multiple consumers?  Most manufacturers provide specs on their drives
> such as sustained linear read throughput.  But how is that number
> affected when there are multiple processes simultanesously trying to
> access different data?  Is the sustained bulk read throughput value
> inversely proportional to the number of consumers?  (E.g. 100 MB/s
> drive only does 33 MB/s w/three consumers.)  Or is there are more
> specific way to estimate this?

This is tricky. In general there isn't a good way of estimating this, 
because so much about this involves the way your load interacts with 
IO-scheduling in both Linux and (if you use them) raid controllers, etc.

The actual IO pattern of your workload is probably the biggest factor 
here, determining both if readahead will give any benefits, as well as how 
much sequential IO can be done as opposed to just seeking.

>    (2) The big storage server(s) need to connect to the network via
> multiple bonded Gigabit ethernet, or something faster like
> FibreChannel or 10 GbE.  That seems pretty straightforward.

I'd also look at the option of many small&cheap servers, especially if the 
load is spread out fairly even over the filesets.

>    (3) This will probably require multiple servers connected together
> somehow and presented to the compute machines as one big data store.
> This is where I really don't know much of anything.  I did a quick
> "back of the envelope" spec for a system with 24 600 GB 15k SAS drives
> (based on the observation that 24-bay rackmount enclosures seem to be
> fairly common).  Such a system would only provide 7.2 TB of storage
> using a scheme like RAID-10.  So how could two or three of these
> servers be "chained" together and look like a single large data pool
> to the analysis machines?

Here you would either maintain a large list of nfs mounts for the read 
load, or start looking at a distributed filesystem. Sticking them all into 
one big fileserver is easier on the administration part, but quickly gets 
really expensive when you look to put multiple 10GE interfaces on it.

If the load is almost all read and seldom updated, and you can afford the 
time to manually layout data files over the servers, the nfs mounts option 
might work well for you. If the analysis cluster also creates files here 
and there you might need a parallel filesystem.

2U machines with 12 3.5" or 16-24 2.5" hdd slots can be gotten pretty 
cheaply. Add a quad-gige card if your load can get decent sequential load, 
or look at fast/ssd 2.5" drives if you are mostly short random reads. Then 
add as many as you need to sustain the analysis speed you need. The 
advantage here is that this is really scalable, if you double the number 
of servers you get at least twice the IO capacity.

Oh, yet another setup I've seen is adding a some (2-4) fast disks to each 
of the analysis machines and then running a distributed replicated 
filesystem like hadoop over them.

/Mattias Wadenstein
