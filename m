From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: component device  mismatches found: 9600
Date: Sun, 31 Jul 2011 11:24:00 -0700
Message-ID: <4E359DC0.5090608@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Looking through the logs, I found this in daemon.log.0. Is this a sign 
of a problem? Below is the entire log:

Jul  3 00:57:01 x64VDR mdadm[2003]: RebuildStarted event detected on md 
device /dev/md0
Jul  3 00:57:02 x64VDR mdadm[2003]: RebuildStarted event detected on md 
device /dev/md3
Jul  3 01:02:10 x64VDR mdadm[2003]: RebuildStarted event detected on md 
device /dev/md1
Jul  3 01:02:10 x64VDR mdadm[2003]: RebuildFinished event detected on md 
device /dev/md0
Jul  3 01:03:01 x64VDR mdadm[2003]: RebuildStarted event detected on md 
device /dev/md2
Jul  3 01:03:01 x64VDR mdadm[2003]: RebuildFinished event detected on md 
device /dev/md1, component device  mismatches found: 9600
Jul  3 01:19:41 x64VDR mdadm[2003]: Rebuild29 event detected on md 
device /dev/md3
Jul  3 01:19:41 x64VDR mdadm[2003]: Rebuild21 event detected on md 
device /dev/md2
Jul  3 01:36:21 x64VDR mdadm[2003]: Rebuild50 event detected on md 
device /dev/md3
Jul  3 01:36:21 x64VDR mdadm[2003]: Rebuild41 event detected on md 
device /dev/md2
Jul  3 01:53:01 x64VDR mdadm[2003]: Rebuild67 event detected on md 
device /dev/md3
Jul  3 02:09:41 x64VDR mdadm[2003]: Rebuild83 event detected on md 
device /dev/md3
Jul  3 02:09:41 x64VDR mdadm[2003]: Rebuild75 event detected on md 
device /dev/md2
Jul  3 02:26:21 x64VDR mdadm[2003]: Rebuild88 event detected on md 
device /dev/md2
Jul  3 02:32:20 x64VDR mdadm[2003]: RebuildFinished event detected on md 
device /dev/md3
Jul  3 02:43:23 x64VDR mdadm[2003]: RebuildFinished event detected on md 
device /dev/md2

