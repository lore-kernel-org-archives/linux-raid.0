From: <me@heyjay.com>
Subject: Re: mdadm: SET_ARRAY_INFO failed for /dev/md0: File exists
Date: Mon, 3 May 2004 21:38:35 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <017401c43180$e7b01cb0$6705a8c0@a30>
References: <012001c430c5$a3e12b70$6705a8c0@a30> <16534.64220.901221.482562@cse.unsw.edu.au> <014601c4317e$b083e250$6705a8c0@a30>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nevermind,  For the next newbie:

mdadm --stop /dev/md0
mdadm --zero-superblock /dev/hda1
mdadm --zero-superblock /dev/hdb1
...

Jay

----- Original Message ----- 
From: <me@heyjay.com>
To: "Neil Brown" <neilb@cse.unsw.edu.au>; <linux-raid@vger.kernel.org>
Sent: Monday, May 03, 2004 9:22 PM
Subject: Re: mdadm: SET_ARRAY_INFO failed for /dev/md0: File exists


> > What does
> >   cat /proc/mdstat
> > show?  I suspect /dev/md0 has already been assembled somehow.
>
> platinum:~# cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid5]
> md3 : active raid1 hdc1[1]
>       20000768 blocks [2/1] [_U]
>
> md1 : active raid1 hdc2[1]
>       40001728 blocks [2/1] [_U]
>
> md2 : active raid1 hdc3[1]
>       40001728 blocks [2/1] [_U]
>
> unused devices: <none>
>
> But how??? I didn't build it.  Is it possible to remain after installs?
Can
> I delete an md?  If so how?
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

