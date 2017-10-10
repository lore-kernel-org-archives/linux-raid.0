From: Phil Turmel <philip@turmel.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Tue, 10 Oct 2017 08:55:29 -0400
Message-ID: <8da0ac59-d83b-671c-b088-8e04b13d685e@turmel.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de>
 <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
 <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org>
 <8cb4bb54-fadc-30c3-58b9-16e1ca460e83@thelounge.net>
 <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, Reindl Harald <h.reindl@thelounge.net>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Alex,

On 10/10/2017 05:56 AM, Alexander Shenkin wrote:

> Thanks Reindl.  Here's what I have installed (no evidence of raid-check
> available on my system):
> 
> $ cat /etc/cron.d/mdadm
> 57 0 * * 0 root if [ -x /usr/share/mdadm/checkarray ] && [ $(date +\%d)
> -le 7 ]; then /usr/share/mdadm/checkarray --cron --all --idle --quiet; fi
> 

This is *really* good news.  If this has been running once a month as
shown, and you've already noted that you are dealing properly with
timeout mismatch, then your arrays are in fact reasonably scrubbed.

Which means the pending sector found by a smartctl background scan is
likely in a non-array data area.  And if not, the next scrub will fix
it.  You can run checkarray yourself if you don't want to wait.

>>> Is this something I should run now?  I figure it's a bad idea to push
>>> an array that is starting to degrade... haven't had a chance to
>>> replace the drive yet, but will get to it this week.  Probably best
>>> to start the scrubbing routines once I have 4 good drives in there I
>>> figure...
>>
>> NO - never put any load you can avoid on degraded arrays
> 
> thanks, i won't.

If I read your OP correctly, your array is *not* degraded -- it just has
a pending URE on one drive.  You are still redundant, and your system is
scrubbing once a month.  FWIW, I don't replace drives just for
pending sectors -- they are expected occasionally per drive specs.  So
long as check scrubs regularly complete, I replace drives when actual
relocations hit double digits.

You are fine.  Your array is fine.  Long timeouts can cause application
timeouts and user freak-outs, so your Seagates are less than ideal, but
your system is *fine*.

Consider using the new drive to convert to raid6.  If you have other
reasons to stay with raid5, then add it as as spare, then use mdadm's
--replace operation to swap out the drive with the pending sector.

Phil
