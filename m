From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: cpu consumption
Date: Tue, 24 Jan 2006 01:03:17 -0500
Message-ID: <200601240103.18066.mlaks@verizon.net>
References: <43D55876.5020800@ula.ve>
 <17365.39287.284592.656226@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <17365.39287.284592.656226@cse.unsw.edu.au>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 23 January 2006 10:05 pm, Neil Brown wrote:

>
> This is a poor choice for an mdadm.conf file.
> The device names of 'SCSI' devices are prone to change with changing
> system configuration.  If something disappears or is added, all the
> names could change, and this will cease to work.
> I would strongly recommend putting UUIDs in there.
>
>   echo 'DEVICE /dev/sd[a-l]' > /etc/mdadm/mdadm.conf
>   mdadm -Ds | grep -v devices >> /etc/mdadm/mdadm.conf
This last line gives nothing because  -v switch selects lines not having 
devices, but the other line has num-devices which also matches:
ie
C1:~# mdadm -Ds
ARRAY /dev/md3 level=raid1 num-devices=2 
UUID=209ab7c8:d37fee49:3a63af71:99193e75
   devices=/dev/sde1
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=03dc44fa:606063e2:83e69037:50d00eb5
   devices=/dev/sdd1
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=88433668:ffa6265d:5ed3569b:9ef1d0f8
   devices=/dev/sdc1
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=5f001583:253365c1:1092ccdf:b052e938
   devices=/dev/sdb1,/dev/sda1

thus 
C1:~# mdadm -Ds|grep -v devices
C1:~#   

while you must want
C1:~# mdadm -Ds |grep  num-devices
ARRAY /dev/md3 level=raid1 num-devices=2 
UUID=209ab7c8:d37fee49:3a63af71:99193e75
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=03dc44fa:606063e2:83e69037:50d00eb5
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=88433668:ffa6265d:5ed3569b:9ef1d0f8
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=5f001583:253365c1:1092ccdf:b052e938

(excuse the  line wrap by kmail)

thanks
Mitchell Laks




>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
