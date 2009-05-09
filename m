From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Requesting replace mode for changing a disk
Date: Sat, 09 May 2009 12:41:11 +0100
Message-ID: <4A056BD7.8090506@anonymous.org.uk>
References: <8763gb44xk.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8763gb44xk.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/05/2009 23:15, Goswin von Brederlow wrote:
> Hi,
> 
> consider the following situation: You have a software raid that runs
> fine but one disk is suspect (e.g. SMART says failure imminent or
> something). How do you replace that disk?
> 
> Currently you have do fail/remove the disk from the raid, add a
> fresh disk and resync. That leaves a large window in which redundancy
> is compromised. With current disk sizes that can be days.
> 
> It would be nice if one could tell the kernel to replace a disk in a
> raid set with a spare without the need to degrade the raid.
> 
> Thoughts?

I remember this being discussed a few months ago, and I think it's 
fairly high up Neil Brown's to do/roadmap for the future.

Cheers,

John.

