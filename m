From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [linux-lvm] Q: Online resizing ext3 FS
Date: Tue, 18 Sep 2007 14:00:59 -0400
Message-ID: <46F0125B.6020605@tmr.com>
References: <20070912163621.1f951876@slopi> <46E7FE32.7010404@wpkg.org> <87ejh2n2kk.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ejh2n2kk.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LVM general discussion and development <linux-lvm@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Tomasz Chmielewski <mangoo@wpkg.org> writes:
>
>   
>> Chris Osicki schrieb:
>>     
>>> Hi
>>>
>>> I apologize in advance for asking a question not really appropriate
>>> for this mailing list, but I couldn't find a better place with lots of
>>> people managing lots of disk space.
>>>
>>> The question:
>>> Has anyone of you been using ext2online to resize (large) ext3 filesystems?
>>> I have to do it going from 500GB to 1TB on a productive system I was
>>> wondering if you have some horror/success stories.
>>> I'm using RHEL4/U4 (kernel 2.6.9) on this system.
>>>       
>
> That kernel seems to be a bit old. Better upgrade first.
>   

You don't upgrade when using the stable releases... that's the whole 
idea, you don't have to worry about a new versions of anything, the bugs 
and security issues are backported, but the version stays the same. 
Highly desirable for "must work" systems, no so nice for doing cutting 
edge stuff using nice features you don't have. :-(

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

