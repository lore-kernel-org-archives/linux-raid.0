From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Raid 5 to 6 reshape q
Date: Sun, 03 Jan 2010 21:34:43 +0100
Message-ID: <4B40FF63.3090302@rabbit.us>
References: <73e903671001020419x47a07e69ucb5a01b99dc1fc03@mail.gmail.com> 	<657593.18711.qm@web51308.mail.re2.yahoo.com> <a43edf1b1001031214m6a4bea69ja17508b7da41efbd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a43edf1b1001031214m6a4bea69ja17508b7da41efbd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Billy Crook <billycrook@gmail.com>
Cc: Jon@ehardcastle.com, =?UTF-8?B?S3Jpc3RsZWlmdXIgRGHDsGFzb24=?= <kristleifur@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Billy Crook wrote:
> Here's a couple trivial scripts I've used to pause execution until a
> sync is completed.  They are handy for when you want to do multiple
> grow operations, each no sooner than after the previous completed.
> Modify for your own purposes.
> 
> [root@Eight bin]# cat raid-wait-till-sync-finish
> #! /bin/bash
> 
> export interval=300
> 
> if [[ $1 -gt 0 ]]
> then
> 	interval=$1
> fi
> 
> echo -n Checking every ${interval} seconds for raid sync to finish.
> 
> while [[ $( cat /sys/block/md*/md/sync_action | \
>             grep -v idle | \
>             wc -l ) -gt 0 ]]
> do
> 	echo -n .
> 	sleep ${interval}
> done
> 
> echo Raid System Healthy!
> 
> exit 0
> [root@Eight bin]# cat raid-wait-till-all-healthy
> #! /bin/bash
> 
> export clean=no
> while [[ $clean==no ]]
> do
> 	#set clean to yes
> 	clean=yes
> 
> 	#Give each array the chance to set clean to no
> 	for array in `ls -1 /sys/block/md*/md -d`
> 	do
> 		
> 		if [[ $( cat $array/raid_disks ) -gt $( ls -1 $array/ | grep
> ^rd[0-9]*$ | wc -l ) ]]
> 		then
> 			echo $array is still unclean
> 			clean=no
> 		fi
> 	done
> 	sleep 5
> done
> 

Both of these can be replaced by mdadm --wait $device
