From: Jordan Russell <jr-list-2010@quo.to>
Subject: Re: Data-check brings system to a standstill
Date: Fri, 18 Jun 2010 12:27:32 -0500
Message-ID: <4C1BAC84.4090000@quo.to>
References: <4C0FCFCD.4070201@quo.to> <4C19015B.3020807@tmr.com> <4C1BA880.1050609@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C1BA880.1050609@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/18/2010 12:10 PM, Tim Small wrote:
> Have things switched to AHCI (or similar SATA controller) with NCQ 
> since?  If so, do you drives have buggy firmware which makes them suck 
> with sequential reads when NCQ is enabled?  See the libata wiki for 
> details - you can try disabling NCQ (or limiting queue depth to 2, or 
> whatever) to test it....

The disks are on an older Intel 6300ESB controller, which I'm fairly
certain has no support for NCQ.

ata4.00: ATA-7: WDC WD3200YS-01PGB0, 21.00M21, max UDMA/133
ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/1)
ata3.00: ATA-7: WDC WD3200YS-01PGB0, 21.00M21, max UDMA/133
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/1)

-- 
Jordan Russell
