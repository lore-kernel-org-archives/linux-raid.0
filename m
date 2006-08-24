From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux: Why software RAID?
Date: Wed, 23 Aug 2006 22:25:37 -0700
Message-ID: <44ED3851.7040202@zytor.com>
References: <44ED1E41.40606@garzik.org> <44ED3723.3090308@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44ED3723.3090308@nortel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Friesen <cfriesen@nortel.com>
Cc: Jeff Garzik <jeff@garzik.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, marc@perkel.com
List-Id: linux-raid.ids

Chris Friesen wrote:
> Jeff Garzik wrote:
> 
>> But anyway, to help answer the question of hardware vs. software RAID, 
>> I wrote up a page:
>>
>>     http://linux.yyz.us/why-software-raid.html
> 
> Just curious...with these guys 
> (http://www.bigfootnetworks.com/KillerOverview.aspx) putting linux on a 
> PCI NIC to allow them to bypass Windows' network stack, has anyone ever 
> considered doing "hardware" raid by using an embedded cpu running linux 
> software RAID, with battery-backed memory?
> 
> It would theoretically allow you to remain feature-compatible by 
> downloading new kernels to your RAID card.
> 

Yes.  In fact, I have been told by several RAID chip vendors that their 
customers are *strongly* demanding that their chips be able to run Linux 
  md (and still use whatever hardware offload features.)

So it's happening.

	-hpa
