From: Mike Hardy <mhardy@h3c.com>
Subject: Re: how to clone a disk
Date: Sat, 11 Mar 2006 08:55:59 -0800
Message-ID: <4413011F.30709@h3c.com>
References: <1142038562.20484.234.camel@localhost.localdomain> <dd43dcfb0603110353g1a4d51f6y9fe4caa4007b6e9c@mail.gmail.com> <op.s581hroxcigqcu@apollo13>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.s581hroxcigqcu@apollo13>
Sender: linux-raid-owner@vger.kernel.org
To: PFC <lists@peufeu.com>
Cc: "Paul M." <paul@gpmidi.net>, mingz@ele.uri.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I can think of two things I'd do slightly differently...

Do a smartctl -t long on each disk before you do anything, to verify
that you don't have single sector errors on other drives

Use ddrescue for better results copying a failing drive

-Mike

PFC wrote:
> 
>>> I have a raid5 array that contain 4 disk and 1 spare disk. now i saw one
>>> disk have sign of going fail via smart log.
> 
> 
>     Better safe than sorry... replace the failing disk and resync,
> that's all.
> 
>     You might want to do "cat /dev/md# > /dev/null", or "cat /dev/hd? 
> 
>> /dev/null" first. This is to be sure there isn't some yet-unseen bad  
> 
> sector on some other drive which would screw your resync.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
