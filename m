From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm PATCH 0/2] two 3.1.3 regression fixes (incremental
 assembly)
Date: Thu, 12 Aug 2010 11:47:12 +1000
Message-ID: <20100812114712.359a5033@notabene>
References: <20100810164551.26691.17944.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100810164551.26691.17944.stgit@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 10 Aug 2010 09:46:38 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Hi Neil,
> 
> The mdadm -I --no-degraded option needs to be acceptable for some time
> to come, do you have a policy for when deprecated options can be scheduled for
> removal?  The error code for -I shall be zero in the 'not enough' case to
> restore the correct and established pre-3.1.3 behavior.

No, I don't have a policy.  Given that this was introduced fairly recently I
don't feel a need to keep it around for very long.  I'd probably be happy to
see in go in 12 months, or with mdadm-v4.0, whichever is first.

Thanks,
NeilBrown


