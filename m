From: David Greaves <david@dgreaves.com>
Subject: Re: RAID halting
Date: Fri, 10 Apr 2009 09:53:02 +0100
Message-ID: <49DF08EE.5010004@dgreaves.com>
References: <20090410030252.RSAN6222.cdptpa-omta03.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090410030252.RSAN6222.cdptpa-omta03.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Leslie Rhorer wrote:
>>> I think the only way to switch schedulers is to reboot.  You invoke
>>> the noop scheduler via a command line arg to the kernel at boot time.
>> This can be done at any time, no reboot required:
>>
>>  for f in /sys/block/*/queue/scheduler; do
>>     echo noop > $f
>>     echo $f "$(cat $f)"
>>   done
> 
> OK, I did this.  Two questions:
> 
> 1.  The system responded in each case with this: "/sys/block/<block
> device>/queue/scheduler [noop] anticipatory deadline cfq".  Is this as
> expected?

Yes, it's the 2nd echo telling you what schedulers are available and which is
selected in a 'human readable form'

> 2.  To switch back to the default scheduler, which I take it is CFQ, do I
> simply issue the command above, replacing the string "noop" with "cfq"?

Yes

David

-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
