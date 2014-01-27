From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Sun, 26 Jan 2014 20:20:56 -0700
Message-ID: <CEC6B3B4-328D-4CF6-AD69-8169EE43ABBD@colorremedies.com>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org> <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com> <52E2691E.4050701@turmel.org> <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com> <52E29CEF.7030408@turmel.org> <62EB0D79-9A50-4C50-ACBF-1C507D6F449B@colorremedies.com> <52E2AD10.5080208@turmel.org> <E222FBA0-8A1A-48EF-BEAA-BD059A8C1554@colorremedies.com> <52E2C5A3.1050803@turmel.org> <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com> <52E3DCE4.4020909@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E3DCE4.4020909@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 25, 2014, at 8:48 AM, Phil Turmel <philip@turmel.org> wrote:
> 
>> If the spec is "1 URE event in 1E14 bits read" that is "1 bit 
>> nonrecoverable in 2.4E10 bits read" for a 512 byte physical sector 
>> drive, and hilariously becomes far worse at "1 bit nonrecoverable in 
>> 3E9 bits read" for 4096 byte physical sector drives.
> 
> It is only hilariously far worse in *your* mind.

How would you characterize a nearly one order magnitude difference in bit error rate? 

The claim that "you can expect a new URE every 12T or so read, on average" is only congruent with its corollary which is that we should then expect a greater error rate with AF disks, on average. It's simple math because there are two different values for URE loss depending on whether the sector is 4096 bits or 32768 bits. If the URE odds are identical regardless of whether the disk is AF or not, then that means we have greater rates of loss on AF disks.

And we're told that can't be true because the disk manufacturers have said the reason for bigger sectors is to reduce the error rate. A 512 byte sector is smaller on today's higher density media, while defects are approximately the same size, which means conventional sized sectors are at increasing risk of a larger percentage being affected by defect to the point they can't be recovered.

The way to rectify this apparent problem is to reject the claim "you can expect a new URE every 12TB or so read, on average." We don't know the average. We only know the max. It very well could be the average is one URE in every 100TB for AF disks and one URE every 50TB for conventional disks.


Chris Murphy

