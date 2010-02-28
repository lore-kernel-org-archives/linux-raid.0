From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [mdadm PATCH 0/2] *** mdmon fixes ***
Date: Sun, 28 Feb 2010 10:41:35 -0500
Message-ID: <4B8A8EAF.4000309@tmr.com>
References: <cover.1267282753.git.bluca@comedia.it> <20100228144123.GA24781@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100228144123.GA24781@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Luca Berra wrote:
> On Sat, Feb 27, 2010 at 04:05:40PM +0100, Luca Berra wrote:
>> These close a couple of issues with mdmon.
>> I don't claim to understand all of the code yet, but a cursory look 
>> leaves me
>> with the feeling that there are multiple ways it could still fail
> As foreseen it does actually fail...
>
> someone might remember my flaky dual boot system with imsm array
> it crashed again, badly
> result
> mdmon is still running from ALT_RUN, since / is corrupted and cannot be
> mounted read-write
> but mdadm command looks for mdmon only in VAR_RUN
> so a new bunch of patches is due.
> these apply over the two preceding patches

Rather than adding complexity to the code, would it not be easier to 
just mount a tmpfs on VAR_RUN since it is ephemeral anyway and is not 
valid across boots? It seems more reasonable to put the exception 
handling in the system with the exception than in production code.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

