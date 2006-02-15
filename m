From: Luca Berra <bluca@comedia.it>
Subject: Re: 2+ raid sets, sata and a missing hd question
Date: Wed, 15 Feb 2006 07:50:28 +0100
Message-ID: <20060215065028.GA2452@percy.comedia.it>
References: <20060215024521.GD8282@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060215024521.GD8282@zip.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 15, 2006 at 01:45:21PM +1100, CaT wrote:
>Seeing as how SATA drives can move around if one removes one from a set
>(ie given sda, sdb, sdc, if sdb was removed sdc drops to sdb) would md6
>come back up without problems if I were to remove either sda or sdb.

if you configured mdadm correctly, you will have no problem :)

hint
echo DEVICE partitions >> /etc/mdadm.conf
mdadm -Esc partitions | grep ARRAY>> /etc/mdadm.conf

>All md partitions are of type fd (Linux raid autodetect).
>
this is surprisingly not at all relevant

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
