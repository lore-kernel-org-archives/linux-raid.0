From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Questions about 4k sector drives
Date: Mon, 10 May 2010 13:13:28 -0400
Message-ID: <4BE83EB8.5060004@tmr.com>
References: <4BD42B57.9000703@kusche.de> <1272206601.7734.4.camel@faldara> <4BDE0512.8070502@tmr.com> <x2v87f94c371005030630idaaad1e9ue3faff470bd318e1@mail.gmail.com> <4BDED1F2.102@cfl.rr.com> <yq17hnkpw7v.fsf@sermon.lab.mkp.net> <4BE0201A.6080101@cfl.rr.com> <yq1mxwfznv8.fsf@sermon.lab.mkp.net> <4BE121F0.7000408@anonymous.org.uk> <alpine.DEB.1.10.1005050945220.3685@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1005050945220.3685@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> On Wed, 5 May 2010, John Robinson wrote:
>
>> You can? Which one(s)? Would they be good for putting md bitmaps and 
>> filesystem journals on?
>
> Yes. The Intel X25-V 40G drive is the one I would recommend, I use it 
> as a system drive in one box, it's not as fast (linear write speed) as 
> the X25-M drives, but it's definitely a step up from the 5400rpm 2.5" 
> drive I used in the system before :P
>
2nd that, nice drive, cheap, many uses for it. In addition to bitmap and 
journal (pick the right journal options and see a huge boost), putting 
swap out there make hibernate one of those "wanna see it again" operations.

I really want to use it for write cache, but I guess putting a big 
journal there has a similar effect.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

