Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33CBC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jul 2022 07:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiGYHmr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jul 2022 03:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiGYHmq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jul 2022 03:42:46 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D530312A90
        for <linux-raid@vger.kernel.org>; Mon, 25 Jul 2022 00:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658734964; x=1690270964;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JL90vDWrtub0n3tv6QQbmZk0YGzmXczRN19+Iry2uxc=;
  b=l60mUuGK9qy3cUNHH2QSPt/gii1BCJheLy8+Gl3OOG3lypja6f/vgZLa
   1JNEHkQeZer01rpxN0HGGptpNHeyoDCSbiRqaSt1pAq1FmQGykrwHaumj
   YKTYQklkaeWdYY2Hdw1D63RXV9UnOVne7ylD1e4oa9Zcequ2vpX708kaG
   /ic7XOH99Jn+p7xtX1Ob3MTZR+DAwbNi4c8V/CUDYDpYja95D4xvUe2mD
   PLiRCjVXQkR4qJCqDr+rogRGOWVqdkcCMTYImCgVC91BIDJqwP11eGTRH
   cZGtT2qDdIRwfHaWN2Z2qVz8xPx0/TCoLEFA1aAEmkQNiTa9C/BVehK3H
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10418"; a="285185045"
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="285185045"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 00:42:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="658071205"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.43.108])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 00:42:43 -0700
Date:   Mon, 25 Jul 2022 09:42:38 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     "NeilBrown" <neilb@suse.de>
Cc:     "Paul Menzel" <pmenzel@molgen.mpg.de>,
        "Jes Sorensen" <jes@trained-monkey.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH mdadm v2] super1: report truncated device
Message-ID: <20220725094238.000014f0@linux.intel.com>
In-Reply-To: <165855103166.25184.12700264207415054726@noble.neil.brown.name>
References: <165758762945.25184.10396277655117806996@noble.neil.brown.name>
        <cff69e79-d681-c9d6-c719-8b10999a558a@molgen.mpg.de>
        <165768409124.25184.3270769367375387242@noble.neil.brown.name>
        <20220721101907.00002fee@linux.intel.com>
        <165855103166.25184.12700264207415054726@noble.neil.brown.name>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, 23 Jul 2022 14:37:11 +1000
"NeilBrown" <neilb@suse.de> wrote:

> On Thu, 21 Jul 2022, Mariusz Tkaczyk wrote:
> > Hi Neil,
> > 
> > On Wed, 13 Jul 2022 13:48:11 +1000
> > "NeilBrown" <neilb@suse.de> wrote:
> >   
> > > When the metadata is at the start of the device, it is possible that it
> > > describes a device large than the one it is actually stored on.  When
> > > this happens, report it loudly in --examine.
> > > 
> > > ....
> > >    Unused Space : before=1968 sectors, after=-2047 sectors DEVICE TOO
> > > SMALL State : clean TRUNCATED DEVICE
> > > ....  
> > 
> > State : clean TRUNCATED DEVICE is enough. "DEVICE TOO SMALL" seems to be
> > redundant.  
> 
> I needed to change the "Unused Space" line because before the patch the
> "after=" value is close to 2^64.  I needed to make it negative.  But having
> a negative value there is strange so I thought it would be good to
> highlight it and explain why.

Got it, thanks.

