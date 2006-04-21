From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: replace disk in raid5 without linux noticing?
Date: Fri, 21 Apr 2006 20:23:30 +0200
Message-ID: <200604212023.30855.Dexter.Filmore@gmx.de>
References: <200604191631.04305.Dexter.Filmore@gmx.de> <e3edb0fa0604190931i1160d94eo829ba17943b0c5eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e3edb0fa0604190931i1160d94eo829ba17943b0c5eb@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Shai <shaibn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Mittwoch, 19. April 2006 18:31 schrieb Shai:
> On 4/19/06, Dexter Filmore <Dexter.Filmore@gmx.de> wrote:
> > Let's say a disk in an array starts yielding smart errors but is still
> > functional.
> > So instead of waiting for it to fail completely and start a sync and
> > stress the other disks, could I clone that disk to a fresh one, put the
> > array offline and replace the disk?
>
> Hi,
>
> Why can't you just mark that drive as failed, remove it and hotadd a
> new drive to replace the failed drive?

Well, resync stresses the other disks a lot. If that can be avoided, I'd 
rather do so.

-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
