From: Martin Wilck <mwilck@arcor.de>
Subject: Re: MD array keeps resyncing after rebooting
Date: Tue, 23 Jul 2013 23:21:23 +0200
Message-ID: <51EEF3D3.7020305@arcor.de>
References: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>	<CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>	<51EED0DA.3020901@arcor.de>	<51EED102.4020503@arcor.de> <CAC9WiBgN1-HBEgqwo7CWor=nihCYUcOrYKhGxYTgbC-d4a7_-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBgN1-HBEgqwo7CWor=nihCYUcOrYKhGxYTgbC-d4a7_-g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/23/2013 10:01 PM, Francis Moreau wrote:
> Hello Martin
> 
> On Tue, Jul 23, 2013 at 8:52 PM, Martin Wilck <mwilck@arcor.de> wrote:
>> On 07/23/2013 08:52 PM, Martin Wilck wrote:
>>> Which MD version are you using?
>>
>> I meant: which mdadm version. Sorry.
>>
> 
> I'm using mdadm version 3.2.3
> 
> I'll give the current git version a try tomorrow.
> 
> The thing is that I need to wait the sync to finish in order to test
> this problem. But the sync takes a while (> 4 hours, I don't remember
> exactly). Are there any ways to speed up the process ?

MD will adjust its speed while initializing, thus the fastest way is to
do nothing on the system, avoiding any other disk IO. This will cause MD
to use max bandwidth.

One thing you can do for testing is to create a smaller array which will
of course initialize faster.

Please run mdadm -E /dev/sdX for all RAID disks before and after reboot
and watch out for differences.

Martin

> 
> Thanks
> --
> Francis

