From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: mdadm segfault when assembling the array
Date: Wed, 07 Oct 2009 18:55:42 +0200
Message-ID: <4ACCC80E.4090604@wpkg.org>
References: <4ACC5265.2020602@wpkg.org> <aebf5d970910070203l63b21cd4v61e5c9a78e09b8ff@mail.gmail.com> <4ACC5BB6.7010208@wpkg.org> <20091007162816.GC10862@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091007162816.GC10862@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra schrieb:
> On Wed, Oct 07, 2009 at 11:13:26AM +0200, Tomasz Chmielewski wrote:
>> Beolach schrieb:
>>> On Wed, Oct 7, 2009 at 02:33, Tomasz Chmielewski <mangoo@wpkg.org> 
>>> wrote:
>>
>>>> The kernel is 2.6.31.1.
>>>>
>>>> Any hints before I try to fix it my way?
>>>>
>>>
>>> How did you install mdadm?  I think I remember similar issues w/
>>> segfaults when I
>>> compiled w/ MAKEOPTS=-jN where N>1.  What distro & architecture were 
>>> you on?
>>
>> I'm using a distribution package (Mandriva Cooker, 64 bit). It was 
>> working fine all the time; started to break with yesterday's crashes 
>> (I see my /boot array is not available as well).
> could you run it under gdb and post a backtrace?

As I said, it's fixed in the latest mdadm git tree.


-- 
Tomasz Chmielewski
http://wpkg.org

