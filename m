From: Bernd Schubert <bernd-schubert@web.de>
Subject: Re: RAID reconstruction problems
Date: Tue, 2 Sep 2003 18:04:31 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200309021804.31406.bernd-schubert@web.de>
References: <87wucrnb63.fsf@cs.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wucrnb63.fsf@cs.cmu.edu>
Content-Disposition: inline
To: Michael Duggan <md5i@sei.cmu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 02 September 2003 05:04, Michael Welsh Duggan wrote:
> I currently have two small Software RAIDs, a RAID 1 for my root
> partition, and a RAID 5 for my usr partition.  One of the disks in the
> arrays died, and I threw in a new disk in with the intention of
> rebuilding the arrays.
>
> The rebuilds failed, but in an extremely strange fashion.  Monitoring
> /proc/mdstat, it seems that the rebuilds are going just fine.  When
> they finish however, /proc/mdstat includes the new disk, but also
> declares it invalid.  The system continues running in degraded mode.
>
> When I run this from the root console, I get some messages from the
> raid subsystem, including full debugging output.  I have not yet
> figured out how to capture this output in order to include in this
> message, but I did write down a part of one attempt (this was by hand,
> so there may be small inconsistancies):
>
> RAID5 conf printout
>  --- rd:3 wd:2 fd:1
>  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:ide/host0/bus0/target1/lun0/part3
>  disk 1, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
>  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:ide/host2/bus1/target0/lun0/part3
> md: bug in file raid5.c, line 1901
>
> Here is some output from my system.  If any more information would be
> useful, or anyone thinks I should try something else, please let me
> know.  I would like to get out of my currently degraded state!

Hi,

Neil has posted several mdadm commands for similar problems like this. So I 
think you should install mdadm, search in the list-archive for problems like 
this and try to get a working array using mdadm.

Regards,
	Bernd
