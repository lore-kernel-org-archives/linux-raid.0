From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: [SOLVED] RAID-10 array won't auto-assemble @ boot of a Xen Guest;
	Works just fine 'manually' ... Any ideas?
Date: Tue, 15 Dec 2009 17:05:18 -0800
Message-ID: <babafd2f0912151705sbda2f50i84ca88433713888d@mail.gmail.com>
References: <babafd2f0912151558y513b589ay5e43080ef8e697d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <babafd2f0912151558y513b589ay5e43080ef8e697d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Apparently, when NOT a "/" or "/boot" drive, the RAID arrays need

  chkconfig boot.md on

which, strangely, doesn't show up at all in,

  chkconfig -- list | grep -i boot
    list: unknown service

or,

  man mdadm
  man md

Anyway, array's started on boot now.  Hth someone.

BenDJ
