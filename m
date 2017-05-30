From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/22] Revert "afs: Move UUID struct to linux/uuid.h"
Date: Tue, 30 May 2017 11:00:04 +0100
Message-ID: <9377.1496138404@warthog.procyon.org.uk>
References: <20170528102008.30276-2-hch@lst.de> <20170528102008.30276-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170528102008.30276-2-hch@lst.de>
Content-ID: <9376.1496138404.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-raid.ids

Christoph Hellwig <hch@lst.de> wrote:

> This reverts commit ff548773106ec7f8031bc6172e0234bd2a02c19c.
> 
> The V1 uuid intrepreatation in struct form isn't really useful to the
> rest of the kernel, and not really compatible to it either, so move it
> back to AFS instead of polluting the global uuid.h.

This isn't going to work.  You've effectively changed the types of the fields
in the UUID struct from BE to CPU-endian, but you're still calling
generate_random_uuid(), which produces a BE UUID.  You need to leave the
struct members as __beXX or stop using the core UUID routines.

Just move the struct uuid_v1 as-is to the afs headers and rename it to struct
afs_uuid.  You can then leave the (un)marshalling code alone.

David
