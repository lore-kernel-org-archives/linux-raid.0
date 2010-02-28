From: Luca Berra <bluca@comedia.it>
Subject: Re: [mdadm PATCH 0/2] *** mdmon fixes ***
Date: Sun, 28 Feb 2010 18:37:06 +0100
Message-ID: <20100228173706.GA32492@maude.comedia.it>
References: <cover.1267282753.git.bluca@comedia.it> <20100228144123.GA24781@maude.comedia.it> <4B8A8EAF.4000309@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B8A8EAF.4000309@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Feb 28, 2010 at 10:41:35AM -0500, Bill Davidsen wrote:
> Luca Berra wrote:
>> On Sat, Feb 27, 2010 at 04:05:40PM +0100, Luca Berra wrote:
>>> These close a couple of issues with mdmon.
>>> I don't claim to understand all of the code yet, but a cursory look 
>>> leaves me
>>> with the feeling that there are multiple ways it could still fail
>> As foreseen it does actually fail...
>>
>> someone might remember my flaky dual boot system with imsm array
>> it crashed again, badly
>> result
>> mdmon is still running from ALT_RUN, since / is corrupted and cannot be
>> mounted read-write
>> but mdadm command looks for mdmon only in VAR_RUN
>> so a new bunch of patches is due.
>> these apply over the two preceding patches
>
> Rather than adding complexity to the code, would it not be easier to just 

I too feel this code is complex and difficult to get right and maintain.
But my patch set just fixes the problems with the current
implementation, it does not deal with Neil's design choiches.
(well, except last one which opens a way out for people that don't agree
with Neil on the ALT_RUN thing)

> mount a tmpfs on VAR_RUN since it is ephemeral anyway and is not valid 
> across boots? It seems more reasonable to put the exception handling in the 
> system with the exception than in production code.
I don't get your point, are we trying to address the same issue?

If it were me i'd put the socket in /dev and the pid file in /var/run.
Leaving the job of moving state files from initramfs /var/run to real
/var/run to initramfs and init scripts distro specific code.

L.


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
