From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH 03/11][v3] async_tx: add support for asynchronous RAID6 recovery operations
Date: Wed, 14 Jan 2009 18:06:31 -0700
Message-ID: <e9c3a7c20901141706v17215220s22d973f81369be72@mail.gmail.com>
References: <200901130343.14016.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200901130343.14016.yur@emcraft.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

On Mon, Jan 12, 2009 at 5:43 PM, Yuri Tikhonov <yur@emcraft.com> wrote:
> +       /* (2) Calculate Q+Qxy */
> +       lptrs[0] = ptrs[failb];
> +       lptrs[1] = ptrs[disks-1];
> +       lptrs[2] = NULL;
> +       tx = async_pq(lptrs, NULL, 0, 1, bytes, ASYNC_TX_DEP_ACK,
> +                     tx, NULL, NULL);
> +
> +       /* (3) Calculate P+Pxy */
> +       lptrs[0] = ptrs[faila];
> +       lptrs[1] = ptrs[disks-2];
> +       lptrs[2] = NULL;
> +       tx = async_pq(lptrs, NULL, 0, 1, bytes, ASYNC_TX_DEP_ACK,
> +                     tx, NULL, NULL);
> +

These two calls convinced me that ASYNC_TX_PQ_ZERO_{P,Q} need to go.
A 1-source async_pq operation does not make sense.  These should be:

       /* (2) Calculate Q+Qxy */
       lptrs[0] = ptrs[disks-1];
       lptrs[1] = ptrs[failb];
       tx = async_xor(lptrs[0], lptrs, 0, 2, bytes,
                      ASYNC_TX_XOR_DROP_DST|ASYNC_TX_DEP_ACK, tx, NULL, NULL);

        /* (3) Calculate P+Pxy */
       lptrs[0] = ptrs[disks-2];
       lptrs[1] = ptrs[faila];
       tx = async_xor(lptrs[0], lptrs, 0, 2, bytes,
                      ASYNC_TX_XOR_DROP_DST|ASYNC_TX_DEP_ACK, tx, NULL, NULL);

Regards,
Dan
