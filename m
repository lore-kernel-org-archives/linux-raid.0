From: Luca Berra <bluca@comedia.it>
Subject: Re: Software RAID crash > /dev/md0: Invalid argument
Date: Thu, 16 Sep 2004 15:02:15 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040916130214.GA21249@percy.comedia.it>
References: <52074.10.0.0.151.1095334249.squirrel@10.0.0.151>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52074.10.0.0.151.1095334249.squirrel@10.0.0.151>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 16, 2004 at 07:30:49AM -0400, Scott Bolander wrote:
>I have a Mandrake 10 server with a 40gb boot drive and a three 200gb disk
>software raid 5 array using reiserfs.  A disk went bad; so i have replaced
>it.
>
>Doing the normal things to get it back up don't work:
>
>[root@server root]#raidhotadd /dev/md0 /dev/hdg
....
># cat /etc/raidtab
>raiddev       /dev/md0
>raid-level    5
>chunk-size    128k
>persistent-superblock 1
>nr-raid-disks 3
>    device    /dev/hdg1
>    raid-disk 0
>    device    /dev/hdi1
>    raid-disk 1
>    device    /dev/hdk1
>    raid-disk 2
>
so you replaced the first disk in the array?
raidtools are not capable of handling this.
switch to mdadm
echo "DEVICE partitions" >> /etc/mdadm.conf
mdadm -Esc partitions | grep ARRAY >> /etc/mdadm.conf
mdadm -ARs
mdadm -a /dev/md0 /dev/hdg1
mv /etc/raidtab /etc/raidtab.FOOBAR (this is important)

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
