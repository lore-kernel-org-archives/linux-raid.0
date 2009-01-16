From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re[2]: [PATCH 03/11][v3] async_tx: add support for asynchronous RAID6 recovery operations
Date: Fri, 16 Jan 2009 14:51:42 +0300
Message-ID: <498243073.20090116145142@emcraft.com>
References: <200901130343.14016.yur@emcraft.com> <e9c3a7c20901141706v17215220s22d973f81369be72@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20901141706v17215220s22d973f81369be72@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids



On Thursday, January 15, 2009 Dan Williams wrote:

> On Mon, Jan 12, 2009 at 5:43 PM, Yuri Tikhonov <yur@emcraft.com> wrote:
>> +       /* (2) Calculate Q+Qxy */
>> +       lptrs[0] = ptrs[failb];
>> +       lptrs[1] = ptrs[disks-1];
>> +       lptrs[2] = NULL;
>> +       tx = async_pq(lptrs, NULL, 0, 1, bytes, ASYNC_TX_DEP_ACK,
>> +                     tx, NULL, NULL);
>> +
>> +       /* (3) Calculate P+Pxy */
>> +       lptrs[0] = ptrs[faila];
>> +       lptrs[1] = ptrs[disks-2];
>> +       lptrs[2] = NULL;
>> +       tx = async_pq(lptrs, NULL, 0, 1, bytes, ASYNC_TX_DEP_ACK,
>> +                     tx, NULL, NULL);
>> +

> These two calls convinced me that ASYNC_TX_PQ_ZERO_{P,Q} need to go.
> A 1-source async_pq operation does not make sense.

 Another source is hidden under not-set ASYNC_TX_PQ_ZERO_{P,Q} :) 
Though, I agree, this looks rather misleading.

>   These should be:

>        /* (2) Calculate Q+Qxy */
>        lptrs[0] = ptrs[disks-1];
>        lptrs[1] = ptrs[failb];
>        tx = async_xor(lptrs[0], lptrs, 0, 2, bytes,
>                       ASYNC_TX_XOR_DROP_DST|ASYNC_TX_DEP_ACK, tx, NULL, NULL);

>         /* (3) Calculate P+Pxy */
>        lptrs[0] = ptrs[disks-2];
>        lptrs[1] = ptrs[faila];
>        tx = async_xor(lptrs[0], lptrs, 0, 2, bytes,
>                       ASYNC_TX_XOR_DROP_DST|ASYNC_TX_DEP_ACK, tx, NULL, NULL);


 The reason why I preferred to use async_pq() instead of async_xor() 
here is to maximize the chance that the whole D+D recovery operation 
will be handled in one ADMA device, i.e. without channels switch and 
the latency introduced because of that.

 So, if we'll decide to stay with ASYNC_TX_PQ_ZERO_{P,Q}, then this 
should be probably kept unchanged, but if we'll get rid of 
ASYNC_TX_PQ_ZERO_{P,Q}, then, obviously, we'll have to use 
async_xor()s here as you suggest.


 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

