From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mdadm question
Date: Wed, 03 Mar 2010 11:51:31 -0500
Message-ID: <4B8E9393.40501@tmr.com>
References: <214245121.2733.1267578904402.JavaMail.root@mail1>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <214245121.2733.1267578904402.JavaMail.root@mail1>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Minvielle <robert@lite3d.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robert Minvielle wrote:
> I am trying to setup a new raid array on a debian box, and I have not run into
> this problem before. I could not find a mdadm list, so I will ask here. If this
> is totally off topic, please disregard. 
>
>
> I am attempting to setup a raid 6 array, but this is failing so I backing down
> to a no-frills raid 5 array. The system is Debian5, stock kernel, stock everything. 
> The mdadm is the stock debian, pulled with apt-get, version 2.6.7. 
> The machine in question has one IDE drive for linux, and 45 SATA drives. Debian
> sees all of the drives, and I have fdisked all of them with one partition of type
> fd (Linux autodetect raid). fdisk -l /dev/sd[a-z] /dev/sdaa[a-s] shows them all
> with no problems. 
>
> The issue is that when I do a 
>
> mdadm --create /dev/md0 --level=5 --raid-devices=45 /dev/sd[a-z]1 /dev/sda[a-s]1
>
> to create a raid array with no spares, all defaults, it returns with 
>
> invalid number of raid devices. 
>
> I have searched the web to no avail. --verbose does not increase verbosity. There
> are no debug switches (that I know of) to mdadm. log files show nothing. Leaving off
> --raid-devices=45 does nothing. Changing the number of devices just for fun does
> nothing. (45,44,43,2,whatever). I am not sure if this is a problem with this version
> in debian, the number of drives that I have, or the setup. I have done this before
> (with a few less drives) with no problems. 
>
> Any suggestions would be appreciated. 
>   

You seem to have gotten your answer on number of drives, now you can go 
with raid-6 as desired. However, since the performance of raid-6 in 
degraded mode is pretty poor and gets worse with more drives, you may 
want to consider allocating at least one drive as a spare, or doing a 
raid-0 over three smaller raid-5 or raid-6 arrays to speed rebuild. You 
can also have shared spares to allow for fast rebuild of any of the 
smaller redundant arrays.

The price of many flexible options is many decisions.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

