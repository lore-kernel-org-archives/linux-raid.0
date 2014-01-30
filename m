From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Thu, 30 Jan 2014 11:22:30 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1401301049180.11807@uplift.swm.pp.se>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org>
 <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com> <52E2691E.4050701@turmel.org> <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com> <52E29CEF.7030408@turmel.org> <62EB0D79-9A50-4C50-ACBF-1C507D6F449B@colorremedies.com> <52E2AD10.5080208@turmel.org>
 <E222FBA0-8A1A-48EF-BEAA-BD059A8C1554@colorremedies.com> <52E2C5A3.1050803@turmel.org> <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com> <52E3DCE4.4020909@turmel.org> <52E3F7FE.6000004@hardwarefreak.com> <0EDC3349-197C-402E-8940-06AF44A164B6@colorremedies.com>
 <alpine.DEB.2.02.1401270810350.20074@uplift.swm.pp.se> <73BCC7B7-234C-4FD9-A1A0-BD5CCA7B9E09@colorremedies.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-513377363-1391077350=:11807"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73BCC7B7-234C-4FD9-A1A0-BD5CCA7B9E09@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: stan@hardwarefreak.com, Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-513377363-1391077350=:11807
Content-Type: TEXT/PLAIN; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 27 Jan 2014, Chris Murphy wrote:

>> This is your interpretation of the claim. My interpretation of the data is that you will get an URE for every 10^14 bits read.
>
> How does your interpretation differ if the < sign is removed from the 
> stated spec? Linguistically, how do you alter the description if that 
> symbol is and isn't present?

THe spec is an SLA. THe manufacturer will try to beat that number to keep 
the SLA. Sometimes they're a lot better, sometimes they're worse and then 
they have to compensate the customer.

> And we also know that the size of the packet does affect error rates, 
> just not within an order of magnitude, such is also the case with HDDs 
> between conventional and AF disks. But the allowance of up to but not 
> including an order of magnitude is necessarily implied by the less than 
> sign or it wouldn't be there. It's a continuum, it's not a statement of 
> what will happen on average. It's a statement that error will occur but 
> won't exceed X errors in Y bits.

If you run the connection full, the packet size doesn't affect the bit 
error rate, only the result of the bit error.

>> Where exactly in the available data does it say that?
>
> Drive manufacturers saying AF disks means better error correction both because of the larger size of sectors, and also more ECC bits.
>
> http://www.snia.org/sites/default/files2/SDC2011/presentations/wednesday/CurtisStevens_Advanced_Format_Legacy.pdf
>
> http://storage.toshiba.eu/export/sites/toshiba-sdd/media/downloads/advanced_format/4KWhitePaper_TEG.pdf
> ", if the data field to be protected in each sector is larger than 512 bytes, the ECC algorithm could be improved to correct for a higher number of bits in error"
>
> http://www.idema.org/wp-content/plugins/download-monitor/download.php?id=1244
> page 3, 2nd figure "errors per 512 bytes vs physical block size"
>
> There's loads of information on this…

The 4k sector design is an internal design means to achieve the specified 
SLA. So while 4k ECC is better, the manufacturer might use a higher 
density with a higher bit error rate, but which end result is still within 
the offered SLA because of better error correction method.

So we're back to what the 10^-14 means. This is all you have to go on, 
because internally the manufacturer is free to use 512b sector size, 4k 
sector size, or pixie dust to achieve the specs they're offering the end 
customer. There is nothing that says that you as a customer gets to 
partake in any improvement due to internal changes within the unit.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-513377363-1391077350=:11807--
