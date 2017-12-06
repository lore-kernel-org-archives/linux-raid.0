From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Wed, 6 Dec 2017 13:34:28 +0000
Message-ID: <5A27F1E4.8010109@youngman.org.uk>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru>
 <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
 <CAGx2nv546O5v23Pc2BsWQ=G1xKqiZ66FCqN19MneL9d+YtavTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGx2nv546O5v23Pc2BsWQ=G1xKqiZ66FCqN19MneL9d+YtavTA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Graham <jeremy@doghouse.agency>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/12/17 07:36, Jeremy Graham wrote:
> However mdadm says otherwise
> 
> $ mdadm --examine-badblocks /dev/sd[bcdefg]1
> Bad-blocks list is empty in /dev/sdb1
> No bad-blocks list configured on /dev/sdc1
> No bad-blocks list configured on /dev/sdd1
> Bad-blocks on /dev/sde1:

You'll notice the list is the same for all drives ... so most of those
blocks probably aren't bad, anyway ...

Somehow, it seems to copy the list from one drive, to all the others ...

Cheers,
Wol
