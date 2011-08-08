From: Joe Landman <joe.landman@gmail.com>
Subject: Re: 20 drive raid-10, CentOS5.5, after reboot assemble fails - all
 drives "non-fresh"
Date: Mon, 08 Aug 2011 01:04:13 -0400
Message-ID: <4E3F6E4D.1010502@gmail.com>
References: <4E3F4BD0.5060807@aeoncomputing.com> <20110808125608.7ceeaa02@notabene.brown> <4E3F66F2.3030300@aeoncomputing.com> <4E3F68CB.4060005@gmail.com> <4E3F6C07.8040106@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E3F6C07.8040106@aeoncomputing.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/08/2011 12:54 AM, Jeff Johnson wrote:
> Joe,
>
> The raid still won't assemble via config file:

[...]

> mdadm: /dev/sdz1 is identified as a member of /dev/md3, slot 20.
> mdadm: /dev/sdy1 is identified as a member of /dev/md3, slot 21.
> mdadm: /dev/sdx1 is identified as a member of /dev/md3, slot 22.
> mdadm: /dev/sdw1 is identified as a member of /dev/md3, slot 23.
> mdadm: /dev/sdv1 is identified as a member of /dev/md3, slot 19.
> mdadm: /dev/sdu1 is identified as a member of /dev/md3, slot 18.
> mdadm: /dev/sdt1 is identified as a member of /dev/md3, slot 17.
> mdadm: /dev/sds1 is identified as a member of /dev/md3, slot 16.
> mdadm: /dev/sdr1 is identified as a member of /dev/md3, slot 15.
> mdadm: /dev/sdq1 is identified as a member of /dev/md3, slot 14.
> mdadm: /dev/sdp1 is identified as a member of /dev/md3, slot 13.
> mdadm: /dev/sdo1 is identified as a member of /dev/md3, slot 12.
> mdadm: /dev/sdn1 is identified as a member of /dev/md3, slot 11.
> mdadm: /dev/sdm1 is identified as a member of /dev/md3, slot 10.
> mdadm: /dev/sdl1 is identified as a member of /dev/md3, slot 9.
> mdadm: /dev/sdk1 is identified as a member of /dev/md3, slot 8.
> mdadm: /dev/sdj1 is identified as a member of /dev/md3, slot 7.
> mdadm: /dev/sdi1 is identified as a member of /dev/md3, slot 6.
> mdadm: /dev/sdh1 is identified as a member of /dev/md3, slot 5.
> mdadm: /dev/sdg1 is identified as a member of /dev/md3, slot 4.
> mdadm: /dev/sdf1 is identified as a member of /dev/md3, slot 3.
> mdadm: /dev/sde1 is identified as a member of /dev/md3, slot 2.
> mdadm: /dev/sdd1 is identified as a member of /dev/md3, slot 1.
> mdadm: /dev/sdc1 is identified as a member of /dev/md3, slot 0.
> mdadm: No suitable drives found for /dev/md3
>
>
> Maybe '--update=uuid' ??

It looks like it correctly finds /dev/sd[c-z]1 as elements of /dev/md3

Which mdadm are you using?

	mdadm -V

and which kernel?

Try the UUID update, and let us know if it helps.  Also if your mdadm is 
old (2.6.x), try updating to 3.1.x.

FWIW: we've found problems in the past with Centos 5.4 to 5.5 kernels 
with MD arrays.  Often times our only real solution would be to update 
the full OS on the boot drives.  This is for distro specific kernels. 
For our kernels, we don't run into this issue.


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
