From: Vlad Dobrotescu <vlad@dobrotescu.ca>
Subject: Re: RAID6 questions (mdadm 3.2.6/3.3.x)
Date: Fri, 11 Jul 2014 23:20:52 -0400
Message-ID: <53C0A994.1050508@dobrotescu.ca>
References: <53C06815.2020302@dobrotescu.ca> <B953BC37-3769-4D9A-97FF-5EFE7C59EEA4@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B953BC37-3769-4D9A-97FF-5EFE7C59EEA4@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/07/2014 21:09, Chris Murphy wrote:
> On Jul 11, 2014, at 4:41 PM, Vlad Dobrotescu<vlad@dobrotescu.ca>  wrote:
>> 6. mdadm on top of LVM2 LGs (not the other way around): would there be any issues or performance penalties?
> You're not assured what PV the LV's are located on. So those 6 LVs you're using as md members might not be on six physical devices. One drive dies, you can lose the whole array. You're better off using LVM raid, or doing things conventionally by first creating the md raid set and then making the md logical device a PV.
Thanks for the advice, it makes a lot of sense. However, this question 
wasn't focused on the RAID6 itself, but related to some fancy (crazy?) 
mirroring scheme for the Linux partition I was considering: take a LV 
chunk from the VG that sits on the RAID6 and mirror (md RAID1) it with a 
partition from the SSD I'll be using for keeping the ext4 journal for 
the big data partition. In this way I can have a functional OS even if I 
take all the RAID6 disks offline. Of course, this can be achieved in 
other ways as well.

Anyhow, do you have any estimation of the speed penalty when overlaying 
such layers (md-md, md-lvm, ...)?

Vlad
