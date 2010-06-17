From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: migrating from RAID5 to RAID10
Date: Wed, 16 Jun 2010 21:59:15 -0400
Message-ID: <4C198173.6050305@tmr.com>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU> <20100611005231.401529c0@natsu> <20100610195851.GA8408@libra.CS.Berkeley.EDU> <4C18F39E.8010600@tmr.com> <20100616183031.GB2513@scorpio.mgarnold.homelinux.org> <20100616201523.GA24349@libra.CS.Berkeley.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100616201523.GA24349@libra.CS.Berkeley.EDU>
Sender: linux-raid-owner@vger.kernel.org
To: Gilad Arnold <arnold@cs.berkeley.edu>
Cc: Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gilad Arnold wrote:
> On Wed, Jun 16, 2010 at 11:30:31AM -0700, Gilad Arnold wrote:
>   
>> Thanks for the thorough evaluation and thoughtful advice! Much
>> appreciated.  I agree it makes a lot more sense and I will follow your
>> suggested procedure (when I get to purchase the extra drive ;-) )
>>     
>
> PS, a related question: some measurements posted on the web suggest that
> RAID10 in f2 mode is far superior to n2 (the default?) when it comes to
> reading performance, and only mildly inferior when writing.  I tend to
> go with f2, unless someone tells me it's a bad idea.
>
>   
It is a GREAT idea, and will produce much better sustained read performance.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

