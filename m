From: "John Stoffel" <john@stoffel.org>
Subject: Re: Fwd: Unable to re-assemble a raid 10 after it has FAILED.
Date: Tue, 10 Jun 2014 16:28:48 -0400
Message-ID: <21399.27264.433526.990888@quad.stoffel.home>
References: <CAEp9EKjgt1RTkYzhSX-UQN2-WhV3iCKPr_DTnHN_KmorvFNsvg@mail.gmail.com>
	<CAEp9EKg462T+7E35RnarP6y41wGgNv3R_jAXEhxiLBg_vukW3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEp9EKg462T+7E35RnarP6y41wGgNv3R_jAXEhxiLBg_vukW3g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Morell <amp4tj@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Alberto" == Alberto Morell <amp4tj@gmail.com> writes:

Alberto> I have a raid 10 devices with 4 components. I make the raid
Alberto> fails, by making two components fail (using "mdadm
Alberto> --set-faulty <device>"). When I add the two devices back,
Alberto> they are added as spare devices. Then, I can get the raid
Alberto> active again only creating the raid again using "mdadm
Alberto> --create --assume-clean...". Re-assembling the device does
Alberto> not work with error message:

Alberto> mdadm: failed to RUN_ARRAY /dev/md/hdd: Input/output error
Alberto> mdadm: Not enough devices to start the array.

Alberto> I am trying to automate the raid configuration and the "mdadm --create
Alberto> ..." option is not convenient as I would have to know all the creation
Alberto> parameters.

Alberto> Below is the command sequence.

Alberto> Thanks is advance,

Alberto> Alberto Morell.


Alberto> [root@os2 raid_tools]# mdadm --version
Alberto> mdadm - v3.2.6 - 25th October 2012

Alberto> [root@os2 ~]# mdadm --create /dev/md/hdd --metadata=1.0 --auto=md --name=hdd \
Alberto> --chunk=256 --bitmap=internal --bitmap-chunk=65536 --level=raid10 --run \
Alberto> --raid-devices=4 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

Alberto> [root@os2 ~]# mdadm --set-faulty /dev/md/hdd /dev/sde1
Alberto> mdadm: set /dev/sde1 faulty in /dev/md/hdd
Alberto> [root@os2 ~]# mdadm --set-faulty /dev/md/hdd /dev/sdf1
Alberto> mdadm: set /dev/sdf1 faulty in /dev/md/hdd

You do realize that you killed the last two drives in the array,
right?  sdc1 and sdd1 are mirrored with each other, and sde1 and sdf1
are mirrored to each other.  When you kill those two drives, the
entire array *must* go offline to try and save data.  It's not likely,
since the filesystem spread across all four drives is probably toast
now...

At least that's how I think the RAID10 works be default.  If you use
one of the other layouts, you might have lucked out by not killing
both halves of a raid pair.

John
