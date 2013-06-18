From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: RAID 5: low sequential write performance?
Date: Mon, 17 Jun 2013 22:32:29 -0700
Message-ID: <51BFF0ED.5060806@fatooh.org>
References: <51BCF46B.40704@fatooh.org> <20926.11718.556180.928129@tree.ty.sabi.co.uk> <51BEAF12.10909@fatooh.org> <51BF1BAC.9020701@hardwarefreak.com> <51BF43E6.4000900@fatooh.org> <alpine.DEB.2.00.1306171942430.4696@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1306171942430.4696@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2013-06-17 10:45, Mikael Abrahamsson wrote:
> On Mon, 17 Jun 2013, Corey Hickey wrote:
> 
>> Is 256 really a reasonable default? Given what I've been seeing, it 
>> appears that 256 is either unreasonably low or I have something else 
>> wrong.
> 
> It's a safe setting for a low memory system. 1 megabyte per drive can 
> probably be handled by most systems.
> 
> It's expected that you know how to tune this yourself, right now. I seem 
> to remember Neil saying something a few years back about it being 
> desireable for the stripe-cache to be auto-tuned depending on size of 
> available RAM, but probably other things was higher priority plus it's not 
> obvious exactly what the settings should be depending on how much RAM you 
> have.

That would seem like a good thing.

Thanks,
Corey
