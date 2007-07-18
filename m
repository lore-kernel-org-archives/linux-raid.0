From: Bryan Christ <bryan.christ@hp.com>
Subject: Re: Raid array is not automatically detected.
Date: Wed, 18 Jul 2007 10:49:32 -0500
Message-ID: <469E368C.6010002@hp.com>
References: <4697E231.3070906@hp.com> <4698D4FC.2060100@tmr.com> <Pine.LNX.4.64.0707140952440.31528@p34.internal.lan> <469B7E75.3030907@hp.com> <469B8D05.1080003@dgreaves.com> <469E2626.30204@hp.com> <469E35ED.3040500@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <469E35ED.3040500@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ya.  I saw my mistake just a little while ago and running --examine on 
the component worked fine.  I didn't see anything suspicious.

David Greaves wrote:
> Bryan Christ wrote:
>> I'm now very confused...
> It's all that top-posting...
> 
> 
>> When I run mdadm --examine /dev/md0 I get the error message:  No 
>> superblock detected on /dev/md0
>>
>> However, when I run mdadm -D /dev/md0 the report clearly states 
>> "Superblock is persistent"
> 
>> David Greaves wrote:
>>> * are the superblocks version 0.9? (mdadm --examine /dev/component)
> 
> See where it says 'component' ? :)
> 
> I wish mdadm --detail and --examine were just aliases and the output 
> varied according to whether you looked at a component (eg /dev/sda1) or 
> an md device (/dev/md0)
> 
> I get that wrong *all* the time...
> 
> David
