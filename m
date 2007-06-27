From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [md-accel PATCH 03/19] xor: make 'xor_blocks' a library routine for use with async_tx
Date: Wed, 27 Jun 2007 12:09:55 +0530
Message-ID: <a781481a0706262339w4c92e295s62a6c041dd1e9666@mail.gmail.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
	 <20070627015049.18962.54083.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760845AbXF0GkL@vger.kernel.org>
In-Reply-To: <20070627015049.18962.54083.stgit@dwillia2-linux.ch.intel.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, christopher.leech@intel.com, shannon.nelson@intel.com, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

Hi Dan,

[ Minor thing ... ]

On 6/27/07, Dan Williams <dan.j.williams@intel.com> wrote:
> The async_tx api tries to use a dma engine for an operation, but will fall
> back to an optimized software routine otherwise.  Xor support is
> implemented using the raid5 xor routines.  For organizational purposes this
> routine is moved to a common area.

This isn't quite crypto code and isn't connected to or through the cryptoapi
(at least not in this patchset), so I somehow find it misplaced in the crypto/
directory. If all its users are in drivers/md/ then that would be a
better place.
If it is something kernel-global, lib/ sounds more appropriate?

Satyam
