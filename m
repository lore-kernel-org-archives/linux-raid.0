From: Nirmal B <nirmalsmi@yahoo.com>
Subject: Re: Fixes for SLES 8.0 s/w RAID --- mkraid, yast2 or md related
Date: Thu, 16 Sep 2004 08:10:21 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040916151021.81563.qmail@web90005.mail.scd.yahoo.com>
References: <20040916132718.GS26852@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040916132718.GS26852@marowsky-bree.de>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello Lars,

Nice to know that you work in the HA and Clustering at
SuSE labs. Let me see if you can help fixing the
"problems" I mentioned in the mail sent earlier to the
group. :-) I was rather busy and/or lazy about giving
details then. Please excuse me. Sorry!

Just some background info now. I am building an HP MC/
ServiceGuard cluster of two servers (ProLiant)
connected to an enterprise virtual array (EVA 3000)
which is used as shared storage. The cluster formation
is fine but I am unable to activate the shared storage
because of issues with software RAID implementation of
SuSE linux Enterprise Server 8.0. This is the OS I use
on both the cluster nodes but the quorum server uses
RedHat AS. The hardware configuration and setups are
fine and the virtual disks created at the EVA are
being recognized by the OS (SLES 8.0). However, there
are issues when it comes to further stages of creation
of package configuration scripts.

Let me classify the issues into 4 here.

1. md driver 
2. yast2
3. physical volumes
4. raidtools related  -- probably mkraid

The partitions are of type 'fd' and the arrays are
started at boot time. But the first entry of the SCSI
disk mentioned in the /etc/raidtab file (for eg. if
/dev/sdb1 and /dev/sdc1 are grouped, then /dev/sdb1)
gets removed from the array. Yast2 doesn't show it up
on the display as well. Only the second entry
(/dev/sdc1) will be forming the part of
RAID/multipath.

The second problem is that even if I stopped the
raid(using raidstop and checking the status in
/proc/mdstat) prior to seeing the display in yast2
about the available partitions/RAID groupings, the
driver seems to be started soon after exiting yast2.
That means, yast2 seems to have a bug such that it
starts the md driver upon entry/exit.

There is no 'pvremove' and so I use dd to get rid of
the persistent RAID superblock when I want to reuse
the partitions. But even then it doesn't seem to work
sometimes and deleting the RAID and disk partitions
from yast2 also do not succeed in effect. It shows
that the disks are removed but the same is displayed
again when I invoke yast2 again.

The array which has been deleted by removing the
superblock using 'dd' on both the component disk
partitions is still being reported by SuSE as active.
It doesn't take the entries in /etc/raidtab then and
ignores the /dev/md[0-9] driver specified there!

Can you or anyone else help me with the right
suggestions/solutions? I need to use SLES 8.0 itself
as I will be testing a software on the cluster with
this OS and hardware setup.

Thanks and Regards,
Nirmal 

--- Lars Marowsky-Bree <lmb@suse.de> wrote:

> On 2004-09-16T04:18:06,
>    Nirmal B <nirmalsmi@yahoo.com> said:
> 
> > With SuSE Linux Enterprise Server 8.0, I have run
> into
> > problems using md driver, mkraid and yast2.
> >  
> > It would be great if anyone can suggest the
> specific
> > patches to update SLES 8.0 for correct
> implementation
> > of Software RAID.
> 
> Please post such questions (hopefully with some more
> data than just
> "problems" ;-) to your SUSE/Novell support account.
> 
> 
> Sincerely,
>     Lars Marowsky-Brée <lmb@suse.de>
> 
> -- 
> High Availability & Clustering
> SUSE Labs, Research and Development
> SUSE LINUX AG - A Novell company
> 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> 



		
__________________________________
Do you Yahoo!?
Read only the mail you want - Yahoo! Mail SpamGuard.
http://promotions.yahoo.com/new_mail 
