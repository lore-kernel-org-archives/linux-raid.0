From: Jonathan Tripathy <jonnyt@abpni.co.uk>
Subject: Re: Resync Every Sunday
Date: Sun, 01 Jul 2012 13:53:22 +0100
Message-ID: <4FF04842.9080806@abpni.co.uk>
References: <4FF0328B.5080103@abpni.co.uk> <4FF03CD9.9040409@abpni.co.uk> <alpine.DEB.2.00.1207011412270.27169@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1207011412270.27169@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 01/07/2012 13:44, Mikael Abrahamsson wrote:
> On Sun, 1 Jul 2012, Jonathan Tripathy wrote:
>
>> - Is it safe to disable these checks? Would monitoring the SMART 
>> status of the disks serve as a good substitute?
>
> Well, that's a decision you will have to make for yourself. The 
> rationale behind it is to find latent read errors and correct them 
> while you have parity already. Another term for this is "data 
> scrubbing", you'll find quite a lot of discussion on that topic.
>
> Personally, my view is that I make sure all my data are read at least 
> once a month, I have experienced data loss historically because of 
> lack of scrubbing.
>
Thanks, I think I'll change it to monthly as well. That seems like a 
good compromise.

I'm still very interested in the other questions though. Especially the 
one relating to why not all arrays are checked

Thanks
