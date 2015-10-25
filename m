From: =?utf-8?Q?Rainer_F=C3=BCgenstein?= <rfu@oudeis.org>
Subject: Re: performance issue (was: Re: kernel: BUG: soft lockup - CPU#1 stuck for 60s!)
Date: Sun, 25 Oct 2015 21:32:58 +0100
Message-ID: <1939397312.20151025213258@oudeis.org>
References: <1092031595.20151015153830@oudeis.org>
  <87si5bvcj4.fsf@notabene.neil.brown.name> <43246687.20151024181541@oudeis.org>
  <20151024213139.5b20dec6@natsu> <16514313.20151025202337@oudeis.org>
  <87a8r6g188.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a8r6g188.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Neil,

Sunday, October 25, 2015, 9:08:39 PM, you wrote:

> Depending on kernel version, it will either work or it won't.
# mdadm --grow /dev/md0 --bitmap=none
mdadm: failed to remove internal bitmap.
md: couldn't update array info. -16

so it doesn't work with this kernel. will upgrade ASAP.

> Either way, it won't cause harm.
famous last words ;-)

> Weekly is a bit more often than I would go for, but why disable it?
because  a  resync  runs  for a bit more than two days. but running it
monthly seems to be a good trade-off.

> That isn't a cronjob started resync. That would say "check" rather than
> 'resync".
> This looks a lot like a resync after an unclean restart.  But with the
> bitmap that should go faster...
you've   got   me  here.  resync  started at 04:22am, the same time as
cron.weekly.  there  was  a  99-raid-something  script  in cron.weekly
(before  I  deleted  it).   system  is  up  for some 2 days before the
resync, so no unclean restart.

> What does "mdadm --examine-bitmap /dev/sdb1" report?

# mdadm --examine-bitmap /dev/sdb1
        Filename : /dev/sdb1
           Magic : 6d746962
         Version : 4
            UUID : 8d3586a2:6adbc781:ee187e6d:500f9b34
          Events : 4945261
  Events Cleared : 4945261
           State : OK
       Chunksize : 4 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 2930265344 (2794.52 GiB 3000.59 GB)
          Bitmap : 715397 bits (chunks), 51 dirty (0.0%)

hth.

-- 
Best regards,
 Rainer                            mailto:rfu@oudeis.org

