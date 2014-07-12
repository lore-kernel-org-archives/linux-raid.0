From: Vlad Dobrotescu <vlad@dobrotescu.ca>
Subject: Re: RAID6 questions (mdadm 3.2.6/3.3.x)
Date: Sat, 12 Jul 2014 13:30:44 +0000 (UTC)
Message-ID: <loom.20140712T145923-203@post.gmane.org>
References: <53C06815.2020302@dobrotescu.ca> <B953BC37-3769-4D9A-97FF-5EFE7C59EEA4@colorremedies.com> <53C0A994.1050508@dobrotescu.ca> <D7AA36E1-683F-4E39-87C1-8089EA968E30@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Murphy <lists <at> colorremedies.com> writes:
>>>> 6. mdadm on top of LVM2 LGs (not the other way around): 
>>>> would there be any issues or performance penalties?
>>>
>>> You're not assured what PV the LV's are located on. 
>>> ...
>>
>> Thanks for the advice, it makes a lot of sense. However, 
>> this question wasn't focused on the RAID6 itself, but 
>> related to some fancy (crazy?) mirroring scheme for the 
>> Linux partition I was considering: take a LV chunk from 
>> the VG that sits on the RAID6 and mirror (md RAID1) it 
>> with a partition from the SSD I'll be using for keeping 
>> the ext4 journal for the big data partition.
> 
> Sounds a bit nutty, no offense. It's complicated, non-standard, 
> and therefore at high risk of user induced data loss.
> 
> It's basically raid61, which tells me you want the data 
> always for sure always available. Because raid61 is about 
> uptime. The problem is, you're not going to get that because 
> you've overbuilt the storage stack and haven't considered 
> (or mentioned) other fail points like the network, the power 
> supply, power itself. So it just sounds wrongly overbuilt 
> because the data can't possibly require this kind of uptime, 
> chances are you're confusing raid with back ups. If the data 
> is both important and it really needs to be available, build 
> yourself a gluster cluster.
> 
>> In this way I can have a functional OS even if I take all 
>> the RAID6 disks offline. Of course, this can be achieved 
>> in other ways as well.
> 
> Well if everything you care about on this raid6 fits on an 
> SSD partition, why don't you just set up an hourly rsync to 
> the raid6 and use the SSD volume for live work? And then if 
> you accidentally delete a file or crash when writing to the 
> SSD chances are the states of the raid6 LV and the SSD volume 
> are different and one is recoverable. If you raid1 them, any 
> accidents affect both and you're hosed.

Thanks a lot for the advice, Chris. That's exactly what I hoped
for when posting to this list. As I mentioned, I am considering
a number what-if scenarios and possible solutions (I added the 
rsync one to that list) and weighting pros and cons. For this 
RAID61 approach, which seemed to make some logical sense, I had 
the feeling it's a bit fishy, but didn't have any real arguments 
against it. Now I have.

Since it seems you have a very healthy view of real-world RAID,
could you point out any significant issues when using a disk as
a degraded md RAID1 (not accidental, but on purpose)?

Vlad

