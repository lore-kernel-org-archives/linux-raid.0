From: jin zhencheng <zhenchengjin@gmail.com>
Subject: Re: why md/raid5 dont have bad block remap
Date: Mon, 28 Dec 2009 19:25:15 +0800
Message-ID: <de04351e0912280325g3784dc91g26ee0593a6cef439@mail.gmail.com>
References: <de04351e0912280303m16a6eac6mf0adad8cd48fc188@mail.gmail.com>
	 <alpine.DEB.1.10.0912281204480.27231@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0912281204480.27231@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org, zhenchengjin@163.com, neilb@suse.de
List-Id: linux-raid.ids

I think maybe the disk deal with one write comnd with errror,but  the
disk maybe is also ok,and rewrite to other place or  rewrite again
will be good.

why one write error ,set the whole disk faulty.

Disk if very expensive!



On Mon, Dec 28, 2009 at 7:07 PM, Mikael Abrahamsson <swmike@swm.pp.se> =
wrote:
> On Mon, 28 Dec 2009, jin zhencheng wrote:
>
>> hi ,
>>
>> I think it isn't =A0complicated for raid5 to add bad block remap.
>>
>> "bad block remap" is means that if =A0a bio is written error, we not
>> fauty the disk, and try to write this bio =A0to other place which
>> alloced =A0for bad block remap.
>>
>> i dont =A0know why MD/raid5 add this function ?
>
> What is done is upon read error the parity is read and the block that=
 had a
> read error is calculated and written, and then the unit in question h=
as the
> responsibility of mapping the block/sector as faulty and write it som=
eplace
> else.
>
> Drives which has used up that space and thus can't remap should be re=
placed
> with a working drive, it's obviously faulty.
>
> --
> Mikael Abrahamsson =A0 =A0email: swmike@swm.pp.se
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
