From: Jeff Hill <jhill@hrpost.com>
Subject: Re: mdadm mail option configuration
Date: Thu, 30 May 2002 10:11:57 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.0.20020530095915.01f38c48@205.233.215.4>
References: <message from Jeff Hill on Wednesday May 29>
 <message from Jeff Hill on Tuesday May 28>
 <5.1.0.14.0.20020528111927.01f28280@205.233.215.4>
 <5.1.0.14.0.20020529080432.01f32cd8@205.233.215.4>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15605.23522.860348.236412@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 08:53 AM 30/05/2002 +1000, Neil Brown wrote:
>On Wednesday May 29, jhill@hrpost.com wrote:
> > >> Then, I just have an init script that runs:
> > >>       /sbin/mdadm -Fs --delay=600 &
> > >Why 600 (10 minutes)?? I would suggest 60seconds for normal operation
> > >and 1 second for testing.
> > Okay, changed. My choice was arbitrary, just assumed it would be
> > reasonable -- I'm moving it on to a heavily loaded production server
> > and the e-mail isn't constantly monitored so I assumed . . . .
>
>You assumed what?  Are you thinking that it wil send mail every $delay
>seconds if there is a problem, and you didn't want to be spammed?

No, I assumed there was no reason to add additional polling. If there is no 
one around to read the e-mail, there seemed no reason to add to the number 
of processes being run on a heavily loaded server. I expect the load of 
polling is miniscule, but it all adds something.


>Mdadm only sends mail when it notices a drive fail, not when it
>notices that a drive is failed.
>i.e. if on one poll the drive is working, and on the next poll the
>drive is not working, then it sends mail saying "The drive just
>failed".
>
>So when you were testing, was "mdadm -Fs" actually running at the
>moment when you simulated a drive failure?

I certainly thought it was, but unfortunately I wasn't simulating. When I 
saw that all of the partitions on sdb had been kicked out of the array, I 
saw that mdadm -Fs was running, but the drive could have failed before a 
reboot when mdadm might not have been running. When you confirmed that my 
configuration was generally correct, I assumed that mdadm wasn't running or 
that I had done something else wrong. When I can get the system running 
again (lilo is hosed; looking at grub for boot raid?), I'll test and 
promise to e-mail back.

Regards,

Jeff Hill

