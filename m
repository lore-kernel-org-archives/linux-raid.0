From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: How does one assemble a DDF or IMSM array?
Date: Fri, 03 Aug 2012 08:15:05 +0200
Message-ID: <501B6C69.8080409@gmail.com>
References: <20120803010532.GA1285@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120803010532.GA1285@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

you can start them by using "mdadm -As", that will start up the 
container first and the other md devices after.
This will work without mdadm.conf, but it is always good to create a 
proper mdadm.conf (mdadm -Es > /etc/mdadm.conf).

As for what it is, the container contains the disks (in your case sda 
and sdb), the disks are not the container.

So you create a container first:
mdadm -CR /dev/md127 -e ddf -l container -n 2 /dev/sda /dev/sdb
Create a RAID1 device of 1 GB in there
mdadm -CR /dev/md0 -l 1 -n 2 /dev/md127 -z  1G
Create another RAID1 device of 50 MB in there
mdadm -CR /dev/md1 -l 1 -n 2 /dev/md127 -z 50M

(in this case both md devices are created on the same two disks).

If you have e.g. 5 disks you can create two separate RAID1 and RAID5 
devices in the container:

mdadm -CR /dev/md127 -e ddf -l container -n 2 /dev/sda /dev/sdb /dev/sdc 
/dev/sdd /dev/sde
mdadm -CR /dev/md0 -l 1 -n 2 /dev/md127
mdadm -CR /dev/md1 -l 5 -n 3 /dev/md127

Now, two disk are used fully for the RAID 1 device and three fully for 
the RAID 5 devices, they both have their own set of disks.


Stopping them all:
mdadm -Ss

Starting them all:
mdadm -As

Hope this helps,

Albert


On 08/03/2012 03:05 AM, Wakko Warner wrote:
> I've not used DDF or IMSM arrays much.
>
> I understand that the devices (ie /dev/sda and /dev/sdb) are the containers.
>
> I know that one can use mdadm -I on the devices and it will create mdXXX
> (last I tried it was 127) and then will create mdXXX for each virtual disk
> in the container and they will just work.
>
> If I do mdadm -A /dev/mdXXX, how would one get the volumes inside started?
> I tried mdadm -I /dev/mdXXX after mdadm -A.  It created mdXXX where XXX is
> -2 from the first one (it 127 being the container and 125 being there but
> not in a state that works)
>
> Does DDF/IMSM require mdadm.conf to work when using -A?
>
> I'm not sure if I'm making myself very clear here or not.
>

