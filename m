From: Ole Tange <tange@binf.ku.dk>
Subject: Re: SpareMissing event, but spare not missing
Date: Thu, 16 May 2013 10:02:04 +0200
Message-ID: <CANU9nTkwe2H-xB3Zo6zcACv2UbqXuzVapUqZBzOfkiaBOLBXCw@mail.gmail.com>
References: <CANU9nTm_TpyomQVSHNtQHVNMwRNKrZjs=YUv5PYmKoTV61Gvsg@mail.gmail.com>
 <11898309.36.1368631469489.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11898309.36.1368631469489.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 15, 2013 at 5:24 PM, Roy Sigurd Karlsbakk <roy@karlsbakk.ne=
t> wrote:
> - Anything in dmesg?

Nope.

> - What does /etc/mdadm/mdadm.conf say?

Good call. It was generated automatically when there were 4 spares, so
it had 'spares=3D4' in it. And there are no longer 4 spares, which can
explain the message.

I have now removed the 'spares=3D4' and restarted mdadm --monitor.
Tomorrow we will see if that fixed it.

> Also, using 20 disks in a single RAID-6 gives you the same chances fo=
r a parity+1 error (or worse) as compared to 10 drives in RAID-5. I wou=
ld really recommend using smaller (8+2?) RAID-6 sets and rather use LVM=
 on top (which you may be doing already?). Even with proper cooling and=
 enterprise drives, 20 drives in a single RAID-6 is asking for trouble=85

We are migrating to a RAID60 2x10.

The major reason for this is the time to rebuild: To rebuild one of
the 19 drives we have to read remaining 19 drives during which the
performance will be slower. On our system rebuild would take at least
4 days.


/Ole
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
