From: "D. Lin" <dlbulk-mllr@yahoo.com>
Subject: Re: help: re-add needed after each reboot
Date: Tue, 8 May 2012 09:38:19 -0700
Message-ID: <47a0cb710338a2b5ed91f51622ed928b.squirrel@anguish.kchang.net>
References: <5d1b39dd26f138ed494e779218d21346.squirrel@anguish.kchang.net>
    <20120508064914.18c39f80.458732@notabene.brown>
    <64ab9901e23522f72fbb035f9c15c145.squirrel@anguish>
    <20120508183359.6646fe00.182869@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120508183359.6646fe00.182869@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil.

>
> Thanks for the extra detail.  Everything looks sensible so far.
>
> Can you check the contents of mdadm.conf on the initrd please.
> e.g.
>
>    cd /tmp
>    zcat /boot/initrd | cpio -idv
>    cat etc/mdadm/mdadm.conf
>
> something like that.
>
> NeilBrown
>

content of /boot/initrd.img-3.2.0-24-generic:

; egrep -v '^#|^$' etc/mdadm/mdadm.conf
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
ARRAY /dev/md/0 metadata=1.2 UUID=4195aaa7:0ebd37ce:d4b9481e:1a68f4a8
name=disc:0



