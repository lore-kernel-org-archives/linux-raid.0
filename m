From: Luca Berra <bluca@comedia.it>
Subject: Re: Autodetect problem w/ SCSI
Date: Wed, 2 Jun 2004 14:02:45 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040602120244.GB10476@percy.comedia.it>
References: <20040601183951.GA22078@bluff> <20040601204516.24507.qmail@web61004.mail.yahoo.com> <20040602104017.GA2189@bluff>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040602104017.GA2189@bluff>
To: Linux Raid List <linux-raid@vger.kernel.org>
Cc: M K <maheshext3@yahoo.com>
List-Id: linux-raid.ids

On Wed, Jun 02, 2004 at 12:40:17PM +0200, Sandro Dentella wrote:
>I moved the array w/ on a different machine w/ a different controller (same
>model:adaptec 2940 pro ultra scsi) but the behaviour is the same: the array
>is not autodetected. The same kernel autodetects ide disks.
>
>Please tell me: is there some setting, peculiar to SCSI autodetect, I'm
>ignoring? 

it should not
for autodetect to work you would have to load the low-lever controller
driver and the sd driver before autodetect

can you show some evidence (eg. dmesg)

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
