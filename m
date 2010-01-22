From: Brett Russ <bruss@netezza.com>
Subject: Re: Why does one get mismatches?
Date: Fri, 22 Jan 2010 12:41:04 -0500
Message-ID: <hjcnvg$t53$1@ger.gmane.org>
References: <hj73e0$anm$1@ger.gmane.org> <141903.28627.qm@web51308.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <141903.28627.qm@web51308.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/22/2010 11:22 AM, Jon Hardcastle wrote:
> <SNIP>
>>
>> Note that if your md device is not in a read-only mode that the
>> member states may be changing underneath you as you run the above
>> command. Therefore, you should either stop the device then run the
>> commands, or at least have the device in a read-only mode first.
>>
>> -BR
>>
>
> I have just tried this - i umounted all LV and then deactivated the
> VG. I set to read-only but now any attempt to echo check>
> sync_action results in

Sorry for the misunderstanding, I was suggesting putting the array in 
read only mode only for the purposes of doing the 'mdadm --examine' to 
detect if member devices were out of sync with each other.

But, it turns out that the mismatches you're seeing are not a result of 
the member devices being out of sync with each other but rather member 
devices throwing errors.  Sounds like other people see this same 
behavior and it's not necessarily tied to any disk sector read errors. 
If there are also no I/O errors in the kernel log during your 'check' 
operation, you'll need either more verbose md logging during the check 
or a look at the code to see what other kinds of errors bump the 
mismatch counter.

-BR

