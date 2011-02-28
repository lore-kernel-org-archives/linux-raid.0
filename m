From: Joe Landman <joe.landman@gmail.com>
Subject: Re: high throughput storage server?
Date: Mon, 28 Feb 2011 10:46:06 -0500
Message-ID: <4D6BC33E.7070703@gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com> <20110215044434.GA9186@septictank.raw-sewage.fake> <4D6AC288.20101@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D6AC288.20101@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/27/2011 04:30 PM, Ed W wrote:

[...]

> It would appear that you can use a much lower powered system to
> basically push jobs out to the processing machines in advance, this way
> your bandwidth basically only needs to be:
> size_of_job * num_machines / time_to_process_jobs

This would be good.  Matt's original argument suggested he needed this 
as his sustained bandwidth given the way the analysis proceeded.

If we assume that the processing time is T_p, and the communication time 
is T_c, ignoring other factors, the total time for 1 job is T_j = T_p + 
T_c.  If T_c << T_p, then you can effectively ignore bandwidth related 
issues (and use a much smaller bandwidth system).  For T_c << T_p, lets 
(for laughs) say T_c = 0.1 x T_p (e.g. communication time is 1/10th the 
processing time).  Then even if you halved your bandwidth, and doubled 
T_c, you are making only an about 10% increase in your total execution 
time for a job.

With Nmachines each with Ncores, you have Nmachines x Ncores jobs going 
on all at once. If T_c << T_p (as in the above example), then most of 
the time, on average, the machines will not be communicating.  In fact, 
if we do a very rough first pass approximation to an answer (there are 
more accurate statistical models) for this, one would expect the network 
to be used T_c/T_p fraction of the time by each process.  Then the total 
consumption of data for a run (assuming all runs are *approximately* of 
equal duration)

	D = B x T_c

D being the amount of data in MB or GB, and B being the bandwidth 
expressed in MB/s or GB/s.  Your effective bandwidth per run, Beff will be

	D = Beff x T = Beff x (T_c + T_p)

For Nmachines x Ncores jobs, Dtotal is the total data transfered

	Dtotal	= Nmachines x Ncores * D = Nmachines x Ncores x Beff
   		x (T_c + T_p)


You know Dtotal (aggregate data needed for run).  You know Nmachines and 
Ncores.  You know T_c and T_p (approximately).  From this, solve for 
Beff.  Thats what you have to sustain (approximately).

> So if the time to process jobs is significant then you have quite some
> time to push out the next job to local storage ready?
>
> Firstly is this architecture workable? If so then you have some new
> performance parameters to target for the storage architecture?
>
> Good luck
>
> Ed W

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
