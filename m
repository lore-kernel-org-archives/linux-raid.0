From: Asdo <asdo@shiftmail.org>
Subject: Re: Why does one get mismatches?
Date: Fri, 22 Jan 2010 17:34:29 +0100
Message-ID: <4B59D395.9020604@shiftmail.org>
References: <141903.28627.qm@web51308.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <141903.28627.qm@web51308.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org, Brett Russ <bruss@netezza.com>
List-Id: linux-raid.ids

Jon Hardcastle wrote:
> <SNIP>
>   
>> Note that if your md device is not in a read-only mode that
>> the member states may be changing underneath you as you run
>> the above command. Therefore, you should either stop the
>> device then run the commands, or at least have the device in
>> a read-only mode first.
>>
>> -BR
>>
>>     
>
> I have just tried this - i umounted all LV and then deactivated the VG. I set to read-only but now any attempt to echo check > sync_action results in
>
> 'write error: device or resource busy'
>
> any clues/
>   

I think running check or repair is not supported with the MD array set 
read-only.
I remember Neil Brown himself saying that, and I seem to recall I have 
also seen this in the source code.