> 
> > > 
> > > Also report in --assemble so that the failure which the kernel will
> > > report will be explained.  
> > 
> > Understand but you've added it in load_super1() so it affects all
> > load_super() calls, is it indented? I assume yes but please confirm.   
> 
> Yes, it is intended for all calls to ->load_super() on v1 metadata.
> The test is gated on ->ignore_hw_compat so that it does still look like
> v1.x metadata (so --examine can report on it), but an error results for
> any attempt to use the metadata in an active array.
> 
> ->ignore_hw_compat isn't a perfect fit for the concept, but it is a  
> perfect fit for the desired behaviour.  Maybe we should rethink the name
> for that field.
> 
> > > 
> > > mdadm: Device /dev/sdb is not large enough for data described in
> > > superblock mdadm: no RAID superblock on /dev/sdb
> > > mdadm: /dev/sdb has no superblock - assembly aborted
> > > 
> > > Scenario can be demonstrated as follows:
> > > 
> > > mdadm: Note: this array has metadata at the start and
> > >     may not be suitable as a boot device.  If you plan to
> > >     store '/boot' on this device please ensure that
> > >     your boot-loader understands md/v1.x metadata, or use
> > >     --metadata=0.90
> > > mdadm: Defaulting to version 1.2 metadata
> > > mdadm: array /dev/md/test started.
> > > mdadm: stopped /dev/md/test
> > >    Unused Space : before=1968 sectors, after=-2047 sectors DEVICE TOO
> > > SMALL State : clean TRUNCATED DEVICE
> > >    Unused Space : before=1968 sectors, after=-2047 sectors DEVICE TOO
> > > SMALL State : clean TRUNCATED DEVICE
> > > 
> > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > ---
> > >  super1.c | 34 +++++++++++++++++++++++++++-------
> > >  1 file changed, 27 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/super1.c b/super1.c
> > > index 71af860c0e3e..4d8dba8a5a44 100644
> > > --- a/super1.c
> > > +++ b/super1.c
> > > @@ -406,12 +406,18 @@ static void examine_super1(struct supertype *st,
> > > char *homehost) 
> > >  	st->ss->getinfo_super(st, &info, NULL);
> > >  	if (info.space_after != 1 &&
> > > -	    !(__le32_to_cpu(sb->feature_map) & MD_FEATURE_NEW_OFFSET))
> > > -		printf("   Unused Space : before=%llu sectors, after=%llu
> > > sectors\n",
> > > -		       info.space_before, info.space_after);
> > > -
> > > -	printf("          State : %s\n",
> > > -	       (__le64_to_cpu(sb->resync_offset)+1)? "active":"clean");
> > > +	    !(__le32_to_cpu(sb->feature_map) & MD_FEATURE_NEW_OFFSET)) {
> > > +		printf("   Unused Space : before=%llu sectors, ",
> > > +		       info.space_before);
> > > +		if (info.space_after < INT64_MAX)
> > > +			printf("after=%llu sectors\n", info.space_after);
> > > +		else
> > > +			printf("after=-%llu sectors DEVICE TOO SMALL\n",
> > > +			       UINT64_MAX - info.space_after);  
> > As above, for me this else here is not necessary.  
> 
> The change to report a negative is necessary.
> 
> >   
> > > +	}
> > > +	printf("          State : %s%s\n",
> > > +	       (__le64_to_cpu(sb->resync_offset)+1)? "active":"clean",

Please add space before '?' and between and after ':' (same as below).
> > > +	       info.space_after > INT64_MAX ? " TRUNCATED DEVICE" : "");
> > >  
> > 
> > Could you use standard if instruction to make the code more readable? We are
> > avoiding ternary operators if possible now.  
> 
> I could.  I don't want to.
> I think the code is quite readable.  Putting a space before the first
> '?' would help, as might lining up the two '?'.

Please fix formatting and I'm fine with that. In this case ternary if is
reasonable.
> 
> >   
> > >  	printf("    Device UUID : ");
> > >  	for (i=0; i<16; i++) {
> > >  		if ((i&3)==0 && i != 0)
> > > @@ -2206,6 +2212,7 @@ static int load_super1(struct supertype *st, int fd,
> > > char *devname) tst.ss = &super1;
> > >  		for (tst.minor_version = 0; tst.minor_version <= 2;
> > >  		     tst.minor_version++) {
> > > +			tst.ignore_hw_compat = st->ignore_hw_compat;
> > >  			switch(load_super1(&tst, fd, devname)) {
> > >  			case 0: super = tst.sb;
> > >  				if (bestvers == -1 ||
> > > @@ -2312,7 +2319,6 @@ static int load_super1(struct supertype *st, int fd,
> > > char *devname) free(super);
> > >  		return 2;
> > >  	}
> > > -	st->sb = super;
> > >  
> > >  	bsb = (struct bitmap_super_s *)(((char*)super)+MAX_SB_SIZE);
> > >  
> > > @@ -2322,6 +2328,20 @@ static int load_super1(struct supertype *st, int
> > > fd, char *devname) if (st->data_offset == INVALID_SECTORS)
> > >  		st->data_offset = __le64_to_cpu(super->data_offset);
> > >  
> > > +	if (st->minor_version >= 1 &&
> > > +	    st->ignore_hw_compat == 0 &&
> > > +	    (__le64_to_cpu(super->data_offset) +
> > > +	     __le64_to_cpu(super->size) > dsize ||
> > > +	     __le64_to_cpu(super->data_offset) +
> > > +	     __le64_to_cpu(super->data_size) > dsize)) {
> > > +		if (devname)
> > > +			pr_err("Device %s is not large enough for data
> > > described in superblock\n",
> > > +			       devname);  
> > 
> > why not just:
> > if (__le64_to_cpu(super->data_offset) + __le64_to_cpu(super->data_size) >
> > dsize) from my understanding, only this check matters.  
> 
> It seemed safest to test both.  I don't remember the difference between
> ->size and ->data_size.  In getinfo_super1() we have  
> 
> 	if (info->array.level <= 0)
> 		data_size = __le64_to_cpu(sb->data_size);
> 	else
> 		data_size = __le64_to_cpu(sb->size);
> 
> which suggests that either could be relevant.
> I guess ->size should always be less than ->data_size.  But
> load_super1() doesn't check that, so it isn't safe to assume it.

Honestly, I don't understand why but I didn't realize that you are checking two
different fields (size and data_size). I focused on understanding what is going
on  here, and didn't catch difference in variables (because data_offset and
data_size have similar prefix).
For me, something like:

unsigned long long _size;
if (st->minor_version >= 1 && st->ignore_hw_compat == 0)
    _size= __le64_to_cpu(super->size);
else
    _size= __le64_to_cpu(super->data_size);

if (__le64_to_cpu(super->data_offset) + _size > dsize)
{....}

is more readable because I don't need to analyze complex if to get the
difference. Also, I removed doubled __le64_to_cpu(super->data_offset).
Could you refactor this part?

Thanks,
Mariusz
