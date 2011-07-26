From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdadm.8: Disk coercion with IMSM metadata.
Date: Tue, 26 Jul 2011 15:15:04 +1000
Message-ID: <20110726151504.64f51d10@notabene.brown>
References: <20110713101702.26642.74636.stgit@maciek.naruszewicz>
	<20110714122649.5bd2c91e@notabene.brown>
	<CAA9_cmfxqpqdpQoKAOgNUzuGNQTm3J2fARmht6vp4Umtqdx=bg@mail.gmail.com>
	<8E4BA8CF4D51C54CA1EBF236665899BD52B1D75E30@irsmsx502.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8E4BA8CF4D51C54CA1EBF236665899BD52B1D75E30@irsmsx502.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Naruszewicz, Maciej" <maciej.naruszewicz@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>
List-Id: linux-raid.ids

On Wed, 20 Jul 2011 13:54:17 +0100 "Naruszewicz, Maciej"
<maciej.naruszewicz@intel.com> wrote:

> > -----Original Message-----
> > From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On Behalf Of Dan Williams
> > Sent: Saturday, July 16, 2011 3:10 AM
> > To: NeilBrown
> > Cc: Naruszewicz, Maciej; Neubauer, Wojciech; Kwolek, Adam; Wojcik, Krzysztof; Ciechanowski, Ed; linux-raid@vger.kernel.org
> > Subject: Re: [PATCH] mdadm.8: Disk coercion with IMSM metadata.
> >
> > On Wed, Jul 13, 2011 at 7:26 PM, NeilBrown <neilb@suse.de> wrote:
> >> On Wed, 13 Jul 2011 12:17:02 +0200 "maciej.naruszewicz"
> >> <maciej.naruszewicz@intel.com> wrote:
> >>
> >>> From: maciej.naruszewicz <maciej.naruszewicz@intel.com>
> >>>
> >>> Actual sizes of disks from different producers may vary,
> >>> even though they are claimed to have the same amount of
> >>> space
> >>
> >> Are you sure about this?
> >>
> >> It was my understanding that some industry association has arranged an
> >> agreement so that this does not happen.
> >>
> >> http://www.idema.org/wp-content/plugins/download-monitor/download.php?id=1223
> >>
> >> Do you have actual evidence that different drives from different
> >> manufacturers have similar but not identical sizes?
> >>
> >
> > Hmm, seemed to be a case that needed handling when requirements were
> > being gathered, but perhaps recent drives don't do this any more?
> >
> > Probably the more important part of this commit is that the man page
> > currently says that --size can not be used with container metadata...
> > but now that I have taken two seconds to think about it the light bulb
> > goes off...
> >
> > --size is indeed irrelevant for:
> >    mdadm --create /dev/md/imsm /dev/sd[a-d] -e imsm
> >
> > but my first reading of comment was that:
> >   mdadm --create /dev/md/vol0 /dev/md/imsm --size=$size
> > ...is somehow not valid.
> >
> > How about something like "For CONTAINER metadata --size is valid when
> > creating and growing subarrays, when creating a new container set
> > --size is irrelevant"
> >
> > --
> > Dan
> 
> 
> >
> > Do you have actual evidence that different drives from different
> > manufacturers have similar but not identical sizes?
> >
> 
> I'm afraid I do... For instance I have two disks, first one from Western Digital (model WDC WD2500YS-01SHB1), the second one from Seagate (model ST3250410AS). Both are said to have 250 GB maximum data space- however, the OS doesn't agree. LBA count for WD is 490234752, while for ST it's 488397168- that makes 251000193024 against 250059350016 bytes, nearly 1GB of difference!
> 
> I'm not sure when those disks were produced- maybe newest disks are manufactured according to the IDEMA standard, but this example shows that there definitely are differences.
> 
> >
> > How about something like "For CONTAINER metadata --size is valid when
> > creating and growing subarrays, when creating a new container set
> > --size is irrelevant"
> >
> 
> Indeed, the --size option is irrelevant for containers and valid for subarrays in the container; however, the manpage stated: "This value cannot be used with .B CONTAINER metadata such as DDF and IMSM.". By "this", the author meant that "--grow --size" cannot be used, he / she didn't mean the "--size" alone. This sentence is deleted in the patch I sent earlier and explained more clearly in its description. Of course, we could add the information Dan mentioned to make it even more understandable.

I have applied the following.  I hope it addresses all the issues.

NeilBrown


From 0e1ebe1ada6d7ad30a365443b2c80f64f0b23038 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 26 Jul 2011 15:14:09 +1000
Subject: [PATCH] mdadm.8.in: clarify some issues with --size

- explain it's use in guarding against small replacements
- clarify relationship with containers.

Reported-by: maciej.naruszewicz <maciej.naruszewicz@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/mdadm.8.in b/mdadm.8.in
index 7e8981e..f7b2e9a 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -418,6 +418,14 @@ issued.
 A suffix of 'M' or 'G' can be given to indicate Megabytes or
 Gigabytes respectively.
 
+Sometimes a replacement drive can be a little smaller than the
+original drives though this should be minimised by IDEMA standards.
+Such a replacement drive will be rejected by
+.IR md .
+To guard against this it can be useful to set the initial size
+slightly smaller than the smaller device with the aim that it will
+still be larger than any replacement.
+
 This value can be set with
 .B \-\-grow
 for RAID level 1/4/5/6.  If the array was created with a size smaller
@@ -440,9 +448,10 @@ problems the array can be made bigger again with no loss with another
 .B "\-\-grow \-\-size="
 command.
 
-This value can not be used with
+This value can not be used when creating a
 .B CONTAINER
-metadata such as DDF and IMSM.
+such as with DDF and IMSM metadata, though it perfectly valid when
+creating an array inside a container.
 
 .TP
 .BR \-Z ", " \-\-array\-size=

