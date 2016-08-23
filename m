From: Ben <benjammin2068@gmail.com>
Subject: Re: Need Help with crashed RAID5 (that was rebuilding and then had
 SATA error on another drive)
Date: Tue, 23 Aug 2016 10:44:42 -0500
Message-ID: <57BC6F6A.5090809@gmail.com>
References: <CADDTLRB9z6J0F6+uO3k-u74qnjZxiagbNLWrg_tP5GSZt-Vd5A@mail.gmail.com>
 <215fd175-65b6-e24b-338f-0c44ae030573@websitemanagers.com.au>
 <57BC354D.4080000@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57BC354D.4080000@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/23/2016 6:36 AM, Wols Lists wrote:
> On 23/08/16 00:06, Adam Goryachev wrote:
>
> And while it's probably too late now, read up on mdadm --replace. If
> you've got the spare slots, it's much better/safer than physically
> pulling a dodgy disk and replacing it.
>
> NB - get the data Adam asked for - and the output of "mdadm --examine
> ..." and "mdadm --display ..." might well be useful (or might have been
> included elsewhere).

hi there!

Thanks -- Adam mentioned and yea, it's too late but I have it for next time.

the vast bulk of the data on the array is duplicated to another NAS -- so it's not the end of the world.

Adam helped me get the array back online so I can do some things to it (like some 'nice to have' files).. it's staying reasonably in sync when it craps out...

so hopefully soon I'll have it resolved.

but will probably switch to a RAID6 soon down the road.

Thanks for the help,

  -Ben
