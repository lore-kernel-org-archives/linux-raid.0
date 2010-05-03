From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID5
Date: Mon, 3 May 2010 07:51:01 +0200
Message-ID: <20100503055101.GB25863@maude.comedia.it>
References: <s2q6b16fb4c1004182046x5464351m861ccaf9850f33df@mail.gmail.com> <j2k4877c76c1004182121w3edcf996x2ee8ee0eca398985@mail.gmail.com> <4BCEFE66.6010607@tmr.com> <l2g4877c76c1004211243n6dfa55pfee322db20ba6f08@mail.gmail.com> <4BD1AE0C.2040003@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BD1AE0C.2040003@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 23, 2010 at 06:26:20PM +0400, Michael Tokarev wrote:
>This is most likely due to read-modify-write cycle which is present on
>lvm-on-raid[456] if the number of data drives is not a power of two.
>LVM requires the block size to be a power of two, so if you can't fit
>some number of LVM blocks on whole raid stripe size your write speed
>is expected to be ~3 times worse...
uh?
PE size != block size.
PE size is not used for io, it is only used for laying out data.
It will influence data alignment, but i believe the issue may be
bypassed if we make PE size == chunk_size and do all creation/extension
of LV in multiple of data_disks, the resulting device-mapper tables
should be aligned.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
