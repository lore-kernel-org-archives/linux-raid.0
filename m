From: Neil Brown <neilb@suse.de>
Subject: Re: Mdadm problem?
Date: Thu, 3 Aug 2006 16:34:38 +1000
Message-ID: <17617.39166.611073.638119@cse.unsw.edu.au>
References: <Pine.WNT.4.63.0608020900120.532@ender>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from A.J.Dawson on Wednesday August 2
Sender: linux-raid-owner@vger.kernel.org
To: "A.J.Dawson" <A.J.Dawson@Bradford.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 2, A.J.Dawson@Bradford.ac.uk wrote:
> Hi,
> 
> I seem to be having a problem with mdadm running on Gentoo.  I recently 
> upgraded from 1.12 to 2.5-r1 and then to 2.5.2, with both of the latter 
> exhibiting the same behaviour on the machine in question.
> 
> The machine is running a RAID1 array and seemed quite happy running mdadm 
> 1.12.  Running mdadm 2.5.2 however, approximately two days after it is 
> booted, a significant amount of disk activity starts.  Unfortunately the 
> activity always seems to start overnight while I am not in the office and 
> so I've no idea whether it is a sudden start at the high activity level, 
> or whether it builds from a low start.  I can hear the disks being 
> accessed and the machine's response becomes sluggish.  If I look at the 
> activity of the machine using top, mdadm sits at the top of the activity 
> table with a low CPU consumption, but high memory consumption (%mem > 
> 94%).  Note that I also have mdadm --follow --scan & echo $! > 
> /var/run/mdadm in my local.start file.

Very odd.  There was a memory leak in 2.5 but that was fixed in 2.5.1
and so should still be fixed in 2.5.2.

Could you try running
 
   ltrace -o /tmp/ltrace -p `cat /var/run/mdadm`

for a while (maybe 5 minutes), then interrupt it and send me
/tmp/ltrace.

That might give some hints as wto what is happening.

Thanks,
NeilBrown
