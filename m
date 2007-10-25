From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Thu, 25 Oct 2007 09:13:10 -0700
Message-ID: <4720C096.9010301@amfes.com>
References: <46D3147D.2040201@amfes.com>	<46D49F1A.7030409@tmr.com>	<46E4A39C.8040509@amfes.com>	<46E4A5F0.9090407@sauce.co.nz>	<46E4A7C3.1040902@amfes.com>	<471F5542.3020504@amfes.com> <18208.13247.106651.142652@notabene.brown> <4720AC60.2040506@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4720AC60.2040506@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> You don't think the "unknown partition table" on sdd is related? 
> Because I read that as a sure indication that the system isn't 
> considering the drive as one without a partition table, and therefore 
> isn't looking for the superblock on the whole device. And as Doug 
> pointed out, once you decide that there is a partition table lots of 
> things might try to use it.  
Now, would the drive "letters" (sd[a-d]) change from reboot-to-reboot?  
Because it's not consistent - so far I've seen each of the four drives 
at one time or another fail during the boot.

I've added the verbose logging to the udev mdadm rule, and I've also 
manually specified the drives in mdadm.conf instead of leaving it on 
auto.  Curious what the next boot will bring.

-- 
Daniel
