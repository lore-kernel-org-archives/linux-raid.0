From: Mitchell Laks <mlaks@verizon.net>
Subject: /dev/.static/dev/md0 works - weird...
Date: Sun, 26 Jun 2005 16:21:01 -0400
Message-ID: <200506261621.01799.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Now I try the following. 

I notice that on this sysem (which has that damn udev installed) 
/dev/md0 disappears on reboot.

So I see why mdadm --detail --scan came up with that weird 
/dev/.static/dev/md0, 

/dev/.static/dev/md0 at least this device persists after reboot:
that seems to stay around after reboot...


So I edit /etc/mdadm/mdadm.conf to read as follows

Device /dev/.static/dev/hdg1 /dev/.static/dev/hdb1
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=86af4f07:91fe306c:d1cb5c86:e87dc7de
   devices=/dev/.static/dev/hdg1
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=19def19e:3995fe1e:5470d62a:c44b069c
   devices=/dev/.static/dev/hdb1

and  now I reboot the system.

And now if I run 

mdadm -A --run  /dev/.static/dev/md0 /dev/hdb1
it starts it running. and i can mount it.
mount -t ext3 /dev/.static/dev/md0  /big1


So I think that I must create a init.d script to run at the end of the boot to 
do

mdadm -A --run  /dev/.static/dev/md0 /dev/hdb1
mount -t ext3 /dev/.static/dev/md0  /big1

and then I won't have problems....

However I think that raids should boot as long as they are intact, as a matter 
of policy. Otherwise we lose our  ability to rely upon them for remote 
servers...

Mitchell Laks






