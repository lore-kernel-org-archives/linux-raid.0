From: Marco Schindler <marco.schindler@gmail.com>
Subject: Re: frequent disk activity with mdadm-3.3
Date: Fri, 12 Sep 2014 14:15:35 +0200
Message-ID: <BDDC2624-8578-4720-A526-56EFDFBE26C4@gmail.com>
References: <AB305DF4-9DCC-47E1-9B29-130E211D4B4E@gmail.com> <20140912082403.549fc298@notabene.brown> <164CD08B-99CA-4007-855A-7B0561B4EC76@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <164CD08B-99CA-4007-855A-7B0561B4EC76@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ok, that=92s interesting.
the process id is _not_ mdadm daemon and it looks like the spindown its=
elf is triggering the process.

ps ax | grep mdadm
28956 ?        Ss     0:00 mdadm --monitor --scan --daemonise --pid-fil=
e /var/run/mdadm.pid --syslog

grep sda /var/log/messages
Sep 12 13:55:04 alina spindown: sda is now inactive.
Sep 12 13:55:09 alina kernel: mdadm(29737): READ block 3907028992 on sd=
a (8 sectors)
Sep 12 13:55:17 alina kernel: mdadm(29737): READ block 3907029152 on sd=
a (8 sectors)
Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 0 on sda (8 sect=
ors)
Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 8 on sda (8 sect=
ors)
Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 8 on sda (8 sect=
ors)
Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 3907029167 on sd=
a (1 sectors)
Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 3907029166 on sd=
a (1 sectors)
Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 0 on sda (1 sect=
ors)
Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 0 on sda (1 sect=
ors)
Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 3907029152 on sd=
a (8 sectors)
Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 0 on sda (8 sect=
ors)
Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 8 on sda (8 sect=
ors)
Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 8 on sda (8 sect=
ors)
Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 8 on sda (8 sect=
ors)
Sep 12 13:56:12 alina spindown: sda is now active.

here=92s the output of blktrace -d /dev/sda during that time.
https://dl.dropboxusercontent.com/u/3464720/blktrace.tar.bz2

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
