From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: Question on RAID-5 using ADMA
Date: Thu, 9 Jul 2009 12:18:27 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07B089A3@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087D1@SDCEXCHANGE01.ad.amcc.com>    <C804A8D3A7CE4E9B8B6CE8DFD11019B9@m5>    <8ba75cd82b7938995077e9e157f5b93f.squirrel@neil.brown.name>    <AC5E1C3367E37D44970B81A6ADD1DA2C07B08866@SDCEXCHANGE01.ad.amcc.com>    <9a56cb1758c9d7c935da72e9001d8e6b.squirrel@neil.brown.name>    <AC5E1C3367E37D44970B81A6ADD1DA2C0534ABF6@SDCEXCHANGE01.ad.amcc.com> <718d9b820ffe02616088357a59af8737.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <718d9b820ffe02616088357a59af8737.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Guy Watkins <linux-raid@watkins-home.com>, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


>No.  You don't have to way for raid-5 rebuilt to complete.

>Can you try disabling the ADMA and run exactly the same test.
>If it works without ADMA, but fails with ADMA, then you know where
>the problem is.


Working:
1. Using pure SW RAID without ADMA  everything works fine.
2. Using ADMA normal operations work fine 
3. Using ADMA installing file-system works fine while recover happening.
4. Using ADMA with forcing raid(-f option to mdadm) and io to
file-system 
   mounted /dev/md0 while recovery happening works fine.
5. Using ADMA wait till recovery finishes and then IO to file-system
mounted /dev/md0 works fine.


Not Working:
5. Using ADMA(without  -f option to mdadm) and io(dd command) to
/dev/md0 which is mounted using 
   ext3 file-system causing file system errors.
6. Using ADMA with forcing (with -f to mdadm) and io to file-system
mounted /dev/md0 while rebuild happening(forced a disk failure) causes
file-system errors.
7. Sam as no-6 except without forcing(with out -f option to mdadm) cause
file-system errors.

Thanks,
Marri
