From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: SMART detects pending sectors; take offline?
Date: Thu, 12 Oct 2017 10:52:50 -0500
Message-ID: <CACsGCyS9-K4ZJPKauRZkGFRPd0cvShYLViE87i47=RCY1UkbnQ@mail.gmail.com>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de> <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
 <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org> <8cb4bb54-fadc-30c3-58b9-16e1ca460e83@thelounge.net>
 <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org> <8da0ac59-d83b-671c-b088-8e04b13d685e@turmel.org>
 <afaa1020-652d-911c-16e0-12ed87f2197a@shenkin.org> <7b011b63-4de6-44ec-1f74-9f33c6466795@turmel.org>
 <2ab868eb-3ce3-f01b-ac9e-23358563040c@shenkin.org> <59DF4B80.5010807@youngman.org.uk>
 <ecbbf0ae-3bf8-fe66-79e1-e8207bc09dcc@turmel.org> <5b28b0fc-5e4d-9ac3-9a82-7e36f25c5108@shenkin.org>
 <CAK2H+ecT1Psph5Wm9LrPgYOba6PHKzAs55H1LWiqLD+kaBUQZQ@mail.gmail.com> <CACsGCyQGZxhfT1A_ojXaBRvB4wgNOH7fqqh8afsQksAeGdKmjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCyQGZxhfT1A_ojXaBRvB4wgNOH7fqqh8afsQksAeGdKmjg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Alexander Shenkin <al@shenkin.org>, Phil Turmel <philip@turmel.org>, Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Oct 12, 2017 at 10:16 AM, Edward Kuns <eddie.kuns@gmail.com> wrote:
> All y'all referring to a whole separate kernel module, hangcheck-timer.ko?

Looking back at the original messages:

[4038193.380403] INFO: task md2_raid5:247 blocked for more than 120 seconds.
[4038193.380473]       Not tainted 4.4.0-81-generic #104~14.04.1-Ubuntu
[4038193.380526] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.

it looks like you're dealing with this part of the kernel:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/hung_task.c

The timer is configurable with sysctl and defaults to 120 seconds.
You can check with this command:

$ sudo sysctl kernel.hung_task_timeout_secs
kernel.hung_task_timeout_secs = 120

You can adjust it temporarily (e.g. to make it longer):

$ sudo sysctl -w kernel.hung_task_timeout_secs=150

Or you can adjust it permanently by modifying your sysctl configuration.

It looks like by default it will only warn ten times.  After that it
will stop complaining.  That is also configurable via sysctl.

              Eddie
