From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: prefered way to update mdadm/mdadm.conf
Date: Fri, 17 Apr 2009 14:16:22 -0700
Message-ID: <001b01c9bfa1$c5bd30c0$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There seems to be 2 ways to update mdadm.conf. One puts a little more info in and both create duplicate info that msut be removed.
Which is the better way:

mdadm --examine --scan >> /etc/mdadm/mdadm.conf
mdadm --detail --scan >> /etc/mdadm/mdadm.conf

Also, is there a way to check if mdadm "damenised" at boot for sending email alerts? mdstat only list the arrays, not any kind of
monitoring level.

