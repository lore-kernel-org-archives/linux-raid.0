From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: mdadm -A -s and a mirror of two stripes
Date: Sat, 17 Apr 2004 18:18:28 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200404172218.i3HMIWQ24208@dns1.watkins-home.com>
References: <Pine.LNX.4.58.0404170145320.7026@potato.cts.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0404170145320.7026@potato.cts.ucla.edu>
To: 'Chris Stromsoe' <cbs@cts.ucla.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I took a quick look.  I think this is the issue.
Your device line does not have md0

Change:
	DEVICE /dev/sd[abcdefghij]1 /dev/md[12]
To:
	
	DEVICE /dev/sd[abcdefghij]1 /dev/md[012]

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Chris Stromsoe
Sent: Saturday, April 17, 2004 4:55 AM
To: linux-raid@vger.kernel.org
Subject: mdadm -A -s and a mirror of two stripes

I've got two stripes that were set up as

mdadm -C /dev/md1 --level=stripe -n 5 \
    /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
mdadm -C /dev/md2 --level=stripe -n 5 \
    /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1

and a mirror that was set up by doing

mdadm -C /dev/md0 --level=mirror -n 2 /dev/md1 /dev/md2


My /etc/mdadm/mdadm.conf reads

DEVICE /dev/sd[abcdefghij]1 /dev/md[12]
ARRAY /dev/md1 level=raid0 num-devices=5
UUID=75892ebc:b52333a4:b77cbdca:9d50c65d
devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1
ARRAY /dev/md2 level=raid0 num-devices=5
UUID=c7547e18:48952f89:49893143:e477c407
devices=/dev/sdf1,/dev/sdg1,/dev/sdh1,/dev/sdi1,/dev/sdj1
ARRAY /dev/md0 level=raid1 num-devices=2
UUID=26e3111e:90a3407d:341ed800:1f431f24 devices=/dev/md1,/dev/md2


mdadm -A -s starts md1, then md2, but doesn't start md0.  I have to run it
a second time to get md0 to start.  The first run prints out:

mdadm: /dev/md1 has been started with 5 drives.
mdadm: /dev/md2 has been started with 5 drives.
mdadm: no devices found for /dev/md0

Is that a bug or a feature?  mdadm is v1.4.0.


-Chris
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


