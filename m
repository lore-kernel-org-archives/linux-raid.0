From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: RAID0 DeviceDisappeared event happen when restart mdmonitor service
Date: Mon, 17 Sep 2012 11:03:24 +0800
Message-ID: <CA+res+RvgxtHmYHw3DMCm7La9AFoCzxM93YLKJYvYy7EwBYyfw@mail.gmail.com>
References: <012401cd9260$141ca630$3c55f290$@com>
	<CA+res+TafD=pdpX-8bz8M4keGDO45Jd=W9VGSY+=douiqGPy5w@mail.gmail.com>
	<20120917124813.0bd260c3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120917124813.0bd260c3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Johnson Yan <johnson_yan@usish.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2012/9/17 NeilBrown <neilb@suse.de>:
> On Mon, 17 Sep 2012 10:30:49 +0800 Jack Wang <jack.wang.usish@gmail.com>
> wrote:
>
>> I check into code in mdmonitor.c in function check_array:
>>
>>       fd = open(dev, O_RDONLY);
>>       if (fd < 0) {
>>               if (!st->err)
>>                       alert("DeviceDisappeared", dev, NULL, ainfo);
>>               st->err=1;
>>               return 0;
>>       }
>>       fcntl(fd, F_SETFD, FD_CLOEXEC);
>>       if (ioctl(fd, GET_ARRAY_INFO, &array)<0) {
>>               if (!st->err)
>>                       alert("DeviceDisappeared", dev, NULL, ainfo);
>>               st->err=1;
>>               close(fd);
>>               return 0;
>>       }
>>       /* It's much easier to list what array levels can't
>>        * have a device disappear than all of them that can
>>        */
>>       if (array.level == 0 || array.level == -1) {
>>               if (!st->err)
>>                       alert("DeviceDisappeared", dev, "Wrong-Level", ainfo);
>>               st->err = 1;
>>               close(fd);
>>               return 0;
>>       }
>>
>> I suspect above code lead to the DeviceDisapeared event you see, not
>> sure why this get GET_ARRAY_INFO return array.level == 0 means Device
>> Disappeared?
>>
>> Anyone who more familiar with the logic may gave a comment?
>
>
> It isn't possible or meaningful to monitor RAID0 devices - there is nothing
> to see, nothing that can happen, nothing to report.
>
> mdadm will normally completely ignore RAID0 devices.
>
> If you run
>   mdadm --monitor /dev/md1
>
> when md1 is a RAID0 device, then it will be required to actively forget about
> it, so it reports that the device has disappeared (because it was on the
> list, but now isn't).
>
> This shouldn't happen if you run "mdadm --monitor --scan" which is the
> standard usage.  It that what is happening?
>
> NeilBrown
>
Thanks Neil for always kindly help.
The device disappeared event report when restart mdmonitor service,
which will mdadm with options PIDFILE=/var/run/mdadm/mdadm.pid
PATH=/sbin:/usr/sbin:$PATH
RETVAL=0
OPTIONS="-F -y -f -s -i $PIDFILE"

And I checked man page of mdadm which clear claimed :


 DeviceDisappeared
                  An  md  array  which previously was configured appears to no
                  longer be configured. (syslog priority: Critical)

                  If mdadm was told to monitor an array which is RAID0 or Lin-
                  ear,  then  it  will report DeviceDisappeared with the extra
                  information Wrong-Level.  This is because RAID0  and  Linear
                  do not support the device-failed, hot-spare and resync oper-
                  ations which are monitored.

Thanks again for your time.

Jack
