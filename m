From: David Wuertele <dave-gnus@bfnet.com>
Subject: Re: mdadm: Invalid Argument ("cannot start dirty degraded array")
Date: Tue, 09 Nov 2004 20:42:17 -0800
Message-ID: <m3fz3ipb6e.fsf@bfnet.com>
References: <m3ekj3f16q.fsf@bfnet.com> <4191397E.6080005@ruthless.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark> mdadm -S /dev/md0

OK, that worked

Mark> mdadm -Af /dev/md0 /dev/hdm4 /dev/hde2 /dev/hdo2 /dev/hdh2 /dev/hdf2
Mark> /dev/hdg2

This gives me a "Segmentation fault" !!

