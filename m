From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: Question on RAID-5 using ADMA
Date: Fri, 10 Jul 2009 10:51:06 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07B08BB4@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087D1@SDCEXCHANGE01.ad.amcc.com><C804A8D3A7CE4E9B8B6CE8DFD11019B9@m5><8ba75cd82b7938995077e9e157f5b93f.squirrel@neil.brown.name><AC5E1C3367E37D44970B81A6ADD1DA2C07B08866@SDCEXCHANGE01.ad.amcc.com><9a56cb1758c9d7c935da72e9001d8e6b.squirrel@neil.brown.name><AC5E1C3367E37D44970B81A6ADD1DA2C0534ABF6@SDCEXCHANGE01.ad.amcc.com><718d9b820ffe02616088357a59af8737.squirrel@neil.brown.name><AC5E1C3367E37D44970B81A6ADD1DA2C07B089A3@SDCEXCHANGE01.ad.amcc.com> <19030.40729.769761.428308@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <19030.40729.769761.428308@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Guy Watkins <linux-raid@watkins-home.com>, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Neil,
 Thanks for the comments. You are right. Whenever there are no dependent
operations things are fine. I mean you do one task at a time. Like
rebuild, IO to disks or rebuild the failed drive etc. Looks like it a
issue in my ADMA driver which failed to run the dependent operations.
And that is causing silent file-system corruptions. 
Thanks and Regards,
Marri


> 
> Working:
> 1. Using pure SW RAID without ADMA  everything works fine.
> 2. Using ADMA normal operations work fine 
> 3. Using ADMA installing file-system works fine while recover
happening.
> 4. Using ADMA with forcing raid(-f option to mdadm) and io to
> file-system 
>    mounted /dev/md0 while recovery happening works fine.
> 5. Using ADMA wait till recovery finishes and then IO to file-system
> mounted /dev/md0 works fine.

None of these operations actually use the parity data that is
created.  They update it but would not notice if it was wrong.

> 
> 
> Not Working:
> 5. Using ADMA(without  -f option to mdadm) and io(dd command) to
> /dev/md0 which is mounted using 
>    ext3 file-system causing file system errors.

This creates the array in degraded mode so reads will often use the
parity block to reconstruct data.

> 6. Using ADMA with forcing (with -f to mdadm) and io to file-system
> mounted /dev/md0 while rebuild happening(forced a disk failure) causes
> file-system errors.

This also involves degraded mode so the parity is needed.

> 7. Sam as no-6 except without forcing(with out -f option to mdadm)
cause
> file-system errors.

And this.

So either the parity is not being calculated correctly, or the process
for reconstructing a block from parity and other data is not working
correctly.
There is a very good chance that it is both as they are essentially
the same operation.

NeilBrown
