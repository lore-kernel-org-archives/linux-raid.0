From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Question regarding mdadm.conf
Date: Thu, 17 Feb 2005 10:14:32 +0300
Message-ID: <42144458.4040306@tls.msk.ru>
References: <421438E9.5020000@gmx.com> <Pine.LNX.4.58.0502170748160.15568@lajli.gau.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.58.0502170748160.15568@lajli.gau.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Lajber Zoltan <lajbi@lajli.gau.hu>
Cc: "Torsten E." <linux-user@gmx.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lajber Zoltan wrote:
> Hi!
> 
> On Thu, 17 Feb 2005, Torsten E. wrote:
> 
> 
>>How does I get those UUID information, to add them to the new
>>/etc/mdadm.conf?
> 
> Try this one: mdadm --detail /dev/md1 | grep UUID

I'd say

   mdadm --detail --brief /dev/md1 | grep -v devices=

-- this will give you all information necessary for mdadm.conf,
you can just redirect output into that file.

Note the grep usage.  Someone will disagree with me here, but
there is a reason why to remove devices= line.  Without it,
output from mdadm looks like (on my system anyway):

ARRAY /dev/md1 level=raid1 num-devices=4 UUID=11e92e45:15fcc4a0:cf62e981:a79de494
    devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1

Ie, it lists all the devices which are parts of the array.
The problem with this is: if, for any reason (dead drive,
adding/removing drives/controllers etc) the devices will
change, and some /dev/sdXY will point to another device wich
is a part of some other raid array, mdadm will refuse to
assemble this array, saying something in a line of "the
UUIDs does not match, aborting".  Without the "devices="
part but with --scan option, mdadm will search all devices
by its own (based on the DEVICE line in mdadm.conf) - this
is somewhat slower as it will try to open each device in
turn, but safer, as it will find all the present components
no matter what.

Someone correct me if I'm wrong... ;)

/mjt
