From: Eli Stair <estair@ilm.com>
Subject: Setting write-intent bitmap during array resync/create?
Date: Tue, 10 Oct 2006 12:31:17 -0700
Message-ID: <452BF505.9020608@ilm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I gather this isn't currently possible, but I wonder if it's feasible to 
make it so?  This works fine once the array is marked 'clean', and I 
imagine it's simpler to just disallow the bitmap creation until it's in 
that state.  Would it be possible to allow creation of the bitmap by 
queueing the action until the array is done rebuilding?

The reason for this concern is I've got a plethora of systems that are 
set for auto-deployment; that is they can be booted into a mode where 
they will have no existing array and will create it from scratch.  I 
will be using the write-intent bitmap, but in the present state I have 
to set a job to monitor the array state and manually issue the create 
command when it is finished building.

It seems a good candidate for being able to specify this option at array 
creation time along with all other options.

Just a suggestion/feature request.

Cheers,

/eli



// WI Bitmap creation attempt:

[root@gtmp08 /]# mdadm /dev/md0 -Gb internal

mdadm: failed to set internal bitmap.
md: couldn't update array info. -16



// MD state:

Personalities : [raid10]
md0 : active raid10 dm-9[13] dm-8[12] dm-7[11] dm-6[10] dm-5[9] dm-4[8] 
dm-3[7] dm-2[6] dm-13[5] dm-11[4] dm-12[3] dm-10[2] dm-1[1] dm-0[0]
       1003620352 blocks super 1.2 512K chunks 2 offset-copies [14/14] 
[UUUUUUUUUUUUUU]
       [==>..................]  resync = 12.2% (123160576/1003620352) 
finish=225.5min speed=65050K/sec

unused devices: <none>
