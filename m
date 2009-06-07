From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Unable to stop array
Date: Sun, 7 Jun 2009 13:52:29 -0500
Message-ID: <20090607185225345.YFHY28090@cdptpa-omta04.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I am trying to stop one of my arrays for maintenance, but it won't let me.
I've un-mounted the filesystem, but I still get the following:

mdadm: fail to stop array /dev/md0: Device or resource busy

How do I get the array to be free so I can stop it?

