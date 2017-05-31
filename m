From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/24] uuid,afs: move struct uuid_v1 back into afs
Date: Wed, 31 May 2017 19:25:31 +0100
Message-ID: <31365.1496255131@warthog.procyon.org.uk>
References: <20170531161826.23243-2-hch@lst.de> <20170531161826.23243-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170531161826.23243-2-hch@lst.de>
Content-ID: <31364.1496255131.1@warthog.procyon.org.uk>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-raid.ids

Christoph Hellwig <hch@lst.de> wrote:

> This essentially is a partial revert of commit ff548773
> ("afs: Move UUID struct to linux/uuid.h") and moves struct uuid_v1 back into
> fs/afs as struct afs_uuid.  It however keeps it as big endian structure
> so that we can use the normal uuid generation helpers when casting to/from
> struct afs_uuid.
> 
> The V1 uuid intrepreatation in struct form isn't really useful to the
> rest of the kernel, and not really compatible to it either, so move it
> back to AFS instead of polluting the global uuid.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: David Howells <dhowells@redhat.com>
