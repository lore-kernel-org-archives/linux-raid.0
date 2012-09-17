From: "Johnson Yan" <johnson_yan@usish.com>
Subject: RE: RAID0 DeviceDisappeared event happen when restart mdmonitor service
Date: Mon, 17 Sep 2012 11:23:40 +0800
Message-ID: <016e01cd9483$d5690a70$803b1f50$@com>
References: <012401cd9260$141ca630$3c55f290$@com>	<CA+res+TafD=pdpX-8bz8M4keGDO45Jd=W9VGSY+=douiqGPy5w@mail.gmail.com>	<20120917124813.0bd260c3@notabene.brown> <CA+res+RvgxtHmYHw3DMCm7La9AFoCzxM93YLKJYvYy7EwBYyfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+res+RvgxtHmYHw3DMCm7La9AFoCzxM93YLKJYvYy7EwBYyfw@mail.gmail.com>
Content-Language: zh-cn
Sender: linux-raid-owner@vger.kernel.org
To: 'Jack Wang' <jack.wang.usish@gmail.com>, 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,
Thank you for the clarification.
I can remove the RAID0 MD's information from /etc/mdadm.conf to omit the monitor for RAID0, then so such event occurred when restart mdmonitor service, but the system won't re-assemble these RAID0 MD after every system reboot.
Do you have any good advice?

Best Regards,
Johnson

> Thanks Neil for always kindly help.
> The device disappeared event report when restart mdmonitor service, which
> will mdadm with options PIDFILE=/var/run/mdadm/mdadm.pid
> PATH=/sbin:/usr/sbin:$PATH
> RETVAL=0
> OPTIONS="-F -y -f -s -i $PIDFILE"
> 
> And I checked man page of mdadm which clear claimed :
> 
> 
>  DeviceDisappeared
>                   An  md  array  which previously was configured
> appears to no
>                   longer be configured. (syslog priority: Critical)
> 
>                   If mdadm was told to monitor an array which is RAID0 or
> Lin-
>                   ear,  then  it  will report DeviceDisappeared with the
> extra
>                   information Wrong-Level.  This is because RAID0  and
> Linear
>                   do not support the device-failed, hot-spare and resync
> oper-
>                   ations which are monitored.
> 
> Thanks again for your time.
> 
> Jack



