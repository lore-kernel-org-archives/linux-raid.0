From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Mon, 27 Jan 2014 08:16:30 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1401270810350.20074@uplift.swm.pp.se>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org>
 <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com> <52E2691E.4050701@turmel.org> <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com> <52E29CEF.7030408@turmel.org> <62EB0D79-9A50-4C50-ACBF-1C507D6F449B@colorremedies.com> <52E2AD10.5080208@turmel.org>
 <E222FBA0-8A1A-48EF-BEAA-BD059A8C1554@colorremedies.com> <52E2C5A3.1050803@turmel.org> <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com> <52E3DCE4.4020909@turmel.org> <52E3F7FE.6000004@hardwarefreak.com>
 <0EDC3349-197C-402E-8940-06AF44A164B6@colorremedies.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0EDC3349-197C-402E-8940-06AF44A164B6@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: stan@hardwarefreak.com, Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 26 Jan 2014, Chris Murphy wrote:

> I accept that. But since there are two sector sizes, one URE does not 
> represent the same amount of data loss.

This is your interpretation of the claim. My interpretation of the data is 
that you will get an URE for every 10^14 bits read. How many data bits 
that are lost by this URE is not important, either you lose 512 bytes or 
4096 bytes. The bit error rate is still calcluated on total amount read, 
regardless of how many bits are when this URE happens.

In data communication (ethernet for instance), we say the bit error rate 
is 10^-12. When you get a bit error, you're going to lose the entire 
packet. The size of the packet doesn't count in the error rate 
calculation. I don't see why HDDs would be different.

The bit error rate is one thing, the consequence of the bit error and how 
much data is lost is another thing. You insist that these are directly 
coupled.

> Fine, but if you accept that the probability of URE is the same between 
> conventional and AF disks, you accept that there are more bits being 
> lost on AF disks than conventional disks. Yet the available data says 
> the opposite is true.

Where exactly in the available data does it say that?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
