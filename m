From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Alignment of RAID on specific boundary
Date: Tue, 5 Jan 2010 17:46:29 -0800
Message-ID: <4877c76c1001051746q25df0a3dq5d9973dbdc27c583@mail.gmail.com>
References: <7b3edae11001041130n42d053fcpc4923b22278c5671@mail.gmail.com>
	 <4877c76c1001042257h49103054t977de11410eb65c6@mail.gmail.com>
	 <7b3edae11001050544p4f99d7dbq83b72e385151c27@mail.gmail.com>
	 <4B435C2E.4000201@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B435C2E.4000201@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 5, 2010 at 7:35 AM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 05/01/2010 13:44, Khelben Blackstaff wrote:
> [...]
>>> Then my understanding of "data offset" is correct. I need to move
>> this offset from 136 sectors to 512 sectors.
>
> Or move your partition start back by 136 sectors, or use version 0.90=
 or 1.0
> superblocks which have the superblock at the end.
>
> Cheers,
>
> John.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Indeed, that was one route I covered earlier in my message.

However it is still a good idea improvement for mdadm to allow the
user to specify a non-default offset for the start of the
data-partition (for a number of reasons).
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
