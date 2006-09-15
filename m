From: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 09/19] dmaengine: reduce backend address permutations
Date: Fri, 15 Sep 2006 09:46:38 -0500
Message-ID: <20060915094638.7eded22f@localhost.localdomain>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>
	<20060911231823.4737.95500.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060911231823.4737.95500.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids

Hi,

On Mon, 11 Sep 2006 16:18:23 -0700 Dan Williams <dan.j.williams@intel.com> wrote:

> From: Dan Williams <dan.j.williams@intel.com>
> 
> Change the backend dma driver API to accept a 'union dmaengine_addr'.  The
> intent is to be able to support a wide range of frontend address type
> permutations without needing an equal number of function type permutations
> on the backend.

Please do the cleanup of existing code before you apply new function.
Earlier patches in this series added code that you're modifying here.
If you modify the existing code first it's less churn for everyone to
review.


Thanks,

Olof
