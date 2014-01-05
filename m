From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovering an Array with inconsistent Superblocks
Date: Sun, 05 Jan 2014 13:25:29 -0500
Message-ID: <52C9A399.5040802@turmel.org>
References: <1388829881.16265.20.camel@vessel> <52C835C9.3050707@turmel.org>	 <1388873143.7641.20.camel@vessel> <52C8C433.5030403@turmel.org>	 <1388912870.3591.4.camel@vessel> <20140105205612.093276ef@notabene.brown> <1388918703.3591.20.camel@vessel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1388918703.3591.20.camel@vessel>
Sender: linux-raid-owner@vger.kernel.org
To: Fabian Knorr <knorrfab@fim.uni-passau.de>, NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Fabian,

I see good news to greet me this morning!

On 01/05/2014 05:45 AM, Fabian Knorr wrote:
> $ cat /proc/mdstat 
> Personalities : [raid6] [raid5] [raid4] 
> md127 : active (auto-read-only) raid5 sde1[6] sdh1[2] sdi1[3] sdb1[4] sdg1[1] sdc1[5] sdf1[0]
>       11721074688 blocks level 5, 1024k chunk, algorithm 2 [7/7] [UUUUUUU]
>         resync=PENDING

Auto-read-only will switch to read-write as soon as you actually write
anything to the array.  Which will also kick off the resync.

> unused devices: <none>
> 
> $ mdadm --stop /dev/md127 
> mdadm: Cannot get exclusive access to /dev/md127:Perhaps a running process, mounted filesystem or active volume group?

LVM has the array open--but you don't need to stop it.  Just mount your
storage filesystem.

The damaged root filesystem undoubtedly had much info in RAM cache that
couldn't be written after the controller hiccup.

> I'd like to keep the state of lvm-storage as it is and re-install my
> system. Still, a few things I'm not sure about:
> 
> 	- How can I get mdadm to initiate resync and get write access 
> 	  to my data?

See above.

> 	- As lvm-root seems to be severly damaged, is there any chance
> 	  of  errors in the lvm-storage FS that fsck -fn does not
> 	  detect? Could re-syncing therefore destroy data I have access
> 	  to now?

Possible, but not any help for it.  The file allocation structures are
Ok (that's what fsck can see), but if any contents had been just written
at the time of the crash, parts of those writes might not have reached
the dropped array members.

> 	- Can I make sure that the working setup is written to all 
> 	  superblocks, and zero the spare's superblock so that there is
> 	  no such confusion when trying to assemble the array in the
> 	  future?

Yes, you can use --zero-superblock on the spare before you --add it back
the array.  It might save you some warnings.

Long term, consider creating a new array with metadata type 1.x so you
can use a bitmap.  If you ever have an event like this, where one or
more devices are disconnected then reconnected, it'll greatly shorten
the recovery time.

You should also learn to use --re-add instead of --add for devices that
are supposed to already be part of an array.  Newer versions of mdadm
try to help you with this.

HTH,

Phil

(And thank you too, Neil, for a timely assist!)
