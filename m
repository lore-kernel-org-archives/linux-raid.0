From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Incorrect in-kernel bitmap on raid10
Date: Tue, 28 Apr 2009 16:05:32 +0200
Message-ID: <slrngve39c.8a2.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org>
 <18922.50050.860008.242658@notabene.brown>
 <slrnguupf4.911.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE> wrote:
> Neil Brown <neilb@suse.de> wrote:
>> Could you let me know if that following patch helps?
> Hmmm, it looks like the patch doesn't fully fix it.
> root@darkside:~# echo 0-268275 > /sys/block/md7/md/bitmap_set_bits
> However, in-kernel it should also allocate all pages, but it does not:

*push*

I forgot to clarify the (new) issue:
While now the amount of pages needed in-kernel is calculated correctly,
only the half of them seems to be actually used, even if all bits are
set.


regards
   Mario
-- 
I thought the only thing the internet was good for was porn.  -- Futurama

