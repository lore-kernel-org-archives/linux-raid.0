From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Sat, 25 Jan 2014 17:56:25 +0000
Message-ID: <BLU0-SMTP4400FFDF95DEEA4CD16A36198A00@phx.gbl>
References: <20140121171943.GC6553@blisses.org>
	 <52DFA01E.8000301@hesbynett.no>
	 <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com>
	 <52E0D060.3020508@hesbynett.no>
	 <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com>
	 <52E16536.2070608@turmel.org>
	 <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com>
	 <52E2691E.4050701@turmel.org>
	 <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com>
	 <52E29CEF.7030408@turmel.org>
	 <62EB0D79-9A50-4C50-ACBF-1C507D6F449B@colorremedies.com>
	 <52E2AD10.5080208@turmel.org>
	 <E222FBA0-8A1A-48EF-BEAA-BD059A8C1554@colorremedies.com>
	 <52E2C5A3.1050803@turmel.org>
	 <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 2014-01-24 at 13:54 -0700, Chris Murphy wrote:
> On Jan 24, 2014, at 12:57 PM, Phil Turmel <philip@turmel.org> wrote:
> 
> Please define "bits lost event" and cite some reference. Google returns exactly ONE hit on that, which is this thread. If we cannot agree on the units, we aren't talking about the same thing, at all, with a commensurately huge misunderstanding of the problem and thus the solution.
> 
> So please to not merely respond to the 2nd paragraph you disagree with. Answer the two questions above that paragraph.
> 
> If the spec is "1 URE event in 1E14 bits read" that is "1 bit nonrecoverable in 2.4E10 bits read" for a 512 byte physical sector drive, and hilariously becomes far worse at "1 bit nonrecoverable in 3E9 bits read" for 4096 byte physical sector drives.
> 
> A very simple misunderstanding should have a very simple corrective answer rather than hand waiving and giving up.

As I understand it, its "1" error (of no determinate size) for every
10E14 bits read....

The size of sectors would make no difference to the raw amount of data
read (although it does open an interesting question of what the 10E14
actually means, does it also include any check summing data, or is it
purely "data") nor the fact that 1 URE statistically might happen.

The amount of data corrupted is, I would have thought, variable
depending on what forms of checksums etc. was used and is indeterminable
without knowing the exact forms of work done on the raw data, how many
checksum values there might be for a "block" and so on, to try and
recover a meaningful, and valid, return... it could be that just 1 bit
of data was corrupted or it could be that the entire sectors worth of
data is garbage; it could also be that the 1 URE is in such a place that
it causes multiple sectors to be invalid...

Unless there is some industry standard document outlining what a "URE"
is it would be impossible to know for sure, and even then it may not
even define it to a specific amount of data corruption per data read;
just that "an error" is statistically likely to have happened.

> 
> 
> Chris Murphy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


