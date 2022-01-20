Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8763FC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 20 Jan 2022 08:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240845AbiATISs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Jan 2022 03:18:48 -0500
Received: from mga07.intel.com ([134.134.136.100]:44257 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231338AbiATISq (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Jan 2022 03:18:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642666725; x=1674202725;
  h=from:subject:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Q4HrQsrcA8oZFgPGAf34JQdvKv/rwVYZC6mtLJvb5sU=;
  b=QGChWyQ+pfNdH/Xb2IGkdb4Iyb+E+qsQMCf4yQVX2yF0JVy9V2OIQOhg
   6w++9sSnR1/d+dvfQD/nxdoFZisJv+nRqAzjABfcErt7mnPdZq5E39udg
   M8UUh7AC3nlzAZrPlkHzF32tXph5YDalb8idi5QtNH083EjRI+MeXB4Wh
   UrbqyJVfUe61IfK4nszEuvzCPbJ4wrk8Pz2V8aOiuiPPuX+jtqZACpfLd
   +QPpiuI2skSrDwGsAKzMNQUrbz410Ksfgl60CFlPRF6nzEvCb2/c1XjUV
   hFxrgHaS09fcfMiawMgUeJsCjjsIbIBEKGK9GrSWeHI72spahjbPnc2lH
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10232"; a="308635096"
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="308635096"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 00:18:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="518528097"
Received: from apaszkie-desk.igk.intel.com ([10.102.102.225])
  by orsmga007.jf.intel.com with ESMTP; 20 Jan 2022 00:18:27 -0800
From:   Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: Documentation or support for IMSM caching ????
To:     NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>
References: <164247467024.24166.12368466830982210087@noble.neil.brown.name>
Message-ID: <d24bfcf6-9361-e980-10da-000b4f567142@intel.com>
Date:   Thu, 20 Jan 2022 09:18:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <164247467024.24166.12368466830982210087@noble.neil.brown.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 18.01.2022 03:57, NeilBrown wrote:
> 
> Hi all, particularly friends from Intel....
> 
> Does anyone know anything about the caching support in IMSM soft-raid?
> 
> There are reports of mdadm complaining:
> 
>   mdadm: (IMSM): Unsupported attributes : 3000000
> 
> on some laptops - particularly an HP Spectre which has an SSD and Optane
> memory.  Both devices has IMSM metadata, but mdadm cannot handle it.
> Presumable the Optane is being used as a fast cache in front of the SSD.
> 
> If we had the specs we might be able to get mdadm to handle it.
> Even better would be if Intel could provide some code :-)
> 
> https://bugzilla.suse.com/show_bug.cgi?id=1194355

Hi Neil,

I think that this is Intel SRT, or some derivative of it. Dan Williams
did provide code to enable SRT in kernel and mdadm years ago but it
seems that it did not get past the RFC stage:

https://lore.kernel.org/linux-raid/20140424061756.3187.2633.stgit@viggo.jf.intel.com/
https://lore.kernel.org/linux-raid/20140424071902.4515.19684.stgit@viggo.jf.intel.com/

Regards,
Artur

