From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [md-accel PATCH 03/19] xor: make 'xor_blocks' a library routine for use with async_tx
Date: Wed, 27 Jun 2007 09:13:21 -0700
Message-ID: <e9c3a7c20706270913v64ff933aj11e4bb227268311c@mail.gmail.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
	 <20070627015049.18962.54083.stgit@dwillia2-linux.ch.intel.com>
	 <a781481a0706262339w4c92e295s62a6c041dd1e9666@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a781481a0706262339w4c92e295s62a6c041dd1e9666@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, herbert@gondor.apana.org.au
List-Id: linux-raid.ids

[ trimmed the cc ]

On 6/26/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hi Dan,
>
> [ Minor thing ... ]
>
Not a problem, thanks for taking a look...

> On 6/27/07, Dan Williams <dan.j.williams@intel.com> wrote:
> > The async_tx api tries to use a dma engine for an operation, but will fall
> > back to an optimized software routine otherwise.  Xor support is
> > implemented using the raid5 xor routines.  For organizational purposes this
> > routine is moved to a common area.
>
> This isn't quite crypto code and isn't connected to or through the cryptoapi
> (at least not in this patchset), so I somehow find it misplaced in the crypto/
> directory. If all its users are in drivers/md/ then that would be a
> better place.
> If it is something kernel-global, lib/ sounds more appropriate?
>

True, it isn't quite crypto code, but I gravitated to this location because:
1/ the models are similar, both are general purpose apis with a driver component
2/ there are already some algorithms in the crypto layer that are not
strictly cryptographic like crc32c, and other checksums
3/ having the code under that directory is a reminder to consider
closer integration when adding support for more complex algorithms
like raid6 p+q (at what point does a 'dma-offload' engine become a
'crypto' engine?  at some point they converge)

The hope is that other subsystems beyond md could benefit from offload
engines.  For example, the crc32c calculations in btrfs might be a
good candidate, and kcopyd integration has crossed my mind.

> Satyam

Dan
