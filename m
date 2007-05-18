From: Colin McCabe <Colin.P.McCabe@gmail.com>
Subject: Re: unreadable drives can be synchronized?
Date: Fri, 18 May 2007 14:10:50 -0400
Message-ID: <464DEC2A.6040209@gmail.com>
References: <200705181447.l4IElO2a000640@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200705181447.l4IElO2a000640@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Burgess wrote:
>> Basically, B appears to be "write-only"; it will never return an error on a
>> write, but just try to read from it, and you will be sorry.
> 
> It would be interesting to see what SMART says about drive B, especially
> the short and long self tests.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

On my hard drives, automatic online testing is turned on, and so is 
automatic offline testing. I run the long self-test once a week.

I have two drives which can play the role of B. One of them has this 
SMART output:

[root@cmccabe-devel root]# smartctl -d ata /dev/sdb -H
smartctl version 5.36 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: FAILED!
Drive failure expected in less than 24 hours. SAVE ALL DATA.
Failed Attributes:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   5 Reallocated_Sector_Ct   0x0033   004   004   024    Pre-fail 
Always   FAILING_NOW 133273031255

The other one passes SMART.
Both of them eat data, though.

Colin

