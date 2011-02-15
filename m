From: David Brown <david@westcontrol.com>
Subject: Re: high throughput storage server?
Date: Tue, 15 Feb 2011 14:39:14 +0100
Message-ID: <ijdvmn$4ff$1@dough.gmane.org>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <4D5A7198.7060607@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5A7198.7060607@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/02/2011 13:29, Stan Hoeppner wrote:
> Matt Garman put forth on 2/14/2011 5:59 PM:
>
>> The requirement is basically this: around 40 to 50 compute machines
>> act as basically an ad-hoc scientific compute/simulation/analysis
>> cluster.  These machines all need access to a shared 20 TB pool of
>> storage.  Each compute machine has a gigabit network connection, and
>> it's possible that nearly every machine could simultaneously try to
>> access a large (100 to 1000 MB) file in the storage pool.  In other
>> words, a 20 TB file store with bandwidth upwards of 50 Gbps.
>
> If your description of the requirement is accurate, then what you need is a
> _reliable_ high performance NFS server backed by many large/fast spindles.
>
>> I was wondering if anyone on the list has built something similar to
>> this using off-the-shelf hardware (and Linux of course)?
>
> My thoughtful, considered, recommendation would be to stay away from a DIY build
> for the requirement you describe, and stay away from mdraid as well, but not
> because mdraid isn't up to the task.  I get the feeling you don't fully grasp
> some of the consequences of a less than expert level mdraid admin being
> responsible for such a system after it's in production.  If multiple drives are
> kicked off line simultaneously (posts of such seem to occur multiple times/week
> here), downing the array, are you capable of bringing it back online intact,
> successfully, without outside assistance, in a short period of time?  If you
> lose the entire array due to a typo'd mdadm parm, then what?
>

This brings up an important point - no matter what sort of system you 
get (home made, mdadm raid, or whatever) you will want to do some tests 
and drills at replacing failed drives.  Also make sure everything is 
well documented, and well labelled.  When mdadm sends you an email 
telling you drive sdx has failed, you want to be /very/ sure you know 
which drive is sdx before you take it out!



You also want to consider your raid setup carefully.  RAID 10 has been 
mentioned here several times - it is often a good choice, but not 
necessarily.  RAID 10 gives you fast recovery, and can at best survive a 
loss of half your disks - but at worst a loss of two disks will bring 
down the whole set.  It is also very inefficient in space.  If you use 
SSDs, it may not be worth double the price to have RAID 10.  If you use 
hard disks, it may not be sufficient safety.

I haven't build a raid of anything like this size, so my comments here 
are only based on my imperfect understanding of the theory - I'm 
learning too.

RAID 10 has the advantage of good speed at reading (close to RAID 0 
speeds), at the cost of poorer write speed and poor space efficiency. 
RAID 5 and RAID 6 are space efficient, and fast for most purposes, but 
slow for rebuilds and slow for small writes.

You are not much bothered about write performance, and most of your 
writes are large anyway.

How about building the array as a two-tier RAID 6+5 setup?  Take 7 x 1TB 
disks as a RAID 6 for 5 TB space.  Five sets of these as RAID 5 gives 
you your 20 TB in 35 drives.  This will survive any four failed disks, 
or more depending on the combinations.  If you are careful how it is 
arranged, it will also survive a failing controller card.

If a disk fails, you could remove that whole set from the outer array 
(which should have a write intent bitmap) - then the rebuild will go at 
maximal speed, while the outer array's speed will not be so badly 
affected.  Once the rebuild is complete, put it back in the outer array. 
  Since you are not doing many writes, it will not take long to catch up.

It is probably worth having a small array of SSDs (RAID1 or RAID10) to 
hold the write intent bitmap, the journal for your main file system, and 
of course your OS.  Maybe one of these absurdly fast PCI Express flash 
disks would be a good choice.



