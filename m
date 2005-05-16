From: Harry Mangalam <hjm@tacgi.com>
Subject: problems with 3ware 8506-8 post-disk failure
Date: Mon, 16 May 2005 15:19:06 -0700
Message-ID: <200505161519.06783.hjm@tacgi.com>
References: <1116020307.6557.34.camel@langvan2.homenetwork> <17029.13146.794856.708018@cse.unsw.edu.au> <1116257122.15450.6.camel@langvan2.homenetwork>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1116257122.15450.6.camel@langvan2.homenetwork>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Scenario:
dual opteron/4G/Ubuntu pure 64bit SMP / OS on separate IDE drive, 3ware 
8506-8port driving 8x WD2500JD disks in Chenbro hotswap cages as RAID5, 
config'ed as both reiserfs (pre-catastrophe) and ext3 (postcatastrophe).
I'm responsible for getting this system up (done) and reliable (not done).

The short version is that it ran well for a few weeks until we discovered on a 
reboot that a disk had silently failed, degrading the RAID5.  In trying to 
repair that failure, 3ware's 3dm2 software that indicated that it was 
repairing the array, but failed to do so, causing the loss of the entire 
array.   I tried to rescue the data with reiserfs's fsck but was only able to 
recover individual chunks.  Since most of the info was huge binary files and 
most of it was backed up elsewhere, we decided not to attempt to rescue 
anything and we re-formatted with ext3, supposedly bc it was considered more 
reliable and better suited for large files.  After that, the raid stayed up 
for a day or so and I loaded it down with huge disk i/o, trying to see what 
would happen.  The same port / disk # failed again (tho at least this time 
the SW notified us), but this seems pretty suspicious that it's the same port 
number failing.

I played around with the motherboard Silicon Image 4port SATA controller and 
sw raid (via mdadm) for a while and found that after a certain amount of 
futzing, it looked not too bad, but the amount of futzing made me a bit 
nervous, especially since someone else is going to have to care for it.  The 
speed of the SW RAID was about 10-20% better than the 3ware by bonnie++, but 
I liked the idea on having the RAID looks like big scsi disk.  So I went for 
the 3ware.

I'll detail the complete catastrophe later (already written up in large chunks 
- just have to remove some inflammatory language before posting), but my 
question to the group is what people think of 3ware's support.  The common 
opinion on 3ware seems to be that it's great that they support Linux and the 
HW works fine (also my experience), but my opinion has been shaded 
considerably by what happens when a RAID fails - when you really DO need to 
recover and you need a straightforward path to do so.


In short, I've found 3ware support for recovery procedures to be hard to find 
(via google for example and also on their website), hard to understand 
because of some peculiar nomenclature, and sometimes misleading due to 
oddities of their software.

Is this just my experience, or is this a widely held view?  I realize that I'm 
talking to a group that seems to be heavily weighted towards SW RAID, but 
maybe it's just me.  If anyone can compare recovery paths between the 2 (SW 
vs 3ware HW) I'd be very happy to hear the stories.  Given this recent 
experience, I'm re-evaluating whether I should switch back and go SW RAID, 
especially given another large catastrophe involving 3ware ccontrollers on 
campus.

Have people found that the Chenbro hotswap cages are a contributing factor to 
RAID failure?  That's what one 3wware person indicated.
-- 
Cheers, Harry
Harry J Mangalam - 949 856 2847 (vox; email for fax) - hjm@tacgi.com 
            <<plain text preferred>>
