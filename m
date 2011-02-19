From: Joe Landman <joe.landman@gmail.com>
Subject: Re: high throughput storage server?
Date: Fri, 18 Feb 2011 19:24:58 -0500
Message-ID: <4D5F0DDA.1000100@gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/18/2011 08:49 AM, Mattias Wadenstein wrote:
> On Mon, 14 Feb 2011, Matt Garman wrote:

[...]

>> I was wondering if anyone on the list has built something similar to
>> this using off-the-shelf hardware (and Linux of course)?
>
> Well, this seems fairly close to the LHC data analysis case, or HPC
> usage in general, both of which I'm rather familiar with.

Its similar to many HPC workloads dealing with large data sets.  There's 
nothing unusual about this in the HPC world.

>
>> My initial thoughts/questions are:
>>
>> (1) We need lots of spindles (i.e. many small disks rather than
>> few big disks). How do you compute disk throughput when there are
>> multiple consumers? Most manufacturers provide specs on their drives
>> such as sustained linear read throughput. But how is that number
>> affected when there are multiple processes simultanesously trying to
>> access different data? Is the sustained bulk read throughput value
>> inversely proportional to the number of consumers? (E.g. 100 MB/s
>> drive only does 33 MB/s w/three consumers.) Or is there are more
>> specific way to estimate this?
>
> This is tricky. In general there isn't a good way of estimating this,
> because so much about this involves the way your load interacts with
> IO-scheduling in both Linux and (if you use them) raid controllers, etc.
>
> The actual IO pattern of your workload is probably the biggest factor
> here, determining both if readahead will give any benefits, as well as
> how much sequential IO can be done as opposed to just seeking.

Absolutely.

Good real time data can be had from a number of tools.  Collectl, 
iostat, etc (sar ...).  I personally like atop for the "dashboard" like 
view.  Collectl and others can get you even more data that you can analyze.

>
>> (2) The big storage server(s) need to connect to the network via
>> multiple bonded Gigabit ethernet, or something faster like
>> FibreChannel or 10 GbE. That seems pretty straightforward.
>
> I'd also look at the option of many small&cheap servers, especially if
> the load is spread out fairly even over the filesets.

Here is where things like GlusterFS and FhGFS shine.  When Ceph firms up 
you can use this.  Happily all of these do run atop an MD raid device 
(to tie into the list).

>> (3) This will probably require multiple servers connected together
>> somehow and presented to the compute machines as one big data store.
>> This is where I really don't know much of anything. I did a quick
>> "back of the envelope" spec for a system with 24 600 GB 15k SAS drives
>> (based on the observation that 24-bay rackmount enclosures seem to be
>> fairly common). Such a system would only provide 7.2 TB of storage
>> using a scheme like RAID-10. So how could two or three of these
>> servers be "chained" together and look like a single large data pool
>> to the analysis machines?
>
> Here you would either maintain a large list of nfs mounts for the read
> load, or start looking at a distributed filesystem. Sticking them all
> into one big fileserver is easier on the administration part, but
> quickly gets really expensive when you look to put multiple 10GE
> interfaces on it.
>
> If the load is almost all read and seldom updated, and you can afford
> the time to manually layout data files over the servers, the nfs mounts
> option might work well for you. If the analysis cluster also creates
> files here and there you might need a parallel filesystem.

One of the nicer aspects of GlusterFS in this context is that it 
provides an NFS compatible server that NFS clients can connect to.  Some 
things aren't supported right now in the current release, but I 
anticipate they will be soon.

Moreover, with the distribute mode, it will do a reasonable job of 
distributing the files among the nodes.  Sort of like the nfs layout 
model, but with a "random" distribution.  This should be, on average, 
reasonably good.

>
> 2U machines with 12 3.5" or 16-24 2.5" hdd slots can be gotten pretty
> cheaply. Add a quad-gige card if your load can get decent sequential
> load, or look at fast/ssd 2.5" drives if you are mostly short random
> reads. Then add as many as you need to sustain the analysis speed you
> need. The advantage here is that this is really scalable, if you double
> the number of servers you get at least twice the IO capacity.
>
> Oh, yet another setup I've seen is adding a some (2-4) fast disks to
> each of the analysis machines and then running a distributed replicated
> filesystem like hadoop over them.

Ugh ... short-stroking drives or using SSDs?  Quite cost-inefficient for 
this work.  And given the HPC nature of the problem, its probably a good 
idea to aim for more cost-efficient.

This said, I'd recommend at least looking at GlusterFS.  Put it atop an 
MD raid (6 or 10), and you should be in pretty good shape with the right 
network design.  That is, as long as you don't use a bad SATA/SAS HBA.

Joe
-- 
Joe Landman
landman@scalableinformatics.com
