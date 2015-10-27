From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Fwd: Replacing a RAID1 drive that has not failed.
Date: Mon, 26 Oct 2015 19:41:25 -0500
Message-ID: <CACsGCyT1=HW=hofbLs-Zb_=sdVL-higdSOJbDmAmpVTd1=iiZA@mail.gmail.com>
References: <n0mbam$gmk$1@ger.gmane.org>
	<CACsGCyTM_J2+_oJm0rUsZvuF0AXXu6xX572F4HP+OGsjP_AvfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCyTM_J2+_oJm0rUsZvuF0AXXu6xX572F4HP+OGsjP_AvfQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 26, 2015 at 6:00 PM, Doug Herr <gmane@wombatz.com> wrote:
> I think it might be time to replace one or both of my RAID 1 drives. [snip]
> I recently experimented with adding a third partition to my swap raid
> partition and that went very well, so I was thinking that this would
> provide a safer method to replace one drive compared to failing it and
> then replacing it.
> [snip]

I tried basically the procedure you described, based on Internet
research, to replace a working but suspect drive in a RAID.  I ran
into problems.  FWIW, my metadata format is 1.2.  You can see the
thread at  http://marc.info/?l=linux-raid&m=143668094907891&w=2
although the most pertinent EMail is the first response
http://marc.info/?l=linux-raid&m=143670871711935&w=2

I suppose it's possible that you might get different advice since
you're doing RAID 1 and I was doing RAID 5.  I'm not an expert.  I
just wanted to warn you that I ran into trouble basically doing what
you propose.  The advice I got was that I shouldn't grow and shrink to
replace a disk.  There's a --replace option for that.  That'll remove
a few of your steps, simplify and speed up the process, and remove
risk.  Hope this helps.  Hopefully someone who knows a lot more than I
do will also speak up.  Good luck.

              Eddie
