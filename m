From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: 4 disks in raid 5: 33MB/s read performance?
Date: Tue, 23 May 2006 03:04:24 +0200
Message-ID: <200605230304.24376.Dexter.Filmore@gmx.de>
References: <200605221746.38122.Dexter.Filmore@gmx.de> <44721F84.6060503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44721F84.6060503@redhat.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Brendan Conoboy <blc@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Montag, 22. Mai 2006 22:31 schrieb Brendan Conoboy:
> Dexter Filmore wrote:
> > I just dd'ed a 700MB iso to /dev/null, dd returned 33MB/s.
> > Isn't that a little slow?
> > System is a sil3114 4 port sata 1 controller with 4 samsung spinpoint
> > 250GB, 8MB cache in raid 5 on a Athlon XP 2000+/512MB.
>
> Which SATA driver is being used?  The ata_piix driver, for instance, has
> some of the multi-disk performance penalties as any ATA controller would
> have.
>
> -Brendan (blc@redhat.com)

lsmod lists sata_sil.


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
