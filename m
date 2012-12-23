From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Disk speed comparison
Date: Sat, 22 Dec 2012 18:11:19 -0600
Message-ID: <CAAMCDedNEzGTke4v_hMr7QGrcBXqnaKqoNDqTyReOXXQXiC3Ow@mail.gmail.com>
References: <CAAMCDec1PB8eZoF7FdHdRS5VVKFmnN+mUJwq1+9mE6HAtoxR0w@mail.gmail.com>
 <33315059.11.1356199662253.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <33315059.11.1356199662253.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Dec 22, 2012 at 12:07 PM, Roy Sigurd Karlsbakk
<roy@karlsbakk.net> wrote:
> WD2001FASS

From the stuff the wd runs max 138 and the hds runs max 163...assuming
you are using
the outside tracks on both, inside tracks can be 2x slower (less data).

I would make sure they are both running the same sata speed, if a
sata/ide port gets errors sometimes
it drops the speed and retries at the slower speed, and generally once
it throttles down a reboot is
required to undo it.

look at hdparm/sdparm (which works depends on distro) and smartctl to
see what you can pull about
the disks.
