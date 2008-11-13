From: Ilya Yanok <yanok@emcraft.com>
Subject: Re: [PATCH 11/11] ppc440spe-adma: ADMA driver for PPC440SP(e)	systems
Date: Thu, 13 Nov 2008 20:50:43 +0300
Message-ID: <491C68F3.3030102@emcraft.com>
References: <1226589364-5619-1-git-send-email-yanok@emcraft.com> <1226589364-5619-12-git-send-email-yanok@emcraft.com> <20081113160307.GB2299@yoda.jdub.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081113160307.GB2299@yoda.jdub.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de
List-Id: linux-raid.ids

Josh Boyer wrote:
> On Thu, Nov 13, 2008 at 06:16:04PM +0300, Ilya Yanok wrote:
>   
>> Adds the platform device definitions and the architecture specific support
>> routines for the ppc440spe adma driver.
>>
>> Any board equipped with PPC440SP(e) controller may utilize this driver.
>>
>> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>> Signed-off-by: Ilya Yanok <yanok@emcraft.com>
>>     
>
> Before I really dig into reviewing this driver, I'm going to ask you as simple
> question.  This looks like a 1/2 completed port of an arch/ppc driver that uses
> the device tree (incorrectly) to get the interrupt resources and that's about it.
> Otherwise, it's just a straight up platform device driver.  Is that correct?
>   

Yep, that's correct.

> If that is the case, I think the driver needs more work before it can be merged.
> It should get the DCR and MMIO resources from the device tree as well.  It should
> be binding on compatible properties and not based on device tree paths.  And it
> should probably be an of_platform device driver.
>   

Surely, you're right. I agree with you in that this driver isn't ready
for merging. But it works so we'd like to publish it so interested
people could use it and test it.

Regards, Ilya.

