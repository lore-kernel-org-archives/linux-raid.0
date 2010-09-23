From: Kaizaad Bilimorya <kaizaad@sharcnet.ca>
Subject: Re: mdadm raid5 array - 0 space available but usage is less than
 capacity
Date: Thu, 23 Sep 2010 15:53:47 -0400 (EDT)
Message-ID: <alpine.LRH.2.00.1009231552110.5895@limbo.sharcnet.ca>
References: <AANLkTi=XoxYmj8G5+GadCCTxQGJqpMttmU3NMH_vtKYM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=XoxYmj8G5+GadCCTxQGJqpMttmU3NMH_vtKYM@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Doherty <rdoherty@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 23 Sep 2010, Robin Doherty wrote:

> I have a RAID5 array of 5 1TB disks that has worked fine for 2 years
> but now says that it has 0 space available (even though it does have
> space available). It will allow me to read from it but not write. I
> can delete things, and the usage goes down but the space stays at 0.
>
> I can touch but not mkdir:
>
> rob@cholera ~ $ mkdir /share/test
> mkdir: cannot create directory `/share/test': No space left on device
> rob@cholera ~ $ touch /share/test
> rob@cholera ~ $ rm /share/test
> rob@cholera ~ $
>
> Output from df -h (/dev/md2 is the problem array):
>
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md1               23G   15G  6.1G  72% /
> varrun               1008M  328K 1007M   1% /var/run
> varlock              1008M     0 1008M   0% /var/lock
> udev                 1008M  140K 1008M   1% /dev
> devshm               1008M     0 1008M   0% /dev/shm
> /dev/md0              183M   43M  131M  25% /boot
> /dev/md2              3.6T  3.5T     0 100% /share
>
> and without the -h:
>
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/md1              23261796  15696564   6392900  72% /
> varrun                 1031412       328   1031084   1% /var/run
> varlock                1031412         0   1031412   0% /var/lock
> udev                   1031412       140   1031272   1% /dev
> devshm                 1031412         0   1031412   0% /dev/shm
> /dev/md0                186555     43532    133391  25% /boot
> /dev/md2             3843709832 3705379188         0 100% /share


Just a shot in the dark but I have seen this with Lustre systems. What 
does "df -i" show?

thanks
-k
