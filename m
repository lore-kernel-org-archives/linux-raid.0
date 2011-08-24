From: David Brown <david@westcontrol.com>
Subject: Re: mixing backup with app serving on same box
Date: Wed, 24 Aug 2011 14:10:21 +0200
Message-ID: <j32q0r$9bt$1@dough.gmane.org>
References: <20110824114938.GA24464@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110824114938.GA24464@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/08/2011 13:49, Louis-David Mitterrand wrote:
> Hi,
>
> I recently ordered a shiny Dell R510 2U server with 12x3.5" drives.
> This machine will primarily be a backup host for nightly incremental
> rsync runs of a dozen other machines.
>
> Since this is a well-spec'ed box with dual CPUs, generous bandwidth and
> 32G RAM I'm wondering if it could also do some medium web serving
> (mod_perl + postgres).
>
> For the main backup partition I plan in using a mdadm raid6 on 8x3T
> disks and raid6 4x1T disks for the app side.
>
> So my questions are:
>
> - is it realistic to have mix rsync processes and web serving on the
>    same host?
>
> - am I naive in thinking I can get away with it by using distinct disks
>    sets for each task?
>
> - all 12 disks being served by the same H200 controller, will the real
>    bottleneck be at the controller level?
>
> - any other consideration I should take into account?
>
> Thanks,


Backups are useful for several purposes.  The most common case for 
needing a backup is user error - someone deletes the wrong file, and 
needs a copy.  For that purpose, a backup close at hand is very useful.

The second important use case is for disaster recovery - imagine a fire 
or theft, or the OS going bananas and eating all your data, or a 
break-in on your webserver.  For those purposes, a backup on the main 
machine is useless.

Personally, I prefer two backup sets - one on-site (on the same machine, 
or a nearby machine) for the first use, and one off-site for 
emergencies.  So a backup scheme on this server is good for half your 
backup needs.

However, I'd make some more effort into separating the backup 
functionality and the webserver functionality.  I'd strongly recommend 
you look at openvz - it gives you lightweight virtualisation so that you 
can keep functions like this separate without the resource costs of a 
full virtualisation solution.



