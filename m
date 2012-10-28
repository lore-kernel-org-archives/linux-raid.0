From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 22:24:12 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1210282222170.28593@uplift.swm.pp.se>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu>
 <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com> <A9ED9351-3430-43B8-AEA8-031B3DE29522@colorremedies.com> <6FAB7F92-66E2-4276-9774-B80DAC92E450@colorremedies.com> <20121029031851.42a5e1e9@natsu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121029031851.42a5e1e9@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Chris Murphy <lists@colorremedies.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 29 Oct 2012, Roman Mamedov wrote:

> I do not think there is a state in modern HDDs that there would be a 
> sector which consistently takes 30-120 seconds to read. Those are either 
> unreadable at all, or readable after a delay -- and then already 
> remapped by the HDD into the reserved zone, so the delay is not there 
> the next time.

I have seen drives with abysimal read speed with constant hiccups when 
reading. When reading your text below I believe you're implying that a 
drive will re-write or re-map a sector that took 5 seconds to read. I wish 
this was true, but from what I've seen that is just not happening. If you 
have evidence that contradicts this, do share.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
