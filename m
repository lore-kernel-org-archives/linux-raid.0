From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: Spare disk could not sleep / standby
Date: Tue, 08 Mar 2005 09:59:48 -0600
Message-ID: <422DCBF4.9060306@us.ibm.com>
References: <422D327D.11718.F8DB3@localhost>	<200503080414.j284EG510309@www.watkins-home.com> <16941.11443.107607.735855@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <16941.11443.107607.735855@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Monday March 7, bugzilla@watkins-home.com wrote:
>  
>
>>I have no idea, but...
>>
>>Is the disk IO reads or writes.  If writes, scary!!!!  Maybe data destined
>>for the array goes to the spare sometimes.  I hope not.  I feel safe with my
>>2.4 kernel.  :)
>>    
>>
>
>It is writes, but don't be scared.  It is just super-block updates.
>
>In 2.6, the superblock is marked 'clean' whenever there is a period of
>about 20ms of no write activity.  This increases the chance on a
>resync won't be needed after a crash.
>(unfortunately) the superblocks on the spares need to be updated too.
>
>The only way around this that I can think of is to have the spares
>attached to some other array, and have mdadm monitoring the situation
>and using the SpareGroup functionality to move the spare to where it
>is needed when it is needed.
>This would really require having and array with spare drives but no
>data drives... maybe a 1-drive raid1 with a loopback device as the
>main drive, and all the spares attached to that..... there must be a
>better way, or atleast some sensible support in mdadm to make it not
>too horrible.  I'll think about it.
>
>  
>
While updating superblocks, faulty disks are skipped.  Maybe skipping 
superblock update on spares could be considered.  Of course, this 
requires conresponding changes in md superblock validation code.

In addition, I would suggest to treat spares as shared global disks.   
That is a spare can be referenced by more than 1 md array.  After a 
spare is selected to recover a degraded array, it will be removed from 
the shared list.  I know that this suggestion is away from the 
SpareGroup functionality used by mdadm.  But I am afraid that there is 
timing issue with monitoring /proc/mdstat.

--
Regards,
Mike T.

