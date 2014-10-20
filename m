From: Jason Keltz <jas@cse.yorku.ca>
Subject: Re: question about MD raid rebuild performance degradation even with
 speed_limit_min/speed_limit_max set.
Date: Mon, 20 Oct 2014 17:07:38 -0400
Message-ID: <5445799A.8020205@cse.yorku.ca>
References: <5445332B.9060009@cse.yorku.ca> <5445361E.3010503@cse.yorku.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5445361E.3010503@cse.yorku.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/20/2014 12:19 PM, Jason Keltz wrote:
> Hi.
>
> I'm creating a 22 x 2 TB SATA disk MD RAID10 on a new RHEL6 system. 
> I've experimented with setting "speed_limit_min" and "speed_limit_max" 
> kernel variables so that I get the best balance of performance during 
> a RAID rebuild of one of the RAID1 pairs. If, for example, I set 
> speed_limit_min AND speed_limit_max to 80000 then fail a disk when 
> there is no other disk activity, then I do get a rebuild rate of 
> around 80 MB/s. However, if I then start up a write intensive 
> operation on the MD array (eg. a dd, or a mkfs on an LVM logical 
> volume that is created on that MD), then, my write operation seems to 
> get "full power", and my rebuild drops to around 25 MB/s. This means 
> that the rebuild of my RAID10 disk is going to take a huge amount of 
> time (>12 hours!!!). When I set speed_limit_min and speed_limit_max to 
> the same value, am I not guaranteeing the rebuild speed? Is this a bug 
> that I should be reporting to Red Hat, or a "feature"?
>
> Thanks in advance for any help that you can provide...
>
> Jason.

I would like to add that I downloaded the latest version of Ubuntu, and 
am running it on the same server with the same MD.
When I set speed_limit_min and speed_limit_max to 80000, I was able to 
start two large dds on the md array, and the rebuild stuck at around 71 
MB/s, which is close enough.  This leads me to believe that the problem 
above is probably a RHEL6 issue.  However, after I stopped the two dd 
operations,  and raised both speed_limit_min and speed_limit_max to 
120000, the rebuild stayed between 71-73 Mb/s for more than 10 minutes 
.. now it seems to be at 100 MB/s... but doesn't seem to get any higher 
(even though I had 120 MB/s and above on the RHEL system without any 
load)... Hmm.

Jason.
