From: keld@keldix.com
Subject: Re: recover linear mode raid howto
Date: Tue, 26 Jun 2012 19:38:56 +0200
Message-ID: <20120626173856.GA23965@www5.open-std.org>
References: <213B51F00051AE48A9F0E112880177178F7A55@Delta.sc.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <213B51F00051AE48A9F0E112880177178F7A55@Delta.sc.local>
Sender: linux-raid-owner@vger.kernel.org
To: ???????? ????????? ?????????? <a.kostyrev@serverc.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 26, 2012 at 05:26:53PM +1100, ???????? ????????? ?????????? wrote:
> Hello!
> I'm trying to figure out how one can recover from linear mode crash.
> I'm aware that from this type of mode I can recover only part of data, there's no redundancy in linear mode and that's ok for me.
> I'm ok with part of it.
> 
> so far I'm trying to get it work in VM for now.
> 
> 
> I've added two 50M disks to my VM.
> 
> and partiotioned them like this:
> Device Boot      Start     End      Blocks  Id  System
> /dev/vdb1        2048      102399   50176   fd  Linux raid autodetect
> Device Boot      Start     End      Blocks  Id  System
> /dev/vdc1        2048      102399   50176   fd  Linux raid autodetect
> 
> mdadm --create --verbose /dev/md0 --level linear --raid-disks 2 /dev/vdb1 /dev/vdc1
> mdadm --detail --scan >> /etc/mdadm/mdadm.conf
> 
> mkfs.xfs /dev/md0 
> mount /dev/md0 /mnt/linear/
> 
> mkdir /mnt/linear/etc
> mkdir /mnt/linear/etc2
> mkdir /mnt/linear/etc3
> 
> filled with some data
> cp -r /etc/* /mnt/linear/etc/
> cp -r /etc/* /mnt/linear/etc2/
> cp -r /etc/* /mnt/linear/etc3/
> 
> df -h /dev/md0
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md0               92M   69M   23M  76% /mnt/linear
> 
> then I remove one disk from my VM
> 
> umount /mnt/linear
> mdadm --stop /dev/md0
> 
> I've added another clear disk image 50M.
> 
> make partitions on new disk
> sfdisk -d /dev/vdb | sfdisk /dev/vdc
> 
> how should I proceed ?
> 
> thanks a lot!


Thaks for the effort. Maybe, when you have found a robust way to do it, then
you could add the description to our wiki, at https://raid.wiki.kernel.org/

(BTW, the wiki looks like it is open again for editing).

best regards
keld
