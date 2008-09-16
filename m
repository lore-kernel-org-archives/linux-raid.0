From: Maarten <maarten@ultratux.net>
Subject: Re: Raid6 array crashed-- 4-disk failure...(?)
Date: Tue, 16 Sep 2008 20:12:47 +0200
Message-ID: <48CFF71F.3070803@ultratux.net>
References: <48CE250C.8000603@ultratux.net> <20080915125951.GA17966@skl-net.de> <48CE9811.60307@ultratux.net> <20080916082509.GA17300@skl-net.de> <48CFF1E9.30006@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48CFF1E9.30006@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maarten wrote:
> Andre Noll wrote:
>> On 19:14, Maarten wrote:

> 
> I'm saving the 15 GB data I did not have any backup of elsewhere now and 
> will sunsequently start a forced resync and then hot-add the 7th drive.

Hm... I'm having some trouble here. In short, I have to stop the array 
to get it to resync, and when I try it like that it doesn't want to 
anyhow. Peculiar. Maybe my mdadm or manpage is out of date, I'll google.


apoc ~ # mdadm --update=resync /dev/md5
mdadm: --update does not set the mode, and so cannot be the first option.
apoc ~ # man mdadm
apoc ~ # mdadm --assemble --update=resync /dev/md5
mdadm: device /dev/md5 already active - cannot assemble it

apoc ~ # mdadm -S /dev/md5
mdadm: stopped /dev/md5
apoc ~ # mdadm --assemble --update=resync /dev/md5
mdadm: failed to RUN_ARRAY /dev/md5: Input/output error
apoc ~ # cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [multipath]

md5 : inactive sdl1[0] sdi1[5] sdh1[4] sdf1[3] sdk1[2] sdj1[1]
       2925435648 blocks

apoc ~ # mdadm --assemble --update=resync /dev/md5
mdadm: device /dev/md5 already active - cannot assemble it
apoc ~ # mdadm -S /dev/md5
mdadm: stopped /dev/md5
apoc ~ # cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [multipath]

unused devices: <none>
apoc ~ # mdadm --assemble --update=resync /dev/md5
mdadm: /dev/md5 assembled from 6 drives - not enough to start the array 
while not clean - consider --force.
apoc ~ # cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [multipath]

md5 : inactive sdl1[0](S) sdi1[5](S) sdh1[4](S) sdf1[3](S) sdk1[2](S) 
sdj1[1](S)
       2925435648 blocks

unused devices: <none>
apoc ~ # mdadm --assemble --update=resync --force /dev/md5
mdadm: /dev/md5 has been started with 6 drives (out of 7).
apoc ~ # cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [multipath]

md5 : active raid6 sdl1[0] sdi1[5] sdh1[4] sdf1[3] sdk1[2] sdj1[1]
       2437863040 blocks level 6, 64k chunk, algorithm 2 [7/6] [UUUUUU_]


So, I'm back at square one with that.

Regards,
Maarten
