From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: high throughput storage server?
Date: Tue, 1 Mar 2011 21:44:18 -0600
Message-ID: <AANLkTinjPJJrUYrA=fxcau02Q+4Z67YVsJhcGxeTpAAW@mail.gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
	<AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>
	<20110215044434.GA9186@septictank.raw-sewage.fake>
	<4D6AC288.20101@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D6AC288.20101@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Feb 27, 2011 at 3:30 PM, Ed W <lists@wildgooses.com> wrote:
> Your application appears to be an implementation of a queue processin=
g
> system? =A0ie each machine: pulls a file down, processes it, gets the=
 next
> file, etc?

Sort of.  It's not so much "each machine" as it is "each job".  A
machine can have multiple jobs.

At this point I'm not exactly sure what the jobs' specifics are; that
is, not sure if a job reads a bunch of files at once, then processes;
or, reads one file, then processes (as you described).

> Can you share some information on
> - the size of files you pull down (I saw something in another post)

They vary; they can be anywhere from about 100 MB to a few TB.
Average is probably on the order of a few hundred MB.

> - how long each machine takes to process each file

I'm not sure how long a job takes to process a file; I'm trying to get
these answers from the people who design and run the jobs.

> - whether there is any dependency between the processing machines? eg=
 can
> each machine operate completely independently of the others and start=
 it's
> job when it wishes (or does it need to sync?)

I'm fairly sure the jobs are independent.

> Given the tentative assumption that
> - processing each file takes many multiples of the time needed to dow=
nload
> the file, and
> - files are processed independently
>
> It would appear that you can use a much lower powered system to basic=
ally
> push jobs out to the processing machines in advance, this way your ba=
ndwidth
> basically only needs to be:
> =A0 =A0size_of_job * num_machines / time_to_process_jobs
>
> So if the time to process jobs is significant then you have quite som=
e time
> to push out the next job to local storage ready?
>
> Firstly is this architecture workable? =A0If so then you have some ne=
w
> performance parameters to target for the storage architecture?

That might be workable, but it would require me (or someone) to
develop and deploy the job dispatching system.  Which is certainly
doable, but it might meet some "political" resistance.  My boss
basically said, "find a system to buy or spec out a system to build
that meets [the requirements I've mentioned in this and other
emails]."
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
