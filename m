From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Green drives and RAID arrays with partity
Date: Mon, 26 Sep 2011 08:03:04 -0500
Message-ID: <4E807808.4020008@hardwarefreak.com>
References: <4E7F0A31.4070001@yazzy.org> <4E7F13E8.4080606@hardwarefreak.com> <4E7F3A80.7010308@yazzy.org> <4E7F40A4.6040704@hardwarefreak.com> <4E7FA956.9000501@yazzy.org> <4E7FC40E.5080606@hardwarefreak.com> <4E7FC4E7.7010101@yazzy.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7FC4E7.7010101@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/25/2011 7:18 PM, Marcin M. Jessa wrote:
> On 9/26/11 2:15 AM, Stan Hoeppner wrote:
>> On 9/25/2011 5:21 PM, Marcin M. Jessa wrote:
>>
>>> My motherboard has a built in RAID controller which I do not use.
>>
>> What make/model is the mobo?
>
> My motherboard is a MSI 870A-G54 -
> http://www.msi.com/product/mb/870A-G54.html

The AMD SB850 is a relatively new Southbridge chip, SATA3 AHCI at that. 
  Are you using AHCI mode?  I'd take a deep look in demsg output and in 
/var/log/kern.log for any errors relating to SATA, AHCI, mdraid, etc.

Quite often when drives are kicked offline it is a result of timeouts 
and/or other errors on the SATA channels.  The log information may help 
narrow down the cause, whether a Southbridge problem, driver problem, 
mode setting problem, drive firmware problem, etc.

For instance, the SB850 has 6 SATA3 ports.  If the drives are SATA2, and 
something is buggy in firmware on either end, there could be a link 
speed negotiation problem causing problems.  Manually forcing the link 
speed to SATA2 may help in such a situation.  You may also want to try 
using native SATA/IDE mode instead of AHCI if you're currently using 
AHCI.  If not, you may want to try AHCI mode.

Regardless, find the errors in your logs and post them to the linux-ide 
list for help.

-- 
Stan


