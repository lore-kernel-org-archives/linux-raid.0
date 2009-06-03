From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 08/11] async_tx: add support for asynchronous GF
	multiplication
Date: Wed, 3 Jun 2009 15:11:26 -0700
Message-ID: <e9c3a7c20906031511x5e91b180ya740b6a9cede15a4@mail.gmail.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519010006.4104.70181.stgit@dwillia2-linux.ch.intel.com>
	 <20090522082901.GM11504@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090522082901.GM11504@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 22, 2009 at 1:29 AM, Andre Noll <maan@systemlinux.org> wrote:
> If P is disabled, we could further collapse this loop by also skipping
> sources where the coefficient is zero. Not sure if this would be a win
> though.

It's ok to leave this as an optimization opportunity for the caller.

> Otherwise, this patch looks also very nice.
>
> Thanks
> Andre

Thanks, and the other cleanups were addressed as well.
