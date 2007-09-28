From: Wolfgang Denk <wd@denx.de>
Subject: Re: Backups w/ rsync
Date: Fri, 28 Sep 2007 16:57:18 +0200
Message-ID: <20070928145718.7320C24769@gemini.denx.de>
References: <46FD1442.70707@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Fri, 28 Sep 2007 10:48:34 EDT."
             <46FD1442.70707@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Dean S. Messing" <deanm@sharplabs.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Bill,

in message <46FD1442.70707@tmr.com> you wrote:
>
> Be aware that rsync is useful for making a *copy* of your files, which 
> isn't always the best backup. If the goal is to preserve data and be 
> able to recover in time of disaster, it's probably not optimal, while if 
> you need frequent access to old or deleted files it's fine.

If you want to do real backups you should use real tools, like bacula
etc.

> Now you can do an incremental (since last full or incremental) or 
> partial (since last full):
> 
>     touch bkup_incr_new
>     timestamp=$(date +%Y%m%d-%T)
>     find /home -cnewer bkup_incr | cpio -o -Hcrc |
>        gzip -3 >/mnt/USBbkup/incr-$timestamp &&
>        mv -f bkup_incr_new bkup_incr
> 
>     timestamp=$(date +%Y%m%d-%T)
>     find /home -cnewer bkup_full  | cpio -o -Hcrc |
>        gzip -3 >/mnt/USBbkup/part-$timestamp

Now have Johnny Loser downloading some stuff, say:

	$ wget -N ftp://ftp.kernel.org/pub/linux/kernel/v2.6/linux-2.6.12.tar.gz

Are you aware that this file will never be backed up by your script?

Also, what about permission / owner changes etc.?

A backup tool should never work based on timestamps alone.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
All he had was nothing, but that was something, and now it  had  been
taken away.                             - Terry Pratchett, _Sourcery_
