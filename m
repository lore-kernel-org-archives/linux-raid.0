From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re: Array Power Management
Date: Mon, 7 Sep 2009 07:02:17 -0700 (PDT)
Message-ID: <262927.41980.qm@web55804.mail.re3.yahoo.com>
References: <342934.45030.qm@web51305.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <342934.45030.qm@web51305.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com, "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> This is interesting.. I have the -S set for all my 6 drives in the array and have for some time and I do not unmount the array - access wakes the drives up - usually most of them, sometimes only a few of them.

I wasn't sure that that would be a safe thing to do, and not finding anything via google, I though it was best to ask. I've also been looking at sdparm, which seems to be more in tune for SATA drives, rather than PATA ones.


> The only part of this that has caused me any problems are scheduled smartd checks - these cause timeout errors.

How are you scheduling the checks? via cron? It's not something I do at the moment, but probably should - I'd rather get some notification that a drive is going to fail, rather than have to deal with a failed one. I'd think about putting an sdparm --command=start /dev/sd[c-p] or whatever to start the disks up before doing a check (and maybe a command=stop when done). I'm guessing that it would be OK to use hdparm to set the spin down timeout, and then sdparm to start the disk spinning again (I can't find an sdparm option to set the timeout)

> In my case, if they are not used for 30mins; they wont be used for several hours.

This is usually the situation I am in as well, certainly my media server... It usually get used for 3 or 4 hours, then nothing much till the next day.


Graham



      
