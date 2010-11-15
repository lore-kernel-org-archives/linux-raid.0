From: Tim Small <tim@seoss.co.uk>
Subject: Re: ata4.00: exception Emask 0x0 SAct 0x1b7ffff SErr 0x0 action 0x6
 frozen
Date: Mon, 15 Nov 2010 15:05:17 +0000
Message-ID: <4CE14C2D.5090701@seoss.co.uk>
References: <201011151533.17638.raid2@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201011151533.17638.raid2@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: Pol Hallen <raid2@fuckaround.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/11/10 14:33, Pol Hallen wrote:
> [ 5485.000265] ata4.00: status: { DRDY }
> [ 5485.000293] ata4.00: failed command: READ FPDMA QUEUED
> [ 5485.000325] ata4.00: cmd 60/60:08:c7:3e:84/00:00:56:00:00/40 tag 1 ncq 
> 49152 in
> [ 5485.000326]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [...]
>
> how check which disk should be broke broken? or is it a controller problem?
> thanks!
>   

Could be all sorts of things - disk or controller, or cabling, or
PSU...  See the libata wiki, and run smartctl -a against each drive in
turn.  Look for non-zero reallocated sector counts, non-zero pending
sector counts (check the "raw" data field for both), as well as logged
SMART errors etc. etc.  If you have a suspect bad drive, you can use
smartctl to tell the drive to run a smart long self test.  See the
documentation.

Tim.


-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.  
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

