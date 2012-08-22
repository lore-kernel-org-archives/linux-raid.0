From: =?UTF-8?B?U2VyZ2l1c3ogQnJ6ZXppxYRza2k=?=
	<Sergiusz.Brzezinski@supersystem.pl>
Subject: Re: mdadm --monitor: need extra feature?
Date: Wed, 22 Aug 2012 11:50:17 +0200
Message-ID: <5034AB59.90907@supersystem.pl>
References: <503365EB.6000006@supersystem.pl> <503366A1.9030307@hesbynett.no> <50337654.9000905@supersystem.pl> <50338185.4020003@websitemanagers.com.au> <503486C7.70503@supersystem.pl> <20120822174435.685d80d4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120822174435.685d80d4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

W dniu 22.08.2012 09:44, NeilBrown pisze:
[...]
>>> So, again, ignoring that you possibly should not be using RAID for a
>>> backup... how about using udev scripts to see when you plugin a drive,
>>> and that script can check the UUID against any md arrays, and if it
>>> matches, add it to the array....
>>
>> I wrote a script making this work. It runs once a hour. I pass the parameter
>> with md device to the script. It checks the state of the array with "mdadm
>> --detail". If there is something wrong (State : degraded) it reads UUID of that
>> array. Then it scans for /dev/sd* partitions and checks with "mdadm --examine"
>> if UUID matches. If so, the partition can be added with "mdadm --add". That is
>> why I asked abut this feature in mdadm - recognising if there is a new partition
>> belonging to monitored array. With mdadm this procedure would work on elegant
>> manner.
>>
>
> udev really is the right way to do this.  Just get udev to run
>    mdadm -I /dev/newdev
> whenever a device is discovered.  It can then be automatically re-added
> depending on the policy set up in mdadm.conf.
> "mdadm --monitor" will not gain this functionality.  It is for monitoring
> active arrays, not for monitor new devices.
>
> NeilBrown
>

Yes, that ist what I need and what I asked for!: udev + mdadm -I

I didn't know the Incremental function of mdadm (mea culpa). And udev is even 
prepared for this! (at least in Ubuntu)

I never thougt it is so simple!

thank You

For another people looking for similar solution I write what I did:

1.
I switched /etc/udev/udev.conf/udev_log to "debug" to see what happen after 
inserting new drive.

2.
After inserting the drive I found in logs following lines:

Aug 22 11:08:47 serwer-linmot udevd[2287]: '/sbin/mdadm --incremental 
/dev/sdc3'(err) 'mdadm: not adding /dev/sdc3 to active array (without --run) 
/dev/md/0'
Aug 22 11:08:47 serwer-linmot udevd[2287]: '/sbin/mdadm --incremental /dev/sdc3' 
[2310] exit with return code 2

3.
In Ubuntu there is in /lib/udev/rules.d/64-md-raid.rules file responsible for 
this. I only changed one line:

ACTION=="add", RUN+="/sbin/mdadm --incremental $tempnode"
to:
ACTION=="add", RUN+="/sbin/mdadm --incremental --run $tempnode"

And thats all!

Now, I don't have to use my script from crontab anymore. Raid start rebuilding 
array immediately after disk is inserted.

Sergiusz




