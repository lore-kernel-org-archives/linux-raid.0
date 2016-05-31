From: "Peckins, Steven E" <speckins@illinois.edu>
Subject: RAID6 recovery with 6/9 drives out-of-sync
Date: Tue, 31 May 2016 02:43:33 +0000
Message-ID: <C50C72C6-FC75-4863-B743-F63F09AF93B0@illinois.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <1F9F41FCE4303342BB6C1013F75E60E4@mx.uillinois.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I have a system with a 9+1 disk RAID6 array that has "3 drives and 1 spare - not enough to start the array."  The metadata version is 1.1; mdadm version is v3.3.

The component devices in the array are supposed to be multipath devices (dm-multipath), but for some reason, when the server was restarted, md grabbed both dm-* components and raw devices.  I *think* that this is what caused the problem.

The output from "mdadm --examine" shows that the drives in this array have either 44 events (4 drives, including the spare) or 35 events (6 drives) and have an earlier "Updated Time."  All components have a "clean" State, but the drives with later timestamps regard the other drives as missing (AAA......).

	Six drives report this:

		Update Time : Thu May 26 12:10:15 2016
			 Events : 35
	   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

	Four drives report this:

		Update Time : Thu May 26 15:44:23 2016
			 Events : 44
	   Array State : AAA...... ('A' == active, '.' == missing, 'R' == replacing)


I've used dd to duplicate all but one of the "missing" drives to other spares in the system prior to running any "forceful" mdadm commands on this array.  One of the drives (dm-15) errored-out early in the process with what looks like a bad sector, but the others completed fine.

After making those copies, I ran mdadm --assemble --force, the best it could do was five drives:  "/dev/md10 assembled from 5 drives and 1 spare - not enough to start the array."

Interestingly it says it cleared the "FAULTY" flag from two devices.  But output from --examine showed all components as clean.

(There are five other 9+1 RAID6 arrays in this system, and they all came up without issue.)

I'm seeking advice on how to proceed at this point.  If more information is required, please ask.

Output from --examine:  http://pastebin.com/khvPWrba
Output from --assemble:  http://pastebin.com/s2GkHkah

