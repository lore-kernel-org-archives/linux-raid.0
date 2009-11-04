From: John Hughes <john@Calva.COM>
Subject: Re: MD performance options: More =?windows-1252?Q?CPU=92s_or_?=
 =?windows-1252?Q?more_Hz=92s=3F?=
Date: Wed, 04 Nov 2009 15:39:18 +0100
Message-ID: <4AF19216.30300@Calva.COM>
References: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com> <4AF18A39.6010404@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF18A39.6010404@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: mark delfman <markdelfman@googlemail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Bill Davidsen wrote:
> mark delfman wrote:
>> Hi... I am wondering if anyone can offer some advice on MD performance
>> related to CPU (speed and or cores).  
>
> You didn't ask: if you use ext[34] filesystems, there is a gain to be 
> had from tuning the stripe and stride parameters, at least for large 
> sequential io. My measurements were on 2.6.26, so are out of date, but 
> less head motion is always better. 
An external journal can be a huge win for ext3 if you are doing lots of 
file creates/deletes.  (Striped raid, i.e. raid0/raid5/raid6/raid10 
doesn't help the journal much as it is used sequentially.  In my tests 
putting the journal on a raid1 and the rest of the fs on a raid10 makes 
things go much faster.  If you have enough disks of course :-))


