From: Jools Wills <jools@oxfordinspire.co.uk>
Subject: problem with mdadm --incremental on ubuntu from initramfs (path
 choice related) on version 3.x
Date: Mon, 29 Mar 2010 07:31:43 +0100
Message-ID: <1269844303.26247.23.camel@travelmate.workshop>
Reply-To: jools@oxfordinspire.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was trying to get mdadm 3.1.2 to work on ubuntu. ubuntu calls mdadm
with --incremental for all partitions that have the linux raid
identifier. this is done via udev.

I noticed  when doing mdadm --incremental /dev/sdx from the initramfs
when run a second time, it would say the raid device is in use.

I debugged this and it was down to mdadm not being able to create a map
file. the three choices of possible map file location not being
available. on 3.1.2 it states in mapfile.c

 * The preferred location for the map file is /var/run/mdadm.map.
 * However /var/run may not exist or be writable in early boot.  And if
 * no-one has created /var/run/mdadm, we still want to survive.
 * So possible locations are:
 *   /var/run/mdadm/map  /var/run/mdadm.map  /dev/.mdadm.map

however the default map locations are actually

        mapnames(VAR_RUN "/map"), // (/var/run/map)
        mapnames("/var/run/mdadm.map"),
        mapnames(ALT_RUN "/map") // by default /lib/init/rw/mdadm/map

i notice in the mdadm git head this has been changed to

        mapnames(VAR_RUN "/map"),
        mapnames("/var/run/mdadm.map"),
        mapnames(ALT_RUN "/" ALT_MAPFILE)

and the description has been almost corrected (albeit some typos) to

 *   /var/run/mdadm/map  /var/run/mdadm.map  /lib/initrw/madam/map

however, these paths are still not helpful for the ubuntu initramfs that
doesn't have these locations - and there is not an obvious fall back
location.

Also changing the ALT_RUN location will also change where it stores the
PID for the monitor daemon, which is called much later once root is
mounted, so even if ALT_RUN is set to /dev/ so the map file could be
created. it wouldn't be the ideal location for the PID.

Since things tend to fail if it cant make the mapfile how about it
tries /dev/ as a final location for the file (or another location that
is likely to exist) if the others fail? Another option that would work,
is to create a folder such as /var/run if it is missing, or allow the
map file path to be passed as a parameter, so the location guesswork
could be overridden by the caller.

Also, some error reporting that the map file couldn't be created would
be most useful, instead of the "/dev/md0 is in use" error.

Thanks for listening.

..

My final thought is, that to make this bug report, I had to come and
sign up here on this list, and then hope that the mdadm maintainer will
read it. The mdadm software really needs a bugtracker, or better
instructions on the site as to how to go about reporting issues.

Best Regards

Jools


Jools Wills
-- 
IT Consultant
Oxford Inspire - http://www.oxfordinspire.co.uk - be inspired
t: 01235 519446 m: 07966 577498
jools@oxfordinspire.co.uk

