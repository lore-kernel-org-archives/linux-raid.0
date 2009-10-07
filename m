From: Luca Berra <bluca@comedia.it>
Subject: Re: mdadm segfault when assembling the array
Date: Wed, 7 Oct 2009 18:28:16 +0200
Message-ID: <20091007162816.GC10862@maude.comedia.it>
References: <4ACC5265.2020602@wpkg.org> <aebf5d970910070203l63b21cd4v61e5c9a78e09b8ff@mail.gmail.com> <4ACC5BB6.7010208@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4ACC5BB6.7010208@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 07, 2009 at 11:13:26AM +0200, Tomasz Chmielewski wrote:
> Beolach schrieb:
>> On Wed, Oct 7, 2009 at 02:33, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>
>>> The kernel is 2.6.31.1.
>>>
>>> Any hints before I try to fix it my way?
>>>
>>
>> How did you install mdadm?  I think I remember similar issues w/
>> segfaults when I
>> compiled w/ MAKEOPTS=-jN where N>1.  What distro & architecture were you on?
>
> I'm using a distribution package (Mandriva Cooker, 64 bit). It was working 
> fine all the time; started to break with yesterday's crashes (I see my 
> /boot array is not available as well).
could you run it under gdb and post a backtrace?

L.

-- 
Luca Berra -- bluca@comedia.it
          Communication Media & Services S.r.l.
   /"\
   \ /     ASCII RIBBON CAMPAIGN
    X        AGAINST HTML MAIL
   / \
