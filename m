From: Mitchell Laks <mlaks@verizon.net>
Subject: what is /dev/.static/dev/md0 ???
Date: Sun, 26 Jun 2005 14:22:27 -0400
Message-ID: <200506261422.28250.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Continuing with my saga with my 1/2 raid 1 pair devices....

I took  1/2 of a raid1 pair from one system and placed it on another system. 
Connected it up as the /dev/hdb location. It has a single partition /dev/hdb1 
which is of type linux autodetect fd and formated ext3.

Then I tried to assemble it 
mdadm -A /dev/md0 /dev/hdb1

and got error message
error opening /dev/md0  no such file or directory

(this is debian sid 
uname -a
2.6.10-1-k7-smp
mdadm -V
mdadm -v1.9.0
)

(who ??? knows what the hell is going on with udev here....)

then undetered i did 
mknod /dev/md0 b 9 0
mknod /dev/md1 b 9 1
 
then i did 
mdadm -A /dev/md0 /dev/hdg1

and got response 

mdadm: /dev/md0 assembled from 1 drive
need all 2 to start it
need to --run to insist

So of course i insisted and it started and it was accessible and mounted fine
as /dev/md0.

then i did same with another device for /dev/md1.

then i  wanted to make a mdadm.conf file to play with booting normally 

Machine:~# mdadm --detail --scan

ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=86af4f07:91fe306c:d1cb5c86:e87dc7de
   devices=/dev/.static/dev/hdg1
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=19def19e:3995fe1e:5470d62a:c44b069c
   devices=/dev/.static/dev/hdb1

My question:

what the heck is  
devices=/dev/.static/dev/hdb1

and why doesnt it say what i expect 
devices=/dev/hdb1 and
devices=/dev/hdg1

?????? thanks
Mitchell Laks
