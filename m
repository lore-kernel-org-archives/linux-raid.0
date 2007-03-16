From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Thu, 15 Mar 2007 22:55:26 -0700
Message-ID: <e9c3a7c20703152255q16563803q33a5893c210634d1@mail.gmail.com>
References: <20070315232956.37DAB353A6C@atlas.denx.de>
	 <17914.10957.754781.940591@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17914.10957.754781.940591@cargo.ozlabs.ibm.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>
Cc: Wolfgang Denk <wd@denx.de>, linuxppc-dev@ozlabs.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/15/07, Paul Mackerras <paulus@samba.org> wrote:
> Wolfgang Denk writes:
>
> > This patch is based on and requires a set of patches posted to the
> > linux-raid mailing list by Dan Williams on 2007-01-23:
>
> Those patches don't seem to be upstream in Linus' tree.  Are they in
> -mm, or is anyone pushing for them to be?
>
They are in -mm (git-md-accel.patch).  I'll review this driver and and
integrate it into my next push to Andrew, along with some further
cleanups.

> Paul.

Dan
