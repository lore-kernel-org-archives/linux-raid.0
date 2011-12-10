From: Eli Morris <ermorris@ucsc.edu>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Fri, 9 Dec 2011 20:57:04 -0800
Message-ID: <BC02779D-6A54-41D3-9780-F712996AC8D6@ucsc.edu>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu> <4EE263A5.3010107@hardwarefreak.com> <381720EC-8DCA-4862-9C62-22954CC7AA60@ucsc.edu> <4EE2C400.2000100@hardwarefreak.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EE2C400.2000100@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Dec 9, 2011, at 6:29 PM, Stan Hoeppner wrote:

> On 12/9/2011 4:07 PM, Eli Morris wrote:
> 
>> So, that's not so great. As you mention in your last paragraph, the reason why we had Caviar Green drives to begin with is that our RAID vendor recommended them to us specifically for use in the RAID where they failed. I spoke with him after they failed and he insists that these drives were not the problem and that they are used without problem in similar RAIDs. He seems like a good guy, but ultimately, I have no way of knowing what to think of that. He thinks the four drives 'failed' because of a backplane issue, but, since the unit is older and out of warranty, and thus costly, that isn't really worth investigating.
> 
> Sure it is, if your data has value.  The style of backplanbe you have,
> 4x3 IIRC, is cheap.  If one board is flaky, replace it.  They normally
> run only a couple hundred dollars, assuming your OEM still has some in
> inventory.
> 
> If not, and you have $1500 squirreled away somewhere in the budget, grab
> one of these and move the drives over:
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816133047
> 
> Sure, the Norco is definitely a low dollar 24 drive SAS/SATA JBOD unit.
> But the Areca expander module is built around the LSI SAS 2x36 ASIC,
> the gold standard SAS expander chip on the market.
> 
> Do you have any dollars in your yearly budget for hardware
> maintenance/replacement?
> 
> -- 
> Stan

Hi Stan,

It's funny you should mention getting a SAS/SATA JBOD unit. When I was told that the RAID unit we had might have a backplane issue, I decided to try put these drives in a JBOD expander module and use a software RAID configuration with the drives, since I have read in a few various places that this gets around the TLER problem with these particular drives and if we did have a backplane or controller problem, doing so would get around that as well. Thus I did buy a JBOD expander and I put the drives in them and here we are today with this latest failure- with the drives in the SAS/SATA JBOD expander using mdadm as the controller. So maybe our thinking isn't too far apart ;<)

Now I could replace the backplane of the original RAID (if we can get one for a reasonable price) and put these silly drives back in it and hope the problem goes away, but I'm not convinced that the backplane is the issue. It might be the issue, but I'm not sure I want to bet money on it. I think it is more likely a problem with these drives and some sort of timing out issue related to TLER or a power saving spin down of the drives that mdadm has a problem with. I feel like the most likely fix is something related to that. One other thing, the four drives that originally 'failed' back when they were in the hardware RAID unit (and they weren't dead drives-they just showed up as removed - same as this time), all had quite a few bad blocks, so I sent those back and got replacements. 

Since the symptoms were the same in the hardware and software RAIDs and the drives themselves seem to be OK, it leads me back to some sort of timeout issue where they are not responding to a command in a certain amount of time and thus show up as 'removed' - not failed, but 'removed'

Regarding the hardware RAID, at some point when I have time, I'll put our original much lower capacity disks that shipped with the unit about six years ago in and see if they work OK in the unit with the suspect backplane. In that way, I hope to show if the unit really does have bad hardware or if it was the Caviar Green drives that were causing the problem. 

We don't have a yearly budget per se. We have about $6000 total for maintenance, hardware, and software for the next 2.5 years to support about $200,000 worth of hardware. Almost as bad as losing data would be something breaking that is needed to run that we then couldn't replace for lack of funds. I'm not sure what happens then. Now the lab is constantly applying for grants. So if one comes in, everything could change and we could have some money again. It's just hard to say if that will happen or not or when.

thanks,

Eli


