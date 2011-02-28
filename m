From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Mon, 28 Feb 2011 17:14:20 -0600
Message-ID: <4D6C2C4C.5090204@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com> <20110215044434.GA9186@septictank.raw-sewage.fake> <4D6AC288.20101@wildgooses.com> <4D6BC33E.7070703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D6BC33E.7070703@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Ed W <lists@wildgooses.com>, Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Joe Landman put forth on 2/28/2011 9:46 AM:
> On 02/27/2011 04:30 PM, Ed W wrote:
> 
> [...]
> 
>> It would appear that you can use a much lower powered system to
>> basically push jobs out to the processing machines in advance, this way
>> your bandwidth basically only needs to be:
>> size_of_job * num_machines / time_to_process_jobs
> 
> This would be good.  Matt's original argument suggested he needed this
> as his sustained bandwidth given the way the analysis proceeded.

And Joe has provided a nice mathematical model for quantifying it.

> If we assume that the processing time is T_p, and the communication time
> is T_c, ignoring other factors, the total time for 1 job is T_j = T_p +
> T_c.  If T_c << T_p, then you can effectively ignore bandwidth related
> issues (and use a much smaller bandwidth system).  For T_c << T_p, lets
> (for laughs) say T_c = 0.1 x T_p (e.g. communication time is 1/10th the
> processing time).  Then even if you halved your bandwidth, and doubled
> T_c, you are making only an about 10% increase in your total execution
> time for a job.
> 
> With Nmachines each with Ncores, you have Nmachines x Ncores jobs going
> on all at once. If T_c << T_p (as in the above example), then most of
> the time, on average, the machines will not be communicating.  In fact,
> if we do a very rough first pass approximation to an answer (there are
> more accurate statistical models) for this, one would expect the network
> to be used T_c/T_p fraction of the time by each process.  Then the total
> consumption of data for a run (assuming all runs are *approximately* of
> equal duration)
> 
>     D = B x T_c
> 
> D being the amount of data in MB or GB, and B being the bandwidth
> expressed in MB/s or GB/s.  Your effective bandwidth per run, Beff will be
> 
>     D = Beff x T = Beff x (T_c + T_p)
> 
> For Nmachines x Ncores jobs, Dtotal is the total data transfered
> 
>     Dtotal    = Nmachines x Ncores * D = Nmachines x Ncores x Beff
>           x (T_c + T_p)
> 
> 
> You know Dtotal (aggregate data needed for run).  You know Nmachines and
> Ncores.  You know T_c and T_p (approximately).  From this, solve for
> Beff.  Thats what you have to sustain (approximately).

This assumes his application is threaded and scales linearly across
multiple cores.  If not, running Ncores processes on each node should
achieve a similar result to the threaded case, assuming the application
is written such that multiple process instances don't trip over each
other by say, all using the same scratch file path/name, etc, etc.

-- 
Stan
