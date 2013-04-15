From: Ben Bucksch <linux.news@bucksch.org>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Mon, 15 Apr 2013 12:26:40 +0200
Message-ID: <516BD5E0.4040007@bucksch.org>
References: <516869D2.9030506@bucksch.org> <516B3077.9020507@schinagl.nl> <516B590C.5060807@bucksch.org> <516AE7A0.4070504@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516AE7A0.4070504@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oliver Schinagl wrote, On 14.04.2013 19:30:
> mdadm --assemble --run --force /dev/md0 /dev/sd[1-7].
> Make sure to mdadm --stop /dev/md0 before trying to assemble it. 
# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
# mdadm --assemble --run --force /dev/md0 /dev/sd[jlmnopq]
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
mdadm: Not enough devices to start the array.
# cat /proc/mdstat
md0 : inactive sdj[0] sdq[7] sdn[6] sdp[5] sdo[4] sdm[3]
       5860574976 blocks
(Note that sdl is not even listed)
# mdadm --re-add /dev/md0 /dev/sdl
mdadm: re-added /dev/sdl
# cat /proc/mdstat
md0 : inactive sdl[8](S) sdj[0] sdq[7] sdn[6] sdp[5] sdo[4] sdm[3]
       6837337472 blocks

Now, sdl is listed, but as spare. I need it to be treated not as spare, 
but as good drive with correct data (well, almost, 2 events off only). 
How do I do that?


