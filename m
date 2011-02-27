From: Ed W <lists@wildgooses.com>
Subject: Re: high throughput storage server?
Date: Sun, 27 Feb 2011 21:30:48 +0000
Message-ID: <4D6AC288.20101@wildgooses.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com> <20110215044434.GA9186@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110215044434.GA9186@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Your application appears to be an implementation of a queue processing 
system?  ie each machine: pulls a file down, processes it, gets the next 
file, etc?

Can you share some information on
- the size of files you pull down (I saw something in another post)
- how long each machine takes to process each file
- whether there is any dependency between the processing machines? eg 
can each machine operate completely independently of the others and 
start it's job when it wishes (or does it need to sync?)

Given the tentative assumption that
- processing each file takes many multiples of the time needed to 
download the file, and
- files are processed independently

It would appear that you can use a much lower powered system to 
basically push jobs out to the processing machines in advance, this way 
your bandwidth basically only needs to be:
     size_of_job * num_machines / time_to_process_jobs

So if the time to process jobs is significant then you have quite some 
time to push out the next job to local storage ready?

Firstly is this architecture workable?  If so then you have some new 
performance parameters to target for the storage architecture?

Good luck

Ed W
