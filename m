From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Spare disk could not sleep / standby
Date: Tue, 8 Mar 2005 15:40:19 +1100
Message-ID: <16941.11443.107607.735855@cse.unsw.edu.au>
References: <422D327D.11718.F8DB3@localhost>
	<200503080414.j284EG510309@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Guy on Monday March 7
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Peter Evertz' <leo2@pec.homeip.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 7, bugzilla@watkins-home.com wrote:
> I have no idea, but...
> 
> Is the disk IO reads or writes.  If writes, scary!!!!  Maybe data destined
> for the array goes to the spare sometimes.  I hope not.  I feel safe with my
> 2.4 kernel.  :)

It is writes, but don't be scared.  It is just super-block updates.

In 2.6, the superblock is marked 'clean' whenever there is a period of
about 20ms of no write activity.  This increases the chance on a
resync won't be needed after a crash.
(unfortunately) the superblocks on the spares need to be updated too.

The only way around this that I can think of is to have the spares
attached to some other array, and have mdadm monitoring the situation
and using the SpareGroup functionality to move the spare to where it
is needed when it is needed.
This would really require having and array with spare drives but no
data drives... maybe a 1-drive raid1 with a loopback device as the
main drive, and all the spares attached to that..... there must be a
better way, or atleast some sensible support in mdadm to make it not
too horrible.  I'll think about it.

NeilBrown

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Peter Evertz
> Sent: Monday, March 07, 2005 11:05 PM
> To: linux-raid@vger.kernel.org
> Subject: Spare disk could not sleep / standby
> 
> I have 2 Raid5 arrays on a hpt375. Each has a (unused) spare disk. 
> With change from 2.4 to 2.6 I can not put the spare disk to sleep or  
> 
> standby. 
> It wakes up after some seconds. 
> /proc/diskstat shows activities every 2 to 5 seconds. 
> It is a problem of the plain kernel driver ( not application ) 
> because 
> if i raidhotremove the drives it can sleep/standby and no activities 
> are 
> shown in /proc/diskstats. 
> If the whole Array is unmounted, there are no activities an all 
> drives. 
> It seems that access to md always causes an access at the spare disk 
> ?! 
> 
> Any hints ? Anyone with the same problem ? 
