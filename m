From: "Johnson Yan" <johnson_yan@usish.com>
Subject: RE: RAID0 DeviceDisappeared event happen when restart mdmonitor service
Date: Mon, 17 Sep 2012 10:44:56 +0800
Message-ID: <015c01cd947e$6c596340$450c29c0$@com>
References: <012401cd9260$141ca630$3c55f290$@com> <CA+res+TafD=pdpX-8bz8M4keGDO45Jd=W9VGSY+=douiqGPy5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+res+TafD=pdpX-8bz8M4keGDO45Jd=W9VGSY+=douiqGPy5w@mail.gmail.com>
Content-Language: zh-cn
Sender: linux-raid-owner@vger.kernel.org
To: 'Jack Wang' <jack.wang.usish@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jack,
Thanks for your feedback.

This event should be caused by following code, due to the field "Wrong-Level" can be found in the notify email.

	/* It's much easier to list what array levels can't
	 * have a device disappear than all of them that can
	 */
	if (array.level == 0 || array.level == -1) {
		if (!st->err)
			alert("DeviceDisappeared", dev, "Wrong-Level", ainfo);
		st->err = 1;
		close(fd);
		return 0;
	}

Best Regards,
Johnson

-----Original Message-----
From: Jack Wang [mailto:jack.wang.usish@gmail.com] 
Sent: Monday, September 17, 2012 10:31 AM
To: Johnson Yan
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID0 DeviceDisappeared event happen when restart mdmonitor service

I check into code in mdmonitor.c in function check_array:

	fd = open(dev, O_RDONLY);
	if (fd < 0) {
		if (!st->err)
			alert("DeviceDisappeared", dev, NULL, ainfo);
		st->err=1;
		return 0;
	}
	fcntl(fd, F_SETFD, FD_CLOEXEC);
	if (ioctl(fd, GET_ARRAY_INFO, &array)<0) {
		if (!st->err)
			alert("DeviceDisappeared", dev, NULL, ainfo);
		st->err=1;
		close(fd);
		return 0;
	}
	/* It's much easier to list what array levels can't
	 * have a device disappear than all of them that can
	 */
	if (array.level == 0 || array.level == -1) {
		if (!st->err)
			alert("DeviceDisappeared", dev, "Wrong-Level", ainfo);
		st->err = 1;
		close(fd);
		return 0;
	}

I suspect above code lead to the DeviceDisapeared event you see, not sure why this get GET_ARRAY_INFO return array.level == 0 means Device Disappeared?

Anyone who more familiar with the logic may gave a comment?


Best regards!

Jack

2012/9/14 Johnson Yan <johnson_yan@usish.com>:
> Hi All,
> When I restart mdmonitor service, a notify email will be received, 
> which indicate DeviceDisappeared event happened for RAID0, is this 
> phenomenon reasonable? Could anyone explain this?
>
>
> The email info as below
> ......
> Host            : host3.com
> Event           : DeviceDisappeared
> MD Device       : /dev/md1
> ......
>
> [root@host3 ~]# service mdmonitor restart
> Killing mdmonitor:                                         [  OK  ]
> Starting mdmonitor:                                        [  OK  ]
> [root@host3 ~]#
> [root@host3 ~]# cat /proc/mdstat
> Personalities : [raid1] [raid0]
> md1 : active raid0 sda1[1] sdb1[0]
>       927933312 blocks super 1.2 64k chunks
>
> md2 : active raid1 sdc1[1] sde1[0]
>       292836160 blocks super 1.2 [2/2] [UU]
>       bitmap: 0/2 pages [0KB], 131072KB chunk
>
> md0 : active raid1 sdf1[0] sdg1[1]
>       488254272 blocks super 1.2 [2/2] [UU]
>       bitmap: 0/2 pages [0KB], 131072KB chunk
>
> unused devices: <none>
> [root@host3 ~]#
> [root@host3 ~]# uname -r
> 3.2.28-11.el6.x86_64
> [root@host3 ~]#
> [root@host3 ~]# mdadm -V
> mdadm - v3.2.5 - 18th May 2012
> [root@host3 ~]#
>
>
> Thanks in advance.
> Johnson Yan
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html

