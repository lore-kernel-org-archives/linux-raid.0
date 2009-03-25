From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Question on RAID 10 setup
Date: Wed, 25 Mar 2009 08:26:40 -0400
Message-ID: <49CA2300.2090009@tmr.com>
References: <1183FAF84E86E244938C2174EE436BAC030FBE29@NYKPCMEU306VEUA.INTRANET.BARCAPINT.COM> <3513de790903241515m2eeff929x855322a51117c45b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3513de790903241515m2eeff929x855322a51117c45b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dylan Distasio <interzone@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dylan Distasio wrote:
> Hi all-
>
> I would like to put together a RAID10 array utilizing 2x1TB drives and
> 2x500 gig drives I have in my home Linux server.  Is the best way to do
> this to create 2 separate RAID1 arrays, one for each set of drives, and
> then a RAID0 array made up of the RAID1 ones?   I just wanted to verify
> that I am going about this correctly, and also get input on whether
> there are any disadvantages to this setup.  I would prefer not to split
> these up into two separate RAID10 arrays because I want the combined
> space available under one.   Thanks for any comments.
>   

Possibly you are confusing raid10 with raid1+0, and the documentation 
seems to encourage that. You can just use all your drives with raid10 
and mdadm will do the right thing as far as putting mirrors on other drives.

That said, I like the suggestion John made of raid0 to make a third 1TB 
device, then raid5. But be aware that "raid10 -f2" will be as fast or a 
little faster for write, and quite a bit faster for read, at the expense 
of some size. Using raid10 will give you 1.5TB and fast, raid0+5 will 
give you 2TB storage, but somewhat slower. And raid10 will be far faster 
if you should lose a drive and be running in a degraded mode.

Or you could buy a 1TB drive from Newegg for $89 and have even more 
choices. ;-)

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


