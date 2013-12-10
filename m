From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: Rebuild events while scrubbing - problems or just informational?
Date: Tue, 10 Dec 2013 17:55:06 +0100
Message-ID: <52A7476A.9060307@gmail.com>
References: <CAK2H+ed3vEJVF8To8FWD_Ltj7jGKgrBAvz-Aum4viR=VZE+gww@mail.gmail.com> <20131210085225.GA441@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131210085225.GA441@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/10/2013 09:52 AM, Robin Hill wrote:
>> Dec  8 14:30:01 c2RAID6 mdadm[1838]: RebuildStarted event detected on
>> md device /dev/md/3
>> Dec  8 15:03:21 c2RAID6 mdadm[1838]: Rebuild26 event detected on md
>> device /dev/md/3
>> Dec  8 15:36:41 c2RAID6 mdadm[1838]: Rebuild49 event detected on md
>> device /dev/md/3
>> Dec  8 16:10:01 c2RAID6 mdadm[1838]: Rebuild70 event detected on md
>> device /dev/md/3
>> Dec  8 16:43:21 c2RAID6 mdadm[1838]: Rebuild87 event detected on md
>> device /dev/md/3
>>
> 
> They're perfectly normal if you're doing a repair - I don't think they
> should be there for a check though. It's just mdadm in monitor mode
> reporting the progress (the numbers are the percentage completed) to
> syslog.  According to the manual the default reporting interval is 20
> percent, but I think it actually triggers on a completed stripe (or
> block of stripes) so the numbers aren't exactly on the interval.

I see them as well during checks. Although I can't find documentation
stating so I regard them as normal.
