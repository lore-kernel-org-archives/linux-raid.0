From: Luca Berra <bluca@comedia.it>
Subject: Re: Fixes for SLES 8.0 s/w RAID --- mkraid, yast2 or md related
Date: Thu, 16 Sep 2004 18:15:33 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040916161533.GC21249@percy.comedia.it>
References: <20040916132718.GS26852@marowsky-bree.de> <20040916151021.81563.qmail@web90005.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040916151021.81563.qmail@web90005.mail.scd.yahoo.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 16, 2004 at 08:10:21AM -0700, Nirmal B wrote:
>Just some background info now. I am building an HP MC/
>ServiceGuard cluster of two servers (ProLiant)
>connected to an enterprise virtual array (EVA 3000)
>which is used as shared storage. The cluster formation
>is fine but I am unable to activate the shared storage
>because of issues with software RAID implementation of

sorry to interrupt but i have a few notes to add.
you don't give detailed info on your setup, still,
if you are using the md driver for the shared storage under HP
ServiceGuard, you should reread chapter 5 of the fine manual.

>The partitions are of type 'fd' and the arrays are
don't they should be type 0x83
>started at boot time. But the first entry of the SCSI
don't, they should be started by ServiceGuard
>disk mentioned in the /etc/raidtab file (for eg. if
you should use $SGCONF/raidtab.sg

for other issues, please follow Lars suggestion and open a support call.

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
