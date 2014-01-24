From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Fri, 24 Jan 2014 10:59:09 -0700
Message-ID: <62EB0D79-9A50-4C50-ACBF-1C507D6F449B@colorremedies.com>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org> <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com> <52E2691E.4050701@turmel.org> <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com> <52E29CEF.7030408@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E29CEF.7030408@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 24, 2014, at 10:03 AM, Phil Turmel <philip@turmel.org> wrote:
>> w many bits of loss occur with one URE?
> 
> Complete physical sector.


A complete physical sector represents 512 bytes / 4096 bits, or in the case of AF disks 4096 bytes / 32768 bits, of loss for one URE. Correct?

So a URE is either 4096 bits nonrecoverable, or 32768 bits nonrecoverable, for HDDs. Correct?


>>> Your comments suggest you've completely discounted the fact that
>>> published URE rates are now close to, or within, drive capacities.
>>> 
>>> Spend some time with the math and you will be very concerned.
>> 
>> Yeah I tried that a year ago and when it came to really super basic questions, no one was willing to answer them and the thread died as if we don't actually know what we're talking about. So I think some rather basic definitions are in order and an agreement that we don't get to redefine mathematics by saying a max error rate is a mean.
>> 
>> http://www.spinics.net/lists/raid/msg41669.html
> 
> I participated in that thread.  Some of your comments there imply that
> the math is simple.  It's not (unless you are whiz with statistics).
> Look at the Poisson distribution I referenced and the computation
> examples I gave.

At the moment a Poisson distribution is out of scope because my questions have nothing to do with how often, when, or how many, such URE's will occur. At the moment I only want complete utter clarity on what a URE/nonrecoverable error (not even the rate) is in terms of quantity. That's my main problem.


> 
> Note that a statement about the rate of a randomly occurring error is
> implicitly stating an average.  

Except that it has only one limiter, with the next notch a whole order magnitude less error. So I don't see how you get an average unless you're willing to just make assumptions about the bottom end. It doesn't make sense that a manufacturer would state a maximum error rate of X and then target that as an average. The average is certainly well below the max. 



Chris Murphy

