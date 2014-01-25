From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Sat, 25 Jan 2014 11:44:30 -0600
Message-ID: <52E3F7FE.6000004@hardwarefreak.com>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org> <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com> <52E2691E.4050701@turmel.org> <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com> <52E29CEF.7030408@turmel.org> <62EB0D79-9A50-4C50-ACBF-1C507D6F449B@colorremedies.com> <52E2AD10.5080208@turmel.org> <E222FBA0-8A1A-48EF-BEAA-BD059A8C1554@colorremedies.com> <52E2C5A3.1050803@turmel.org> <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com> <52E3DCE4.4020909@turmel.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E3DCE4.4020909@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hadn't paid attention to this thread til now, as the posts kept piling up.

On 1/25/2014 9:48 AM, Phil Turmel wrote:

> On 01/24/2014 03:54 PM, Chris Murphy wrote:
...
>> If the spec is "1 URE event in 1E14 bits read" that is "1 bit 
>> nonrecoverable in 2.4E10 bits read" for a 512 byte physical sector 
>> drive, and hilariously becomes far worse at "1 bit nonrecoverable in 
>> 3E9 bits read" for 4096 byte physical sector drives.

First, there is no distinction between the terms "unrecoverable read
error" and "non recoverable read error".  They are two terms describing
the same event, the former most often used when referring to what occurs
on the host, the latter in drive.  I'll simply call it a hard read error.

Sector size has no bearing on hard read error probability.  The fact
that a whole sector is failed on a single bit hard error is simply an
artifact of one sector being the smallest request size possible from the
host.

You buy a loaf of bread and find mold on one slice of the 512 in the
package.  The store will only exchange the whole loaf, not just one
slice.  The probability that one slice of the 2.5 million sold that day
might have mold doesn't change with the quantity in each package.

The probability is the same.  The only difference is how much you have
to throw away.


-- 
Stan
