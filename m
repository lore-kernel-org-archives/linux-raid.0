From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm mail option configuration
Date: Thu, 30 May 2002 08:53:22 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15605.23522.860348.236412@notabene.cse.unsw.edu.au>
References: <message from Jeff Hill on Tuesday May 28>
	<5.1.0.14.0.20020528111927.01f28280@205.233.215.4>
	<5.1.0.14.0.20020529080432.01f32cd8@205.233.215.4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeff Hill on Wednesday May 29
To: Jeff Hill <jhill@hrpost.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 29, jhill@hrpost.com wrote:
> >> Then, I just have an init script that runs:
> >> 
> >>       /sbin/mdadm -Fs --delay=600 &
> >
> >Why 600 (10 minutes)?? I would suggest 60seconds for normal operation
> >and 1 second for testing.
> 
> Okay, changed. My choice was arbitrary, just assumed it would be 
> reasonable -- I'm moving it on to a heavily loaded production server 
> and the e-mail isn't constantly monitored so I assumed . . . .

You assumed what?  Are you thinking that it wil send mail every $delay
seconds if there is a problem, and you didn't want to be spammed?

Mdadm only sends mail when it notices a drive fail, not when it
notices that a drive is failed.
i.e. if on one poll the drive is working, and on the next poll the
drive is not working, then it sends mail saying "The drive just
failed".

So when you were testing, was "mdadm -Fs" actually running at the
moment when you simulated a drive failure?

NeilBrown
