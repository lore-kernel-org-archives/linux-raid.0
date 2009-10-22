From: Lee Howard <faxguy@howardsilvan.com>
Subject: Re: [Fwd: Re: BUG: soft lockup - CPU#0 stuck for 10s! [md2_raid1:358]]
Date: Wed, 21 Oct 2009 20:29:19 -0700
Message-ID: <4ADFD18F.9050107@howardsilvan.com>
References: <4ADEFFC9.10405@shiftmail.org> <19167.33182.441497.969731@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19167.33182.441497.969731@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday October 21, asdo@shiftmail.org wrote:
>   
>> (whops I forgot to cc the list... here it is)
>>
>> Lee Howard wrote:
>>
>>     
>>> I've been deliberately monitoring the kernel via the git web 
>>> interfaces, and I can't yet see the patch committed that supposedly 
>>> fixed this.  (Please correct me if it was actually committed.)
>>>       
>> Somebody told it was fixed in 2.6.32. Have you checked that one?
>>     
>
> As 2.6.32 doesn't exist yet, that should be "will be fixed".
>
> If the problem if what I think it is, then it should be fixed by 
>   http://neil.brown.name/git?p=md;a=commitdiff;h=1d9d52416c0445019ccc1f0fddb9a227456eb61b
>
> which I have not yet sent to Linus.

Yes, thanks for this confirmation.  I'll watch for it in 2.6.32.

Thanks,

Lee.

