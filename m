From: Gordon Henderson <gordon@drogon.net>
Subject: Re: mixing backup with app serving on same box
Date: Wed, 24 Aug 2011 14:14:56 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1108241404520.6833@unicorn.drogon.net>
References: <20110824114938.GA24464@apartia.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110824114938.GA24464@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 24 Aug 2011, Louis-David Mitterrand wrote:

> Hi,
>
> I recently ordered a shiny Dell R510 2U server with 12x3.5" drives.
> This machine will primarily be a backup host for nightly incremental
> rsync runs of a dozen other machines.
>
> Since this is a well-spec'ed box with dual CPUs, generous bandwidth and
> 32G RAM I'm wondering if it could also do some medium web serving
> (mod_perl + postgres).

Medium?

OK, so this is probably not the best place to be asking this stuff, but a 
lot will depend on what you mean by medium, however I know of busy 
ecommerce sites that are served on much lessser hardware than you have.

> For the main backup partition I plan in using a mdadm raid6 on 8x3T
> disks and raid6 4x1T disks for the app side.
>
> So my questions are:
>
> - is it realistic to have mix rsync processes and web serving on the
>  same host?

If the backup is mainly at night and the serving side is mainly during the 
day, (but watch for an international audience) then why not?

> - am I naive in thinking I can get away with it by using distinct disks
>  sets for each task?

Seems like an OK idea to me..

> - all 12 disks being served by the same H200 controller, will the real
>  bottleneck be at the controller level?

Possibly..

> - any other consideration I should take into account?

The cost of providing separate servers...

However, FWIW, I do something similar with my own hosted LAMP servers - as 
well as an offsite backup of critical data, they each rsync to a mirror 
overnight and as most of my physical servers are now 'hosts' for virtual 
servers using LXC, then in-case of a total hardware failure, I can 
actually bring-up the virtual servers on new hardware more or less right 
away (minus the data delta since the backup of-course).

Make sure you use a big chunk-size on the RAID-6, and make sure the 
underlying filesystem can make use of it too, if possible. (The -Ostride 
options for ext3/4 for exmaple) do take time building it and benchmarking 
it for your chosen purpose before going live...

Gordon
