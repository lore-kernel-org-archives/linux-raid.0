From: Tom Pfeifer <tpfeife1@gmail.com>
Subject: Re: dm-raid45?
Date: Tue, 03 Dec 2013 09:42:07 -0500
Message-ID: <529DEDBF.4020905@gmail.com>
References: <CAGRSmLv9vpLRr=WdY+YJFhE9aZfGYtYbegTo=g6MUPz5z+NSww@mail.gmail.com>
 <CANBHLUgEj5VjLbzuO+cu=fTRwsNQX3ZD7cCPa5=6k21S_wF5Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <CANBHLUgEj5VjLbzuO+cu=fTRwsNQX3ZD7cCPa5=6k21S_wF5Qg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dmitrijs Ledkovs <xnox@debian.org>
Cc: "David F." <df7729@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/26/2013 06:32 PM, Dmitrijs Ledkovs wrote:
> On 26 November 2013 18:07, David F. <df7729@gmail.com> wrote:
>> As a workaround to the mdadm issue with the spare drive we were going
>> to have them activate DMRAID but that ends up with the information
>> below.  Specifically something about dm-raid45 but we had to drop that
>> because it no longer compiles in the latest kernels and we couldn't
>> find an update that would.   Any ideas?  (still working on getting the
>> dump - the fact that tmpfs doesn't support sparse files makes having
>> the customer create the dump via a script we provide a bit more
>> involved):
>>
> 
> Ubuntu kernels still somewhat maintain and have dm-raid-45 module.
> 
> Install linux-image-extra-virtual package which will pull in correct
> versioned packaged with extra modules.
> 
> It is planned however to migrate off & drop dm-raid-45 module soon.
> 
> ps. latest version I can find is
> 3.8.0-22-generic/kernel/ubuntu/dm-raid4-5/dm-raid45.ko
> 
> Regards,
> 
> Dmitrijs.

As a follow up to this general subject, what will replace the dm-raid45
module after it is dropped?

I guess another way to ask that question is what functionality does the
dm-raid45 module support that is not currently supported by the dm-raid
module, which has aliases to dm-raid1, dm-raid4, dm-raid5, dmraid6, and
dm-raid10.

And is it already possible now (in recent kernels such as 3.11.x and
later) to use the dm-raid module in place of dm-raid45?




