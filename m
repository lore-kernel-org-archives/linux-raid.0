From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Help needed: array inactive after grow attempt
Date: Fri, 29 Apr 2016 08:43:59 +1000
Message-ID: <5722922F.3060209@websitemanagers.com.au>
References: <1d5a8c36a6802a9e7e32eb056165f200@spoilbase.eu>
 <7cfbdd22b8c20acdb95fababfa1a04a6@spoilbase.eu>
 <57228AD7.1050408@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57228AD7.1050408@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Andread Mayrhoff <repro@spoilbase.eu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/04/16 08:12, Wols Lists wrote:
> On 28/04/16 20:50, Andread Mayrhoff wrote:
>> I might add
>>
>> ~/tmp # mdadm --stop /dev/md127
>> mdadm: stopped /dev/md127
>> ~/tmp # mdadm --assemble --scan
>> mdadm: Failed to restore critical section for reshape, sorry.
>>         Possibly you needed to specify the --backup-file
>>
>> Thanks for helping me out of this...
> Have you got the latest mdadm? See the "stuck reshape operation" thread
> for details.
>
> You could also try adding the --invalid-backup option to mdadm. It
> shouldn't need a backup if you're adding more disk, though, so that
> looks slightly odd to me.
>
> Beyond those tips I'll not stray - my raid-fu is not the best and while
> I'm confident of this information I don't believe in encouraging others
> to take risks. If those don't work I'll let a better expert than me
> chime in.
>
> Cheers,
> Wol

My suggestion (which isn't really a fix) is to take a quick look at disk 
overlays, that will allow you to "play" with your disks without damaging 
them, and retaining the ability to recover your data.

Once you do that, I think I've seen people use a combination of 
--invalid-backup and --force to solve this kind of problem. The 
interesting part would be to know if the reshape ever actually 
started/made progress. Usually people are reporting that it sits on 0% 
complete.

Hope that helps.

Regards,
Adam


-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
