From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Question regarding mdadm.conf
Date: Thu, 17 Feb 2005 03:44:40 -0500
Message-ID: <200502170844.j1H8ij924558@www.watkins-home.com>
References: <42145487.3090701@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <42145487.3090701@gmx.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Torsten E.'" <linux-user@gmx.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In the past, Neil has recommended using a device line like this:
DEVICE partitions

From "man mdadm.conf":
Alternatively, a device line can contain  the  word  partitions.
    This  will  cause mdadm to read /proc/partitions and include all
    devices and partitions found there-in.  mdadm does not  use  the
    names  from /proc/partitions but only the major and minor device
    numbers.  It scans /dev to find the name that matches  the  num-
    bers.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Torsten E.
Sent: Thursday, February 17, 2005 3:24 AM
To: linux-raid@vger.kernel.org
Subject: Re: Question regarding mdadm.conf

Hi Michael,
Hi Lajber,

Thanks for your hints!

Michael Tokarev scribbled on 17.02.2005 08:14:
> Lajber Zoltan wrote:
> 
>> Hi!
>>
>> On Thu, 17 Feb 2005, Torsten E. wrote:
>>
>>> How does I get those UUID information, to add them to the new
>>> /etc/mdadm.conf?
>>
>> Try this one: mdadm --detail /dev/md1 | grep UUID
> 
> I'd say
> 
>   mdadm --detail --brief /dev/md1 | grep -v devices=

Didn't work for me ... but as I (hopefully!) understood the basic usage 
I run:
   mdadm --detail --brief /dev/md* >> /tmp/mdtest
After adding some more lines (DEVICE /dev/sda*, DEVICE /dev/sdb*, 
MAILADDR admin) I simply renamed it to /etc/mdadm.conf ... its not a 
good way, but for me its an useable (and so its good again ;)).

> -- this will give you all information necessary for mdadm.conf,
> you can just redirect output into that file.
> 
> Note the grep usage.  Someone will disagree with me here, but
> there is a reason why to remove devices= line.  Without it,
> output from mdadm looks like (on my system anyway):
> 
> ARRAY /dev/md1 level=raid1 num-devices=4 
> UUID=11e92e45:15fcc4a0:cf62e981:a79de494
>    devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1
> 
> Ie, it lists all the devices which are parts of the array.
> The problem with this is: if, for any reason (dead drive,
> adding/removing drives/controllers etc) the devices will
> change, and some /dev/sdXY will point to another device wich
> is a part of some other raid array, mdadm will refuse to
> assemble this array, saying something in a line of "the
> UUIDs does not match, aborting".  Without the "devices="
> part but with --scan option, mdadm will search all devices
> by its own (based on the DEVICE line in mdadm.conf) - this
> is somewhat slower as it will try to open each device in
> turn, but safer, as it will find all the present components
> no matter what.
> 
> Someone correct me if I'm wrong... ;)
> 
> /mjt

Have a nice day!! :)
Torsten
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

