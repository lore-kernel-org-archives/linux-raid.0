From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Need Help with crashed RAID5 (that was rebuilding and then had
 SATA error on another drive)
Date: Tue, 23 Aug 2016 12:36:45 +0100
Message-ID: <57BC354D.4080000@youngman.org.uk>
References: <CADDTLRB9z6J0F6+uO3k-u74qnjZxiagbNLWrg_tP5GSZt-Vd5A@mail.gmail.com>
 <215fd175-65b6-e24b-338f-0c44ae030573@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <215fd175-65b6-e24b-338f-0c44ae030573@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Ben Kamen <benjammin2068@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/08/16 00:06, Adam Goryachev wrote:
> I hope the above is helpful, but really we will need more information
> about your drives before being able to make further suggestions. output
> of lsdrv (google it), smartctl, mdadm --misc --detail /dev/md127 would
> all be helpful.

And while it's probably too late now, read up on mdadm --replace. If
you've got the spare slots, it's much better/safer than physically
pulling a dodgy disk and replacing it.

NB - get the data Adam asked for - and the output of "mdadm --examine
..." and "mdadm --display ..." might well be useful (or might have been
included elsewhere).

Cheers,
Wol
