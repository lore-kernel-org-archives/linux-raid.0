From: Vlad Dobrotescu <vlad@dobrotescu.ca>
Subject: RAID6 questions (mdadm 3.2.6/3.3.x)
Date: Fri, 11 Jul 2014 18:41:25 -0400
Message-ID: <53C06815.2020302@dobrotescu.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

First of all, big thanks to all the people involved in the mdadm project 
- it's a jewel.

I'm getting close to put together my new home server, with 6 drives in a 
RAID6 configuration. I have spent the last few days trying to update my 
knowledge on Linux hdd redundancy (didn't need to touch the subject for 
about 8 years - again, thanks for the quality of your work) and it seems 
I'll have to use the 3.2.6 version of mdadm (coming with the new CentOS 
7). I look forward for the goodies coming in 3.3.x, but I can't wait 
until the RH guys are totally happy with it. I have a few questions that 
I hope someone in this forum can easily shed some light on.

1. If I set up everything with 3.2.6, will 3.3.x be able to "take over" 
seamlessly my array and offer the new features (bad blocks/hot replace)? 
If not, is there anything I could do proactively to ease the move?

2. In the foreseeable future, I will add more drives to the existing 
array (let's say 4 more, thus doubling its storage capacity). My 
understanding is that growing the array to include the new disks will 
keep the existing size - am I correct? In this situation will the chunk 
size stay the same, or will it double (if I don't explicitly specify any 
change)?

I plan to implement some proactive maintenance of the array (regular 
scrubs, smartctl monitoring), and I may get to the point of wanting to 
replace one or more tired (but not yet failed) drives.

3. My understanding is that the hot replace feature of 3.3.x could 
handle this in a very efficient way, by cloning the data from the old 
drive to the new one - am I correct? If yes, then I wonder if multiple 
replacements can be done in parallel (this situation would also occur if 
I want to replace existing disks with bigger ones)?

4. Again, my understanding is that 3.2.6 (mdadm-3.2.6-31.el7 to be 
exact) can't help me in this situation and I have to go through a full 
resync - please correct me if I'm wrong. A comment on Neil's blog 
suggests configuring each drive as a degraded RAID1 and assembling the 
RAID6 on top of those md devices (so that active drive cloning can be 
handled by the RAID1 component). I find this idea quite interesting ... 
but would this approach be subject to any significant performance penalty?

5. In the scenario above, I'm thinking that if the RAID1's are 
configured to use 1.0 metadata and the RAID6 to use 1.2 metadata, once 
mdadm 3.3.x becomes available I could just "re-assemble" the RAID6 using 
the same drives (but without the RAID1 envelope) without any resyncing 
(the data is "healthy" and the superblocks would already be in the 
proper place) ... If I'm not totally off, could someone sketch the 
proper procedure of doing it without loosing the data?

And, finaly, a couple of mdadm/LVM related questions:

6. mdadm on top of LVM2 LGs (not the other way around): would there be 
any issues or performance penalties?

7. I am sure I read somewhere (can't find the source anymore) that the 
"new" RAID features of LVM2 are based on a fork from the md code. If 
this is true, are you guys are contributing to that project as well?

Thanks,

Vlad
