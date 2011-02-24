From: Joe Landman <joe.landman@gmail.com>
Subject: Re: high throughput storage server?
Date: Thu, 24 Feb 2011 16:07:50 -0500
Message-ID: <4D66C8A6.7030600@gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>	<4D5A7198.7060607@hardwarefreak.com>	<AANLkTinpUmxQ6gMWPfyZsfUKjQZ_rGMETf3=BMu5o4Dj@mail.gmail.com>	<AANLkTikSehaGsna8z4qFH_S2JPSsepiTUV8OEYdQPykm@mail.gmail.com> <AANLkTim3uq8_oq07theLrR8qVc4iRBzJUWmAk99E-=Vm@mail.gmail.com> <4D66C55F.2050003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D66C55F.2050003@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zdenek Kaspar <zkaspar82@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/24/2011 03:53 PM, Zdenek Kaspar wrote:

>> And likewise, what if there are three clients, or four clients, ...,
>> all requesting different but large files simultaneously?
>>
>> How does one calculate the drive's throughput in these cases?  And,
>> clearly, there are two throughputs, one from the clients'
>> perspectives, and one from the drive's perspective.

we us Jens Axboe's fio code to model this.

Best case scenario is you get 1/N of the fixed sized resource that you 
share averaged out over time for N requestors of equal size/priority. 
Reality is often different, in that there are multiple stacks to 
traverse, potential seek time issues as well as network contention 
issues, interrupt and general OS "jitter", etc.  That is, all the 
standard HPC issues you get for compute/analysis nodes, you get for this.

Best advise is "go wide".  As many spindles as possible.  If you are 
read bound (large block streaming IO), then RAID6 is good, and many of 
them joined into a parallel file system (ala GlusterFS, FhGFS, MooseFS, 
OrangeFS, ... ) is even better.  Well, as long as the baseline hardware 
is fast to begin with.  We do not recommend a single drive per server, 
turns out to be a terrible way to aggregate bandwidth in practice.  Its 
better to build really fast units, and go "wide" with them.  Which is, 
curiously, what we do with our siCluster boxen.

MD raid should be fine for you.

Regards,

Joe



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
