From: Jason Keltz <jas@cse.yorku.ca>
Subject: Re: question about MD raid rebuild performance degradation even with
 speed_limit_min/speed_limit_max set.
Date: Tue, 28 Oct 2014 22:34:07 -0400
Message-ID: <5450521F.8060309@cse.yorku.ca>
References: <5445332B.9060009@cse.yorku.ca>	<5445361E.3010503@cse.yorku.ca>	<5445799A.8020205@cse.yorku.ca> <20141029093822.79242658@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141029093822.79242658@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/10/2014 6:38 PM, NeilBrown wrote:
> On Mon, 20 Oct 2014 17:07:38 -0400 Jason Keltz<jas@cse.yorku.ca>  wrote:
>
>> On 10/20/2014 12:19 PM, Jason Keltz wrote:
>>> Hi.
>>>
>>> I'm creating a 22 x 2 TB SATA disk MD RAID10 on a new RHEL6 system.
>>> I've experimented with setting "speed_limit_min" and "speed_limit_max"
>>> kernel variables so that I get the best balance of performance during
>>> a RAID rebuild of one of the RAID1 pairs. If, for example, I set
>>> speed_limit_min AND speed_limit_max to 80000 then fail a disk when
>>> there is no other disk activity, then I do get a rebuild rate of
>>> around 80 MB/s. However, if I then start up a write intensive
>>> operation on the MD array (eg. a dd, or a mkfs on an LVM logical
>>> volume that is created on that MD), then, my write operation seems to
>>> get "full power", and my rebuild drops to around 25 MB/s. This means
>>> that the rebuild of my RAID10 disk is going to take a huge amount of
>>> time (>12 hours!!!). When I set speed_limit_min and speed_limit_max to
>>> the same value, am I not guaranteeing the rebuild speed? Is this a bug
>>> that I should be reporting to Red Hat, or a "feature"?
>>>
>>> Thanks in advance for any help that you can provide...
>>>
>>> Jason.
>> I would like to add that I downloaded the latest version of Ubuntu, and
>> am running it on the same server with the same MD.
>> When I set speed_limit_min and speed_limit_max to 80000, I was able to
>> start two large dds on the md array, and the rebuild stuck at around 71
>> MB/s, which is close enough.  This leads me to believe that the problem
>> above is probably a RHEL6 issue.  However, after I stopped the two dd
>> operations,  and raised both speed_limit_min and speed_limit_max to
>> 120000, the rebuild stayed between 71-73 Mb/s for more than 10 minutes
>> .. now it seems to be at 100 MB/s... but doesn't seem to get any higher
>> (even though I had 120 MB/s and above on the RHEL system without any
>> load)... Hmm.
>>
> md certainly cannot "guarantee" any speed - it can only deliver what the
> underlying devices deliver.
> I know the kernels logs say something about a "guarantee".  That was added
> before my time and I haven't had occasion to remove it.
>
> md will normally just try to recover as fast as it can unless that exceeds
> one of the limits - then it will back-off.
> What speed it actually achieved depends on other load and the behaviour of
> the IO scheduler.
>
> "RHEL6" and "Ubuntu" don't mean a lot to me.  Specific kernel version might,
> though in the case of Redhat I know that backport lots of stuff so even the
> kernel version isn't very helpful.  I'm must prefer having report against
> mainline kernels.
>
> Rotating drives do get lower transfer speeds at higher addresses.  That might
> explain the 120 / 100 difference.
Hi Neil,
Thanks very much for your response.
I must say that I'm a little puzzled though. I'm coming from using a 
3Ware hardware RAID controller where I could configure how much of the 
disk bandwidth is to be used for a rebuild versus I/O.   From what I 
understand, you're saying that MD can only use the disk bandwidth 
available to it.  It seems that it doesn't take any priority in the I/O 
chain.  It will only attempt to use no less than min bandwidth, and no 
more than max bandwidth for the rebuild, but if you're on a busy system, 
and other system I/O needs that disk bandwidth, then there's nothing it 
can do about it.  I guess I just don't understand why.  Why can't md be 
given a priority in the kernel to allow the admin to decide how much 
bandwidth goes to system I/O versus rebuild I/O.  Even in a busy system, 
I still want to allocate at least some minimum bandwidth to MD.  In 
fact, in the event of a disk failure, I want to have a whole lot of the 
disk bandwidth dedicated to MD.  It's something about short term pain 
for long term gain? I'd rather not have the users suffer at all, but if 
they do have to suffer, I'd rather them suffer for a few hours, knowing 
that after that, the RAID system is in a perfectly good state with no 
bad disks as opposed to letting a bad disk resync take days because the 
system is really busy... days during which another failure might occur!

Jason.
