From: Dmitrijs Ledkovs <xnox@debian.org>
Subject: Re: dm-raid45?
Date: Tue, 3 Dec 2013 16:09:16 +0000
Message-ID: <CANBHLUgPoW=r27k9MXRrQnmQ_hmVWN_-LsPqu_+zzL8ZohozbQ@mail.gmail.com>
References: <CAGRSmLv9vpLRr=WdY+YJFhE9aZfGYtYbegTo=g6MUPz5z+NSww@mail.gmail.com>
	<CANBHLUgEj5VjLbzuO+cu=fTRwsNQX3ZD7cCPa5=6k21S_wF5Qg@mail.gmail.com>
	<529DEDBF.4020905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <529DEDBF.4020905@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tom Pfeifer <tpfeife1@gmail.com>
Cc: "David F." <df7729@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3 December 2013 14:42, Tom Pfeifer <tpfeife1@gmail.com> wrote:
> On 11/26/2013 06:32 PM, Dmitrijs Ledkovs wrote:
>> On 26 November 2013 18:07, David F. <df7729@gmail.com> wrote:
>>> As a workaround to the mdadm issue with the spare drive we were going
>>> to have them activate DMRAID but that ends up with the information
>>> below.  Specifically something about dm-raid45 but we had to drop that
>>> because it no longer compiles in the latest kernels and we couldn't
>>> find an update that would.   Any ideas?  (still working on getting the
>>> dump - the fact that tmpfs doesn't support sparse files makes having
>>> the customer create the dump via a script we provide a bit more
>>> involved):
>>>
>>
>> Ubuntu kernels still somewhat maintain and have dm-raid-45 module.
>>
>> Install linux-image-extra-virtual package which will pull in correct
>> versioned packaged with extra modules.
>>
>> It is planned however to migrate off & drop dm-raid-45 module soon.
>>
>> ps. latest version I can find is
>> 3.8.0-22-generic/kernel/ubuntu/dm-raid4-5/dm-raid45.ko
>>
>> Regards,
>>
>> Dmitrijs.
>
> As a follow up to this general subject, what will replace the dm-raid45
> module after it is dropped?
>
> I guess another way to ask that question is what functionality does the
> dm-raid45 module support that is not currently supported by the dm-raid
> module, which has aliases to dm-raid1, dm-raid4, dm-raid5, dmraid6, and
> dm-raid10.
>
> And is it already possible now (in recent kernels such as 3.11.x and
> later) to use the dm-raid module in place of dm-raid45?
>

The current plan is as following:
* for ddf & intel matrix raid formats => migrate from dmraid to mdadm
(external metadata) (which supports raid levels 4 & 5 for those
formats and more)
* investigate whether dmraid can be modified to use stock dm-raid
modules, instead of the dmraid45 module

The first point should cover all but nvidia/dmraid, the second one
should resolve the situation completely.

Above plan was discussed at the public virtual Ubuntu Developer Summit
(video at):
http://summit.ubuntu.com/uds-1311/meeting/22028/core-1311-dmraid2mdadm/

The workitems to complete above are tracked on a blueprint at launchpad:
https://blueprints.launchpad.net/ubuntu/+spec/core-1311-dmraid2mdadm

You can subscribe to the blueprint, if you wish, to get email updates
on the progress of this work to get notified when it's ready/available
for testing.

Regards,

Dmitrijs.
