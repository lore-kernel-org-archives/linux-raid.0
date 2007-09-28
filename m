From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Backups w/ rsync
Date: Fri, 28 Sep 2007 10:48:34 -0400
Message-ID: <46FD1442.70707@tmr.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>	<20070919014919.DF19D10215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>	<20070919174956.9497310209D@medulla.enet.sharplabs.com>	<46F292E2.1090700@tmr.com>	<20070920184738.441FD10208C@medulla.enet.sharplabs.com>	<46F2E159.9030806@msgid.tls.msk.ru>	<20070921005851.44E8910236D@medulla.enet.sharplabs.com>	<87r6knay66.fsf@informatik.uni-tuebingen.de>	<20070925181618.82F47102162@medulla.enet.sharplabs.com>	<87sl521kqh.fsf@informatik.uni-tuebingen.de>	<20070925235016.02F6E1023B9@medulla.enet.sharplabs.com> <87k5qe19p0.fsf@informatik.uni-tuebingen.de> <20070927062317.3CCAB1023E0@medulla.enet.sharplabs.com> <46FB7D2A.1050608@ziu.info> <20070927
 221049.19BE21023EB@medulla.enet.sharplabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070927221049.19BE21023EB@medulla.enet.sharplabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dean S. Messing" <deanm@sharplabs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dean S. Messing wrote:
> It has been some time since I read the rsync man page.  I see that
> there is (among the bazillion and one switches) a "--link-dest=DIR"
> switch which I suppose does what you describe.  I'll have to
> experiment with this and think things through.  Thanks, Michal.
>   

Be aware that rsync is useful for making a *copy* of your files, which 
isn't always the best backup. If the goal is to preserve data and be 
able to recover in time of disaster, it's probably not optimal, while if 
you need frequent access to old or deleted files it's fine.

For example, full and incremental backup methods such as dump and 
restore are usually faster to take and restore than a copy, and allow 
easy incremental backups.

Consider:

    touch bkup_full_new
    timestamp=$(date +%Y%m%d-%T)
    find /home -depth | cpio -o -Hcrc |
       gzip -3 >/mnt/USBbkup/full-$timestamp &&
       mv -f bkup_full_new bkup_full && touch bkup_incr

Now you can do an incremental (since last full or incremental) or 
partial (since last full):

    touch bkup_incr_new
    timestamp=$(date +%Y%m%d-%T)
    find /home -cnewer bkup_incr | cpio -o -Hcrc |
       gzip -3 >/mnt/USBbkup/incr-$timestamp &&
       mv -f bkup_incr_new bkup_incr

    timestamp=$(date +%Y%m%d-%T)
    find /home -cnewer bkup_full  | cpio -o -Hcrc |
       gzip -3 >/mnt/USBbkup/part-$timestamp

The advantage of the incr is that files are smaller, the advantage of 
partial is that you only restore full+part (two total), and the 
advantage of rsync is that deleted files will really be deleted (that's 
why I say it a copy, not a backup).

Hope this is useful.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

