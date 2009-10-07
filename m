From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: mdadm segfault when assembling the array
Date: Wed, 07 Oct 2009 11:13:26 +0200
Message-ID: <4ACC5BB6.7010208@wpkg.org>
References: <4ACC5265.2020602@wpkg.org> <aebf5d970910070203l63b21cd4v61e5c9a78e09b8ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aebf5d970910070203l63b21cd4v61e5c9a78e09b8ff@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Beolach <beolach@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Beolach schrieb:
> On Wed, Oct 7, 2009 at 02:33, Tomasz Chmielewski <mangoo@wpkg.org> wrote:

>> The kernel is 2.6.31.1.
>>
>> Any hints before I try to fix it my way?
>>
> 
> How did you install mdadm?  I think I remember similar issues w/
> segfaults when I
> compiled w/ MAKEOPTS=-jN where N>1.  What distro & architecture were you on?

I'm using a distribution package (Mandriva Cooker, 64 bit). It was 
working fine all the time; started to break with yesterday's crashes (I 
see my /boot array is not available as well).

However, I just compiled mdadm from source (without changing any options 
in the Makefile), and it crashes too.


-- 
Tomasz Chmielewski
http://wpkg.org


