From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: how to disable partition search?
Date: Wed, 26 Mar 2008 16:20:59 -0400
Message-ID: <47EAB02B.3080104@tmr.com>
References: <87ve39lngy.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ve39lngy.fsf@tac.ki.iif.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ferenc Wagner wrote:
> Hi,
>
> I use an FC SAN, which provides multiple pathes to multiple LUNs.
> These all come up as different sd* devices, exhausting single letter
> names.  I mean they are a LOT.  Using the md mulitpath driver
> everything works perfectly, no problems there.  However, during boot,
> the kernel tries to read the partition table from each device,
> spitting out hundreds of lines of error messages: most of the devices
> aren't even readable, and those which are, don't contain a valid
> partition table.  They never will.  So I'd like to disable partition
> detection, because these messages overflow the kernel message buffer,
> depriving syslog of gathering any useful boot messages, and also
> needlessly lengthening the boot process.  (Of course the noise alone
> is disturbing enough when one tries to troubleshoot a boot problem.)
> However, looking at the kernel sources didn't give me any hint.  Is
> this possible to disable at all?
>
> (Please Cc me, I'm not on the list.)
>   
After reading some code, I didn't see any boot or module load options 
you can use to prevent that, I think you may want to increase buffer 
size to hold the messages and use "grep -v" to create a sanitized 
dmesg.  If you can give an example of the error message you see I can 
look again.

Don't forget to copy the list...

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


