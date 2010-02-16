From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 12:18:22 -0500
Message-ID: <4B7AD35E.7000405@tmr.com>
References: <201002140251.59668.volkerarmin@googlemail.com> <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com> <201002141940.35716.volkerarmin@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201002141940.35716.volkerarmin@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Cc: Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Volker Armin Hemmann wrote:
> On Sonntag 14 Februar 2010, you wrote:
>
>   
>> In other words, 'auto-detection' for 1.x format devices is using an
>> initrd/initramfs.
>>     
>
> which makes 1.x format useless for everybody who does not want to deal with 
> initrd/initramfs.
>   

You make this sound like some major big deal. are you running your own 
distribution? In most cases mkinitrd does the right thing when you "make 
install" the kernel, and if you are doing something in the build so 
complex that it needs options, you really should understand the options 
and be sure you're doing what you want.

Generally this involves preloading a module or two, and if you need it 
every time you probably should have built it in, anyway.

My opinion...

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

