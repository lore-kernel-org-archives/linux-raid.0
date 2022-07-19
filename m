Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FB5C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 11:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiGSL1v (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 07:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiGSL1t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 07:27:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7943E31202
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 04:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658230068; x=1689766068;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=38rrcBieR4tRMXd4o+cXFRSBq4y91qq42EQg6VmCA2k=;
  b=MVYSToK/zMjsx0JQ+NXtVOVp6DSDVZ/8b69fPahAvXe8dHE2ae5dUjib
   bSMtGYzSL8DRGAs1H41NLUPXHqdSLlBEWlW6y3jRF4t13ObTZLi6NblHo
   3ltAN7ptcd5s1yAnDQeMp81Xmnra6AGcMEIeJWHnWilxLma3vhmdn8lZ1
   tztmwmMJBO1TJhhQ5M4jUqVzEJBbPp/y6CVwTwQc3zl+n2/vyCnfgSTvu
   BkMFeBDPy6XMFnzGaxibgaGIakpT1i1eVnnLHjL36Om2HJWXygXVBnAJR
   jAk9+7EA9HR4AMDX9A6J8TFcMnE/WfVg4ElFKb2rBtCABLmCyGXwSjpz8
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="266243451"
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="266243451"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 04:27:48 -0700
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="655722016"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.42.56])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 04:27:44 -0700
Date:   Tue, 19 Jul 2022 13:27:39 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        Jes Sorensen <jsorensen@fb.com>, Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>, Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm] mdadm: Don't open md device for CREATE and
 ASSEMBLE
Message-ID: <20220719132739.00001b94@linux.intel.com>
In-Reply-To: <150ffbb2-9881-9c1f-cc5e-331926b8e423@linux.dev>
References: <20220714223749.17250-1-logang@deltatee.com>
        <150ffbb2-9881-9c1f-cc5e-331926b8e423@linux.dev>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 15 Jul 2022 10:20:26 +0800
Guoqing Jiang <guoqing.jiang@linux.dev> wrote:

> On 7/15/22 6:37 AM, Logan Gunthorpe wrote:
> > The mdadm command tries to open the md device for most modes, first
> > thing, no matter what. When running to create or assemble an array,
> > in most cases, the md device will not exist, the open call will fail
> > and everything will proceed correctly.  
> 
> I guess the BUILD mode doesn't need to create md as well since commit
> 7f91af49ad09 ("Delay creation of array devices for assemble/build/create").
> 
> > However, when running tests, a create or assembly command may be run
> > shortly after stopping an array and the old md device file may still
> > be around. Then, if create_on_open is set in the kernel, a new md
> > device will be created when mdadm does its initial open.
> >
> > When mdadm gets around to creating the new device with the new_array
> > parameter it issues this error:
> >
> >     mdadm: Fail to create md0 when using
> >     /sys/module/md_mod/parameters/new_array, fallback to creation via node
> >
> > This is because an mddev was already created by the kernel with the
> > earlier open() call and thus the new one being created will fail with
> > EEXIST. The mdadm command will still successfully be created due to
> > falling back to the node creation method. However, the error message
> > itself will fail any test that's running it.
> >
> > This issue is a race condition that is very rare, but a recent change
> > in the kernel caused this to happen more frequently: about 1 in 50
> > times.
> >
> > To fix this, don't bother trying to open the md device for CREATE and
> > ASSEMBLE commands, as the file descriptor will never be used anyway
> > even if it is successfully openned.
Hi All,

This is not a fix, it just reduces race probability because file descriptor
will be opened later. I normal environment issue is not likely to happen
because user doesn't create and stop arrays in loop. Issue here
should be resolved in tests, perhaps wait should be sufficient.

I tried to resolve it in the past by adding completion to md driver and force
mdadm --stop command to wait for sysfs clean up but I have never finished it.
IMO it is a better way, wait for device to be fully removed by MD during stop.
Thoughts?

One objection I have here is that error handling is changed, so it could be
harmful change for users. 
> >
> > Side note: it would be nice to disable create_on_open as well to help
> > solve this, but it seems the work for this was never finished. By default,
> > mdadm will create using the old node interface when a name is specified
> > unless the user specifically puts names=yes in a config file, which
> > doesn't seem to be vcreate_on_openery common yet.  
> 
> Hmm, 'create_on_open' is default to true, not sure if there is any side 
> effect
> after change to false.

I'm slowly working on this. The change is not simple, starting from terrible
create_mddev code and char *mddev and char *name rules , ending with hidden
references which we are not aware off (it is common to create temp node and
open mddevice in mdadm) and other references in systemd (because of that, udev
is avoiding to open device).
This also indicate that we should drop partition discover in kernel and use
udev in the future, especially for external metadata (where RO -> RW transition
happens during assembly). But this is a separate problem.

Thanks,
Mariusz
> 
> > Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> > ---
> >   mdadm.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/mdadm.c b/mdadm.c
> > index 56722ed997a2..3b886b5c0639 100644
> > --- a/mdadm.c
> > +++ b/mdadm.c
> > @@ -1347,8 +1347,7 @@ int main(int argc, char *argv[])
> >   	 * an md device.  We check that here and open it.
> >   	 */
> >   
> > -	if (mode == MANAGE || mode == BUILD || mode == CREATE ||
> > -	    mode == GROW || (mode == ASSEMBLE && ! c.scan)) {
> > +	if (mode == MANAGE || mode == BUILD || mode == GROW) {
> >   		if (devs_found < 1) {
> >   			pr_err("an md device must be given in this
> > mode\n"); exit(2);  
> 
> I think it is a reasonable change.
> 
> Thanks,
> Guoqing

