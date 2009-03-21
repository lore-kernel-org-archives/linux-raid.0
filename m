From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
Date: Fri, 20 Mar 2009 19:30:49 -0700
Message-ID: <49C45159.8020503@zytor.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com> <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com> <49C41C1E.4060401@zytor.com> <49C4201A.5060905@emcraft.com> <49C425F5.8060309@intel.com> <49C42F99.5010700@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49C42F99.5010700@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ilya Yanok <yanok@emcraft.com>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "Sosnowski, Maciej" <maciej.sosnowski@intel.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

Ilya Yanok wrote:
> 
> async_gen_syndrome() takes element of GF^n(256) and returns result of
> scalar multiplication of it with constant ({01}, {02}, {02}^2, ...,
> {02}^n) vector.

For any n (which would mean any GF field)?  In that case, that is
generic scalar-vector multiplication...

> async_pq() takes two vectors from GF^n(256) and returns their scalar
> multiplication.
> 
> We need async_pq() function if we want to offload D_x = A * (P + P_{xy})
> + B * (Q + Q_{xy}) part of DD recovery and D_x = (Q + Q_x) * g^{-x} part
> of DP recovery.


No, you don't.  A and B (and g^{-x}) are scalars, meaning they're the
same for every element.  This is simpler to do.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

