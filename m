From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF
	multiplication
Date: Sat, 21 Mar 2009 08:19:26 -0700
Message-ID: <e9c3a7c20903210819r222cd4acwb466d2a11d3388f6@mail.gmail.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
	 <49C26D91.10804@intel.com>
	 <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com>
	 <49C41C1E.4060401@zytor.com> <49C4201A.5060905@emcraft.com>
	 <49C425F5.8060309@intel.com> <49C42F99.5010700@emcraft.com>
	 <49C45159.8020503@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755992AbZCUPT6@vger.kernel.org>
In-Reply-To: <49C45159.8020503@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ilya Yanok <yanok@emcraft.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "Sosnowski, Maciej" <maciej.sosnowski@intel.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

On Fri, Mar 20, 2009 at 7:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Ilya Yanok wrote:
>>
>> async_gen_syndrome() takes element of GF^n(256) and returns result o=
f
>> scalar multiplication of it with constant ({01}, {02}, {02}^2, ...,
>> {02}^n) vector.
>
> For any n (which would mean any GF field)? =A0In that case, that is
> generic scalar-vector multiplication...
>
>> async_pq() takes two vectors from GF^n(256) and returns their scalar
>> multiplication.
>>
>> We need async_pq() function if we want to offload D_x =3D A * (P + P=
_{xy})
>> + B * (Q + Q_{xy}) part of DD recovery and D_x =3D (Q + Q_x) * g^{-x=
} part
>> of DP recovery.
>
>
> No, you don't. =A0A and B (and g^{-x}) are scalars, meaning they're t=
he
> same for every element. =A0This is simpler to do.

Understood.  However this routine also needs to cover the non-generic
and non-constant case where we have a separate coefficient per
element.  I suppose it could scan the coefficient list to see if it
can bypass the 2-dimensional lookup multiply.  At the very least we
need something like the following, because async_pq is really only a
helper routine for async_r6recov.c which knows how to avoid the
synchronous path.

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index da47a29..c1087a2 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -236,6 +236,7 @@ async_pq(struct page **blocks, unsigned int
offset, int src_cnt,
                                 flags, depend_tx, cb_fn, cb_param);
        } else {
                /* run pq synchronously */
+               WARN_ONCE(1, "INFO: async_pq entered synchronous path\n=
");
                if (!blocks[src_cnt+1]) { /* only p requested, just xor=
 */
                        flags |=3D ASYNC_TX_XOR_ZERO_DST;
                        return async_xor(blocks[src_cnt], blocks, offse=
t,
@@ -252,7 +253,6 @@ async_pq(struct page **blocks, unsigned int
offset, int src_cnt,

        return tx;
 }
-EXPORT_SYMBOL_GPL(async_pq);

Looking closer, the only other caller, async_pq_zero_sum, can be
deleted because it has no users.  So async_pq can become a static
routine in async_r6recov.

Thanks,
Dan
