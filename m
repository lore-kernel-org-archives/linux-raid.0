From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Version info wrong
Date: Sat, 22 Mar 2003 16:05:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030322140508.GA804@hvs.envisage.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

HI there,

 bash-2.05b# pwd
 /usr/src/raidtools-1.00.3
 bash-2.05b# grep -i version common.h
 #define MKRAID_MAJOR_VERSION            (0)
 #define MKRAID_MINOR_VERSION            (90)
 #define MKRAID_PATCHLEVEL_VERSION       (0)

GReetz
Hendrik
