From: Michael <michael@kmaclub.com>
Subject: Re: Problems with software raid - all mine I am sure
Date: Tue, 27 Feb 2007 09:54:14 -0700
Message-ID: <45E46236.9090109@kmaclub.com>
References: <45E31D6A.4040805@kmaclub.com> <20070227113819.GH19607@sillage.bis.pasteur.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070227113819.GH19607@sillage.bis.pasteur.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Tru Huynh <tru@pasteur.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tru Huynh wrote:
>
> ... 
> <mix knoppix and fc6 >
>
> Why don't you do everything from the text/gui installation of fc6
> instead of swapping distributions?
>
> You can do everything you have said within the fc6 installer:
> http://fedora.redhat.com/docs/install-guide/fc6/en/sn-disk-druid.html
> boot in raid1 on sda1/sdb1
> swap,/ and /export as raid5 on sd{abcd}{234}
> ...
>
>   
I don't want to do an install - I already have a working machine and 
don't want to loose all of my changes and configuration.  I did try this 
as well but was unable to figure out how to break out of the installer 
after the disks were partitioned/formatted so I could just do a restore.

Also, I need to do a restore once the disks are assembled into the 
raid.  If I plug my external disk in and boot it becomes sda which 
screws up the raid.  If I plug in later in rescue mode, it isn't 
autodetected and I was unable to get the right modules loaded.  That is 
why I tried knoppix.

> you don't have to use LVM.
>
>   

I am not using LVM.  However, LVM seems to latch onto sda at boot time 
and keeps it busy which causes problems.

I am just surprised this is so difficult. 

Michael



