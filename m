From: Phil Turmel <philip@turmel.org>
Subject: Re: "Missing" RAID devices
Date: Wed, 22 May 2013 19:26:19 -0400
Message-ID: <519D541B.1090508@turmel.org>
References: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com> <519B9351.4050708@turmel.org> <CAGPLN=uiUD3wnwt6DfELaLh+yqxkbrA=KetPiQHZrqq4FrS=HA@mail.gmail.com> <519C0B13.3040906@turmel.org> <519D4A15.7020107@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <519D4A15.7020107@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/22/2013 06:43 PM, Stan Hoeppner wrote:
> Sorry for the dup Phil, hit the wrong reply button.

No worries.

> On 5/21/2013 7:02 PM, Phil Turmel wrote:
> ...
>> ...First is /dev/md1, a small (~500m) n-way
>> ...as /boot.  The other, /dev/md2, uses
>> ...raid10,far3 or raid6.
>>
>> I put LVM on top of /dev/md2, with LVs for swap, ... /tmp
> 
> Swap and tmp atop an LV atop RAID6?  The former will always RMW on page
> writes, the latter quite often will cause RMW.  As you stated your
> performance requirements are modest.  However, for the archives, putting
> swap on a parity array, let alone a double parity array, is not good
> practice.

Ah, good point.  Hasn't hurt me yet, but it would if I pushed anything
hard.  I'll have to revise my baseline to always have a small raid10,f3
to go with the raid6.

Meanwhile, I'm applying some of the general ideas I've seen from you:
I've acquired a pair of Crucial M4 SSDs for my new home media server to
keep small files and databases away from the bulk storage.  Not in
service yet, but I'm very pleased so far.

I'm pretty sure the new kit is way overkill for a media server... :-)

Thanks,

Phil

