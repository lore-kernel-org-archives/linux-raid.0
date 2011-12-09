From: Eli Morris <ermorris@ucsc.edu>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Fri, 9 Dec 2011 14:07:13 -0800
Message-ID: <381720EC-8DCA-4862-9C62-22954CC7AA60@ucsc.edu>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu> <4EE263A5.3010107@hardwarefreak.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EE263A5.3010107@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Dec 9, 2011, at 11:38 AM, Stan Hoeppner wrote:

> On 12/7/2011 2:42 PM, Eli Morris wrote:
> 
>> I thought maybe someone could help me out. I have a 16 disk software RAID that we use for backup. This is at least the second time this happened- all at once, four of the drives report as 'removed' when none of them actually were. These drives also disappeared from the 'lsscsi' list until I restarted the disk expansion chassis where they live. 
>> 
>> These are the dreaded Caviar Green drives.
> 
> Eli, you masochist.  ;)
> 
>> 2) Any idea on how to stop this from happening again?
> 
> You already know the answer.  You're simply ignoring/avoiding it.  It
> was given to you by a half dozen imminently qualified people over on the
> XFS list when you had an entire chassis blow out many months ago, losing
> many students' doctoral thesis data IIRC.  I've since used that saga
> many times as evidence against using "green" drives, esp the WD models,
> for anything but casual desktop storage.
> 
> The only permanent fix is to replace the drives with models meant for
> your use case, such as the WD RE4 or Seagate Constellation, to name two.
> Unfortunately, right now, due to the flooding in Thailand, the price of
> all drives across the board has doubled as a result of constricted
> supply.  


> Given you don't have funds in the budget to replace them
> anyway, at any price, it seems you are simply screwed in this regard.

Well, I think you may be on to something here. So I have two choices:

1) Admit defeat and wash my hands of the lack of adequate back ups.

2) Risk my time and ridicule and ask around if there is any way to make these drives work in this configuration. From what I understand of these drives is that they time out RAID units remapping bad blocks, instead of the disks themselves timing out the remapping process and responding to the RAID request and then they get marked as failed. Now, why four drives would do this simultaneously and then when I look at the SMART data, they don't show up as having any bad blocks, I don't have any understanding of. Maybe these drives are spinning down and not responding in a certain time and that is why they showed up as removed? I don't know, maybe there is a way to keep that from happening??

My further understanding is that one can control the timeout in the OS of drives that are in an expansion bay, such as they are now configured in our system. But, look, I'll admit that that I'm no expert in this issue and someone might have a better suggestion or will tell me why that is not the right idea / a bad idea, whatever. And if using these drives is just impossible (which very well might be - YES, I'm getting very sick of trying to find a way to make these work), then so be it. 

I agree with you and everyone else that tells me that these drives shouldn't be used in RAIDs. I will never buy these type of drives again and I will never recommend these drives to anyone else. I'd really like to just chuck these drives off the roof of a building and buy new good quality ones. I'd REALLY like to do that. When more funding is available, I'll be doing just that. 

The melt down that we did have in our lab was due to a pretty unfortunate chain of events where we lost 4 drives in a few days out of 16 in one RAID unit (these four are different drives and have nothing to do with Caviar Green drives), I was on vacation at the time and did not replace the failing drives as fast as they failed, and during this time, the other backup RAID (the one with the Caviar Green drives) failed with four drives also. 

So, that's not so great. As you mention in your last paragraph, the reason why we had Caviar Green drives to begin with is that our RAID vendor recommended them to us specifically for use in the RAID where they failed. I spoke with him after they failed and he insists that these drives were not the problem and that they are used without problem in similar RAIDs. He seems like a good guy, but ultimately, I have no way of knowing what to think of that. He thinks the four drives 'failed' because of a backplane issue, but, since the unit is older and out of warranty, and thus costly, that isn't really worth investigating.


thanks,

Eli

> 
> One thing I would suggest though, if you got the vendor tech's statement
> in writing WRT the WD Green drives being compatible with their RAID
> chassis, I'd lean hard on them to fix the issue, as it was their rec
> that prompted your purchase, causing this problem in the first place, no?
> 
> -- 
> Stan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

