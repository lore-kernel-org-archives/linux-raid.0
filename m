From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: mdadm 3.3: issue with mdmon --takeover
Date: Wed, 11 Sep 2013 10:11:29 +0200
Message-ID: <CAC9WiBjsC1E2HV2vmiiKmGFXBBmZ+Rh0gktvxebKqZbKqD2hpw@mail.gmail.com>
References: <CAC9WiBjg4Tbv_UM4o66-8jtFEYGvh3kuP6xSdnz7uL+fq3fZTQ@mail.gmail.com>
	<20130904160832.3627bcb8@notabene.brown>
	<CAC9WiBiHkOjqY4nDwMh4S8td9NMz2mrdqK0R7cZp7nKSMyhBvg@mail.gmail.com>
	<20130905121123.27968f9f@notabene.brown>
	<CAC9WiBiHcS126iFv91250d83sMrBYmRbvoqYAEhjJWjb2p5J3A@mail.gmail.com>
	<CAC9WiBgRiu_YL1TpzD4dtLXv=LiA-RERn+C6Q+i=P_WTNdw3+w@mail.gmail.com>
	<20130911093518.794bbb21@notabene.brown>
	<CAC9WiBiRWN4sZ=nd2R3+XqxMD2X=d9F6JtDGpXaNX1jtOFMB4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBiRWN4sZ=nd2R3+XqxMD2X=d9F6JtDGpXaNX1jtOFMB4w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 11, 2013 at 9:40 AM, Francis Moreau <francis.moro@gmail.com> wrote:
[...]
>>
>> I think this patch will help.  The last hunk in particular should make the
>> difference.
>>
>> Please let me know if it fixes the problem.
>>
>
> Yes it fixes the problem.
>
> I had to adjust the patch to make it compile by using be64_to_cpu()
> where needed.
>

Hmm unfortunately the following test case seems broken too, I'm not
sure it's related however:

# create a ddf array containing loop0 and loop1
$ cat /proc/mdstat
Personalities : [raid1]
md124 : active raid1 loop0[1] loop1[0]
      84416 blocks super external:/md125/0 [2/2] [UU]

md125 : inactive loop1[1](S) loop0[0](S)
      65536 blocks super external:ddf

# stop the array
$ mdadm --stop /dev/md124
mdadm: stopped /dev/md124
$ mdadm --stop /dev/md125
mdadm: stopped /dev/md125

# Add only one disk
$ mdadm -I /dev/loop0
mdadm: container /dev/md/ddf1 now has 1 device
mdadm: /dev/md/array1 assembled with 1 device but not started

# start the array
$ mdadm -R /dev/md124

# looks like it failed
$ cat /proc/mdstat
Personalities : [raid1]
md124 : inactive loop0[0]
      84416 blocks super external:/md125/0

md125 : inactive loop0[0](S)
      32768 blocks super external:ddf

# start mdmon manually with debug trace
$ mdmon /dev/md125
starting mdmon for md125
monitor: wake ( )
no arrays to monitor... exiting


-- 
Francis
