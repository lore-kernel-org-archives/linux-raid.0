From: PinkFreud <pf-raid20051104@mirkwood.net>
Subject: [fwd: ECC circuitry error / md weirdness?]
Date: Fri, 4 Nov 2005 20:20:19 -0500
Message-ID: <20051105012019.GF19967@eriador.mirkwood.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="4zI0WCX1RcnW9Hbu"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm resending to this list.  Any ideas why md was happily writing to a
disk that the kernel thought had problems?


-- 
                                                                      
Mike Edwards                    |   If this email address disappears,   
Unsolicited advertisments to    |   assume it was spammed to death.  To
this address are not welcome.   |   reach me in that case, s/-.*@/@/
(This means you, Cogent!)       |                                   

--4zI0WCX1RcnW9Hbu
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <linux-kernel-owner+pf-kernel20051102=40mirkwood.net-S965103AbVKBP5O@vger.kernel.org>
Date: Wed, 2 Nov 2005 10:57:11 -0500
From: PinkFreud
To: linux-kernel@vger.kernel.org
Subject: ECC circuitry error / md weirdness?
Message-ID: <20051102155711.GT19490@eriador.mirkwood.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org

We have an md array (RAID5) with 3 disks + 1 spare.  Recently, this
appeared in the logs:

Oct 27 23:44:58 cbs-server kernel: hdk: status timeout: status=0x80 {
Busy }
Oct 27 23:44:58 cbs-server kernel: 
Oct 27 23:44:58 cbs-server kernel: hdk: DMA disabled
Oct 27 23:44:58 cbs-server kernel: PDC202XX: Secondary channel reset.
Oct 27 23:44:58 cbs-server kernel: hdk: drive not ready for command
Oct 27 23:45:04 cbs-server kernel: ide5: reset: master: ECC circuitry
error
Oct 27 23:45:04 cbs-server kernel: hdk: status error: status=0x58 {
DriveReady SeekComplete DataRequest }

After that was just a repetition of the 'drive not ready for command'
and status=0x58 lines.

What really threw me for a loop, though, was the fact that hdk was one
of the active disks in the array mentioned above.  md was happily
writing to a disk that the kernel thought was failing!  I had to
manually fail the disk out of the array to convince md to pull the
spare in.

The end result is one hell of a corrupt filesystem (I'm now seeing
'ghost' files that won't go away):

[root@cbs-server cope11.feat]# ls -al | grep example_func.nii.gz
[root@cbs-server cope11.feat]# ls -al example_func.nii.gz
ls: example_func.nii.gz: Input/output error
[root@cbs-server cope11.feat]# 

fsck has had no luck in fixing these errors, though it does find
- and fix - problems every time I run it (ext3 fs).

I suspect I'm going to have to mkfs the array (unless someone can
recommend something else!).  My main concern, though, is figuring out
what went wrong with hdk and md in the first place.  I've never seen
the ECC circuitry error that was thrown before.  AFAICT, the hard disk
appears to be fine.  It's about 3 months old, and both SMART offline
data collection and extended self test were run last night without a
single error being logged by the drive.  Likewise, it stopped throwing
errors in the system logs when it was failed out of the array.

I'm also concerned about why md was writing to a disk that the kernel
saw as having errors.  Should it not fail the disk out of the array
automatically?

Specs on the system in question:
2.4.31 (vanilla) SMP
2 Promise 20268 IDE controllers
4 WDC WD3200SB-01KMA0 disks


-- 
                                                                      
Mike Edwards                    |   If this email address disappears,   
Unsolicited advertisments to    |   assume it was spammed to death.  To
this address are not welcome.   |   reach me in that case, s/-.*@/@/
(This means you, Cogent!)       |                                   
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

--4zI0WCX1RcnW9Hbu--
