From: Wolfram Schlich <lists@schlich.org>
Subject: Re: ANNOUNCE: mdadm 1.2.0 - A tool for managing Soft RAID under Linux
Date: Fri, 21 Mar 2003 15:38:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030321143817.ALLYOURBASEAREBELONGTOUS.A8209@bla.fasel.org>
References: <15983.46165.380845.237040@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15983.46165.380845.237040@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* Neil Brown <neilb@cse.unsw.edu.au> [2003-03-12 23:40]:
> 
> 
> I am pleased to announce the availability of 
>    mdadm version 1.2.0
> It is available at
>    http://www.cse.unsw.edu.au/~neilb/source/mdadm/
> and
>    http://www.{countrycode}.kernel.org/pub/utils/raid/mdadm/
> 
> as a source tar-ball and (at the first site) as an SRPM, and as an RPM for i386.
> 
> mdadm is a tool for creating, managing and monitoring
> device arrays using the "md" driver in Linux, also
> known as Software RAID arrays.
> 
> Release 1.2.0 is a bug-fix release over 1.1.0.
> 
>     -   Fix bug where --daemonise required an argument.
>     -   In --assemble --verbose, print appropriate message if device is
>         not in devices= list
>     -   Updated mdadm.conf.5 to reflect fact that device= takes wildcards
>     -   Typos:  componenet -> component
>     -   Reduce size of "--help" message put excess into "--help-options"
>     -   Fix bug introduced when MD_SB_DISKS dependancy removed, and which
>         caused spares not be assembled properly.
>     -   Print appropriate message if --monitor --scan decides not to
> 	monitor anything.  

Hi,

mdadm's monitoring mode can't (yet?!) keep track of completed
rebuilds, right? An event RebuildFinished/Rebuild100 would be nice.
I guess the only way to do this would be to check every 5-10 seconds
and if there's no rebuild running on devX after the last check (which found
one running on devX), then just assume it's finished. I mean, it's
very unlikely that a complete rebuild would take less than 5-10 seconds ;-)

What about this idea: send a mail on *every* occuring event when -v is
given, or even better being able to specify the events for which to
send mail *and/or* to run a program on the command line or in the config
file, like:
$ mdadm --monitor --scan \
	--mail root@localhost \
	--mail-events Fail,FailSpare,DeviceDisappeared \
	--program /usr/local/sbin/mdadm_event.sh \
	--program-events RebuildStarted,Rebuild40,Rebuild80
# send mail on an "own" list of events, same with program.

$ mdadm --monitor --scan \
	--mail root@localhost \
	--program /usr/local/sbin/mdadm_event.sh \
	--events Fail,FailSpare,DeviceDisappeared,RebuildStarted
# send mail *and* run program on events specified by --events

Also the RebuildNN stages could be a bit smaller, e.g.
Rebuild10, 20, 30,... or what about specifying the percentage as the
3rd argument to the program which is run?! Just some thoughts...

And well, besides that, mdadm is* very* nice :-)
-- 
Wolfram Schlich; Friedhofstr. 8, D-88069 Tettnang; +49-(0)178-SCHLICH
