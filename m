From: Wim Delvaux <wrl.delvaux@gmail.com>
Subject: disk-sleep problems
Date: Tue, 17 Jan 2012 01:09:34 +0100
Message-ID: <CACFydqtrYbjCqzic-ke0B69abWyCpXoFm+3ge=EaBc9GvvgnWg@mail.gmail.com>
Reply-To: wim.delvaux@adaptiveplanet.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have two 2TB disks half set up using raid 1 (full mirroring ?) and the
other half using striping.

very frequently my system, a kubuntu 11.10, hangs (gui is unresponsive).
pressing alt-esc to popup the process monitor shows that key processes are
hanging on disk-sleep.

Often this is the flush daemon or the mdadm processes or sometimes just two
or three applications.

I have an i7 8GB disk with 64 bit linux.

What might be causing this ?
