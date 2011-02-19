From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Raid selection questions (10 vs 6, n2 vs f2) on an 8 drive array
Date: Fri, 18 Feb 2011 20:12:44 -0500
Message-ID: <4D5F190C.5050202@gmail.com>
References: <AANLkTi=2xjjuvT3tTs1Y9Qfrn6HxWS3hwzF-Q0ZhPFVM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=2xjjuvT3tTs1Y9Qfrn6HxWS3hwzF-Q0ZhPFVM@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larry Schwerzler <larry@schwerzler.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/18/2011 03:55 PM, Larry Schwerzler wrote:

[...]

> Questions:
>
> 1. In my research of raid10 I very seldom hear of drive configurations
> with more drives then 4, are there special considerations with having
> an 8 drive raid10 array? I understand that I'll be loosing 2TB of
> space from my current setup, but i'm not too worried about that.

If you are going to set this up, I'd suggest a few things.

1st: try to use a PCI HBA with enough ports, not the motherboard ports.

2nd: eSATA is probably not a good idea (see your issue below).

3rd: I'd suggest getting 10 drives and using 2 as hot spares.  Again, 
not using eSATA.  Use an internal PCIe card that provides a reasonable 
chip.  If you can't house the drives internal to your machine, get a x4 
or x8 JBOD/RAID cannister.  A single (or possibly 2) SAS cables.  But 
seriously, lose the eSATA setup.

>
> 2. One problem I'm having with my current setup is the esata cables
> have been knocked loose which effectively drops 4 of my drives. I'd
> really like to be able to survive this type of sudden drive loss. if
> my drives are /dev/sd[abcdefgh] and abcd are on one esata channel
> while efgh are on the other is there what drive order should I create
> the array with? I'd guess /dev/sd[aebfcgdh] would that give me
> survivability if one of my esata channels went dark?

Usually the on-board eSATA chips are very low cost, low bandwidth units. 
  Spend another $150-200 on a dual external SAS HBA, and get the JBOD 
container.

>
> 3. One of the concerns I have with raid10 is expandability, and I'm
> glad to see reshaping raid10 as an item on the 2011 roadmap :) However
> it will likely be a while before I'll see that ability in my distro
> for a while. I did find a guide on expanding raid size when using lvm
> by increasing the size of each drive and creating two partitions 1 the
> size of the original drive, and one with the remainder of the new
> space. Once you have done this for all drives you create a new raid10
> array with the 2nd partitions on all the drives and add it to the lvm
> storage group, effectively you have two raid10 arrays 1 on the first
> half of the drives 1 on the 2nd half of the drives and the space
> pooled together. I'm sure many of you are familiar with this scenario,
> but I'm wondering if this scenario could be problematic, is having two
> raid10 arrays on one drive an issue?

We'd recommend against this.  Too much seeking.

>
> 4. Part of the reason I'm wanting to switch is because of information
> I read on the "BAARF" site pointing out some of the issues in the
> parity raid's that can cause issues that people sometimes don't think
> about. (site: http://www.miracleas.com/BAARF/BAARF2.html) A lot of the
> information on the site is a few years old now and given how fast
> things can change and the fact that I have not found many people
> complaining about the parity raids I'm wondering if some/all of the
> gotchas that they list are less of an issue now? Maybe my reasons for
> moving to raid10 are no longer relevant?

Things have gotten worse.  The BERs are improving a bit (most reasonable 
SATA drives report 1E-15 as their rate as compared with 1E-14 as 
previously.  Remember, 2TB = 1.6E13 bits.  So 10x 2TB drives together is 
1.6E14 bits.  8 scans or rebuilds will get you to a statistical near 
certainty of hitting an unrecoverable error.

RAID6 buys you a little more time than RAID5, but you still have worries 
due to the time correlated second drive failure.  Google found a peak at 
1000s after the first drive failure (which likely corresponds to an 
error on rebuild).  With RAID5, that second error is the end of your 
data.  With RAID6, you still have a fighting chance at recovery.


> Thank you in advance for any/all information given. And a big thank
> you to Neil and the other developers of linux-raid for their efforts
> on this great tool.

Despite the occasional protestations to the contrary, MD raid is a 
robust and useful RAID layer, and not a "hobby" layer.  We use it 
extensively, as do many others.


-- 
Joe Landman
landman@scalableinformatics.com
