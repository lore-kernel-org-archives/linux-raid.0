From: Sven Rudolph <Sven_Rudolph@drewag.de>
Subject: Re: suggestions for inexpensive linux jbod?
Date: Tue, 19 Jun 2007 14:50:06 +0200
Message-ID: <xfkk5u0w1kx.fsf@uxkm53.drewag.de>
References: <f566d2$84u$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f566d2$84u$1@sea.gmane.org> (mikee@mikee.ath.cx's message of
 "Mon, 18 Jun 2007 14:55:31 +0000 (UTC)")
Sender: linux-raid-owner@vger.kernel.org
To: Mike <mikee@mikee.ath.cx>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike <mikee@mikee.ath.cx> writes:

> I'm creating a larger backup server that uses bacula (this
> software works well).

I have no idea how the "Current Implementation Restrictions" (listed
in <http://www.bacula.org/dev-manual/Current_State_Bacula.html>)
affect your backup process. From reading that list I believe that
bacula would not "work well" in my environment (differential
backups). So the following might be very subjective or
environment-dependent too.

> Has anyone used this device or have another suggestion? I'm
> looking at something that will present lots of disk to the
> linux box (fedore core 5, kernel 2.6.20) that I will put
> under md/RAID and LVM. I want to have between 1.5TB and 3.0TB
> of usable space after all the RAID'ing.

As others already suggested you could try to avoid eSATA and SATA port
multipliers by using very large SATA disks and some kind of internal
(non-eSATA) enclosure. I don't count eSATA and SATA port multipliers
as proven and reliable technology, and I avoid it. 

> http://www.newegg.com/Product/Product.aspx?Item=N82E16816133001

Some of these comments seem to confirm my feelings.

When I needed large capacity externel JBODs I started trying SAS JBODs
with SATA disks. I finally bought DELLs MD1000 wit 500GB SATA
disks. The enclosures are connected to LSI Logic SAS controllers
(3442X-R and 3442E-R), and I run Linux SoftRAID (MD) (so this is at
least partially on-topic...) .

Works fine now (after I upgraded the LSI controller firmware).

At least another well-known vendors offers SAS JBODs (with SATA disks)
too (Hewlett-Packard), and some more from small and near-no-name
companies.

	Sven

