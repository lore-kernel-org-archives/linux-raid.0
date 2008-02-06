From: "Steve Fairbairn" <steve@fairbairn-family.com>
Subject: FW: Disk failure during grow, what is the current state.
Date: Wed, 6 Feb 2008 15:04:01 -0000
Message-ID: <047a01c868d1$821f92e0$0603a8c0@meanmachine>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I'm having a nightmare with emails today.  I can't get a single one
right first time.  Apologies to Alex for sending it directly to him and
not to the list on first attempt.

Steve

> -----Original Message-----
> From: Steve Fairbairn [mailto:steve@fairbairn-family.com] 
> Sent: 06 February 2008 15:02
> To: 'Nagilum'
> Subject: RE: Disk failure during grow, what is the current state.
> 
> 
> 
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org
> > [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Nagilum
> > Sent: 06 February 2008 14:34
> > To: Steve Fairbairn
> > Cc: linux-raid@vger.kernel.org
> > Subject: Re: Disk failure during grow, what is the current state.
> > 
> > 
> > 
> > If a drive failes during reshape the reshape will just
> > continue. The blocks which were on the failed drive are 
> > calculated from the the  
> > other disks and writes to the failed disk are simply omitted. 
> > The result is a raid5 with a failed drive. You should get a 
> > new drive asap to restore the redundancy. Also it's kinda 
> > important that you don't run 2.6.23 because it has a  
> > nasty bug which would be triggered in this scenario.
> > The reshape probably increased in speed after the system was 
> > no longer  
> > actively used and io bandwidth freed up.
> > Kind regards,
> > Alex.
> > 
> 
> Thanks for the response Alex, but....
> 
>      Array Size : 1953535744 (1863.04 GiB 2000.42 GB)
>   Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
> 
> Surely the added disk should now been added to the Array 
> Size?  5 * 500GB is 2500GB, not 2000GB.  This is why I don't 
> think the reshape has continued.  As for speeding up because 
> of no IO badwidth, this also doesn't actually hold very true, 
> because the system was at a point of not being used anyway 
> before I added the disk, and I didn't unmount the drive until 
> this morning after it claimed it had finished doing anything.
> 
> It's because the size doesn't match up to all 5 disks being 
> used that I still wonder at the state of the array.
> 
> Steve.
> 
> 
> 
> 
> No virus found in this outgoing message.
> Checked by AVG Free Edition. 
> Version: 7.5.516 / Virus Database: 269.19.20/1261 - Release 
> Date: 05/02/2008 20:57
>  
> 

No virus found in this outgoing message.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.19.20/1261 - Release Date:
05/02/2008 20:57
 

