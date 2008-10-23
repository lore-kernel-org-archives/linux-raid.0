From: "Max Waterman" <davidmaxwaterman@fastmail.co.uk>
Subject: backup using raid
Date: Thu, 23 Oct 2008 08:21:24 +0300
Message-ID: <d5fe39840810222221j26fbaa12t17ba8577186e3dbc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Maybe slightly off-topic, sorry.

People often say "raid isn't for backup", but it seems obvious that it
could be, if used in a similar way to tape.

For example, if you have raid1 array, and have an 'extra' spare (is
spare the correct word) on a removable drive, then it can be
constantly creating a copy of the contents of the array which can be
removed by failing the backup spare. If you then have a whole series
of removable drives, then you can implement whatever off-site backup
system you would with tape.

The only gotchas I see are :

1) you might have to adjust the backup system to account for the
different reliability of tape vs disk
2) you might have to carefully pick the time/way you remove the failed
spare. It might be OK to just fail it and hot-remove the disk, but
more likely it'll be necessary to take the system to single-user mode
or even shut it down competely.

Is this a crazy idea? Have people thought of this before? Are there
any other gotchas?

Max.
