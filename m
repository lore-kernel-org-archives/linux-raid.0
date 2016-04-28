From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Help needed: array inactive after grow attempt
Date: Fri, 29 Apr 2016 00:30:50 +0100
Message-ID: <57229D2A.5040104@youngman.org.uk>
References: <1d5a8c36a6802a9e7e32eb056165f200@spoilbase.eu>
 <7cfbdd22b8c20acdb95fababfa1a04a6@spoilbase.eu>
 <57228AD7.1050408@youngman.org.uk>
 <c98c947ff2759669bcb5ccf87c3dd245@spoilbase.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c98c947ff2759669bcb5ccf87c3dd245@spoilbase.eu>
Sender: linux-raid-owner@vger.kernel.org
To: Andread Mayrhoff <repro@spoilbase.eu>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 28/04/16 23:29, Andread Mayrhoff wrote:
> Hello Wol,
> 
> that was already pretty helpful.
> 
> I am able to recover the old 5-disk-status by recreating the array with
> --assume-clean (and a couple of parameters). So the data seems safe
> while we're speaking.
> 
> However the reason for the problem (that still persists) is that the
> "grow" operation is, as you rightly say, stuck at 0%, and it doesn't
> progress at all.
> 
> That was the reason for the crash in the first place, because when the
> machine was switched off a couple of hours after I started the
> reshaping, it was very likely still at 0%.
> Now, I'm going to catch up with the other reports on the mail list and
> try to determine if there's any way to bypass the problem.

Ahhhh ....
> 
> Good night and thanks again...
> 
That sounds very promising. This is a regular problem that crops up on
the list a lot, and iirc the fix is very simple. Get the latest mdadm :-)

You should find a lot of info on the mailing list :-)

Cheers,
Wol
> 
> 2016-04-29 00:12, Wols Lists wrote:
>>> I might add
>>>
>>> ~/tmp # mdadm --stop /dev/md127
>>> mdadm: stopped /dev/md127
>>> ~/tmp # mdadm --assemble --scan
>>> mdadm: Failed to restore critical section for reshape, sorry.
>>>        Possibly you needed to specify the --backup-file
>>>
>>> Thanks for helping me out of this...
>>
>> Have you got the latest mdadm? See the "stuck reshape operation" thread
>> for details.
>>
>> You could also try adding the --invalid-backup option to mdadm. It
>> shouldn't need a backup if you're adding more disk, though, so that
>> looks slightly odd to me.
>>
>> Beyond those tips I'll not stray - my raid-fu is not the best and while
>> I'm confident of this information I don't believe in encouraging others
>> to take risks. If those don't work I'll let a better expert than me
>> chime in.
>>
>> Cheers,
>> Wol
> 
> 

