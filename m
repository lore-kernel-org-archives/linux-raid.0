From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Sat, 10 Dec 2011 19:15:09 -0600
Message-ID: <4EE4041D.5050103@hardwarefreak.com>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu> <4EE263A5.3010107@hardwarefreak.com> <381720EC-8DCA-4862-9C62-22954CC7AA60@ucsc.edu> <4EE2C400.2000100@hardwarefreak.com> <BC02779D-6A54-41D3-9780-F712996AC8D6@ucsc.edu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BC02779D-6A54-41D3-9780-F712996AC8D6@ucsc.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Morris <ermorris@ucsc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/9/2011 10:57 PM, Eli Morris wrote:
> 
> On Dec 9, 2011, at 6:29 PM, Stan Hoeppner wrote:
> 
>> On 12/9/2011 4:07 PM, Eli Morris wrote:
>>
>>> So, that's not so great. As you mention in your last paragraph, the reason why we had Caviar Green drives to begin with is that our RAID vendor recommended them to us specifically for use in the RAID where they failed. I spoke with him after they failed and he insists that these drives were not the problem and that they are used without problem in similar RAIDs. He seems like a good guy, but ultimately, I have no way of knowing what to think of that. He thinks the four drives 'failed' because of a backplane issue, but, since the unit is older and out of warranty, and thus costly, that isn't really worth investigating.
>>
>> Sure it is, if your data has value.  The style of backplanbe you have,
>> 4x3 IIRC, is cheap.  If one board is flaky, replace it.  They normally
>> run only a couple hundred dollars, assuming your OEM still has some in
>> inventory.
>>
>> If not, and you have $1500 squirreled away somewhere in the budget, grab
>> one of these and move the drives over:
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16816133047
>>
>> Sure, the Norco is definitely a low dollar 24 drive SAS/SATA JBOD unit.
>> But the Areca expander module is built around the LSI SAS 2x36 ASIC,
>> the gold standard SAS expander chip on the market.
>>
>> Do you have any dollars in your yearly budget for hardware
>> maintenance/replacement?
>>
>> -- 
>> Stan
> 
> Hi Stan,
> 
> It's funny you should mention getting a SAS/SATA JBOD unit. When I was told that the RAID unit we had might have a backplane issue, I decided to try put these drives in a JBOD expander module and use a software RAID configuration with the drives, since I have read in a few various places that this gets around the TLER problem with these particular drives and if we did have a backplane or controller problem, doing so would get around that as well. Thus I did buy a JBOD expander and I put the drives in them and here we are today with this latest failure- with the drives in the SAS/SATA JBOD expander using mdadm as the controller. So maybe our thinking isn't too far apart ;<)

That depends.  Which JBOD/expander did you acquire?  Make/model?  There
are a few hundred on the market, of vastly different quality.  Not all
SAS expanders are equal.  Some will never work out of the box with some
HBAs and RAID cards, some will have intermittent problems such as drive
drops, some will just work.  Sticking with the LSI based stuff gives you
the best odds of success.

If a chassis backplane is defective, switching drives to a good chassis
will solve that problem.  However, it won't solve any Green drive
related problems.  BTW, an SAS expander doesn't have anything to do with
TLER, ERC, CCTL, etc, and won't fix such problems.

AFAIK mdraid isn't as picky about read/write timeouts as hardware RAID
controllers are.  Others here are more qualified to speak to how mdraid
handles this than I am.

You didn't mention which SAS HBA you're using with this JBOD setup.  If
it's a Marvell SAS chipset on the HBA that would be a big problem as
well, and would yield similar drive dropout problems.  SuperMicro has a
cheap dual SFF8088 card using this chipset, HighPoint as well.  If
you're using either of those, or anything with a Marvell chip, swap it
out with a recent PCIe LSI ASIC based HBA, such as the LSI 9200-8e:

http://www.lsi.com/products/storagecomponents/Pages/LSISAS9200-8e.aspx

> Now I could replace the backplane of the original RAID (if we can get one for a reasonable price) and put these silly drives back in it and hope the problem goes away, but I'm not convinced that the backplane is the issue. It might be the issue, but I'm not sure I want to bet money on it. I think it is more likely a problem with these drives and some sort of timing out issue related to TLER or a power saving spin down of the drives that mdadm has a problem with. I feel like the most likely fix is something related to that. One other thing, the four drives that originally 'failed' back when they were in the hardware RAID unit (and they weren't dead drives-they just showed up as removed - same as this time), all had quite a few bad blocks, so I sent those back and got replacements. 

Replacing a backplane only helps if you indeed have a defective
backplane.  I'd need to see the internal design of the RAID chassis to
determine if the *simultaneous* dropping of 4 drives is very likely a
backplane issue or not.  If enterprise drives were involved here, I'd
say it's almost a certainty.  The fact these are WD Green drives makes
such determinations far more difficult.

> Since the symptoms were the same in the hardware and software RAIDs and the drives themselves seem to be OK, it leads me back to some sort of timeout issue where they are not responding to a command in a certain amount of time and thus show up as 'removed' - not failed, but 'removed'

Recalling your thread on XFS, drives dropped sequentially over time in
one RAID chassis of the 5 stitched together with an mdadm linear
concat--four did not drop simultaneously.  Then you had drives drop from
your D2D backup array, but again, I don't believe you stated multiple
drives dropping simultaneously.

Define these drives being "OK" in this context.  Surface scanning them
and reading the SMART data can show no errors all day long, but they'll
still often drop out of arrays.  There is no relationship between one
and the other.

TTBOMK, not a single reputable storage vendor integrates WD's Green
drives in their packaged SAS/SATA or FC/iSCSI RAID array chassis.  That
alone is instructive.

> Regarding the hardware RAID, at some point when I have time, I'll put our original much lower capacity disks that shipped with the unit about six years ago in and see if they work OK in the unit with the suspect backplane. In that way, I hope to show if the unit really does have bad hardware or if it was the Caviar Green drives that were causing the problem. 

Very good idea.  Assuming the original drives are still ok.  I'd
thoroughly test each one individually on the bench first.

> We don't have a yearly budget per se. We have about $6000 total for maintenance, hardware, and software for the next 2.5 years to support about $200,000 worth of hardware. Almost as bad as losing data would be something breaking that is needed to run that we then couldn't replace for lack of funds. I'm not sure what happens then. Now the lab is constantly applying for grants. So if one comes in, everything could change and we could have some money again. It's just hard to say if that will happen or not or when.

That's just sad.  Your hardware arrays are out of warranty.  You have 5
of them stitched together with mdraid linear and XFS atop.  Unsuitable
drives and associated problems aside, what's your plan to overcome
complete loss of one of those 5 units due to, say, controller failure?
If you can't buy a replacement controller FRU, you're looking at
purchasing another array with drives, with less than $6K to play with?

I feel for ya.  You're in a pickle.

-- 
Stan
