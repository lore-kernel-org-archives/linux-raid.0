From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: mdadm segfault when assembling the array
Date: Wed, 07 Oct 2009 11:03:52 +0200
Message-ID: <4ACC5978.8060501@wpkg.org>
References: <4ACC5265.2020602@wpkg.org> <70ed7c3e0910070140l1240d48ak1d12738f9f00f0e9@mail.gmail.com> 	<4ACC55C1.6020603@wpkg.org> <70ed7c3e0910070150u4445daa8u194d00f0e3f25b8f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0910070150u4445daa8u194d00f0e3f25b8f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Majed B. schrieb:
> My bad. I haven't noticed that you were using 3.0.2
> 
> Try to force the assembly of the array -Af and see if it works. If
> that doesn't work, run it again using strace (strace mdadm ...) and
> that should give much more detail into why this is happening.

I don't see anything particular in the strace:

http://www1.wpkg.org/mdadm.txt

(here, adding only one drive, as I had to mount the other drive without 
md to access data).


-- 
Tomasz Chmielewski
http://wpkg.org
