From: Joe Landman <joe.landman@gmail.com>
Subject: Re: single cpu thread performance limit?
Date: Thu, 11 Aug 2011 15:57:01 -0400
Message-ID: <4E44340D.7060402@gmail.com>
References: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>	<4E44265D.3050809@hardwarefreak.com> <CAACGR8to9iybX+fJ_CGYBFgR6XtgPoqCt8kFA4mpqo4d1jEMqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAACGR8to9iybX+fJ_CGYBFgR6XtgPoqCt8kFA4mpqo4d1jEMqw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/11/2011 03:37 PM, mark delfman wrote:

> So, a single RAID10 creates a single thread - which will max at maybe 200K IOPS.

We are seeing ~110k IOPs per PCI HBA for an SSD variant of what you 
have.  FWIW, MD RAID is significantly faster than the hardware RAID 
here, but that's due to the processor more than anything else.

Which cards if you don't mind my asking?  We work with a number of 
vendors in this space.

> Create 4 x RAID10's seems OK, but they will not scale so great with a
> RAID0 on top :(
> Ideal would be a few threads per RAIDx

[...]

> Whilst a R0 on top of the R1/10's does offer some increase in
> performance, linear does not :(

Linear makes no sense for distributing IO's among many devices.  Linear 
is a concatenation.

> LVM R0 on top of the MD R1/10's does much the same results.
> The limiter seems fixes on the single thread per R1/10

Whats your CPU?  What's your 'lspci -vvv' output look like (is it 
possible you've oversubscribed your PCIe channels?)  How many PCIe lanes 
do you have on your MB?

FWIW, our array of SSD's hit 7.8 GB/s and 330k IOPs (8k random reads 
against 768GB of data) using MD RAID5's.  Each RAID5 hits around 75k 
IOPs, and when joined together, they hit closer to 110k per HBA.

The PCIe units are generally much better than this.  Last set of cards 
we played with a few weeks ago we were getting about 400k IOPs for a 
pair of cards in an MD RAID0.  I expect newer drivers and other things 
to help out a bit.


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
