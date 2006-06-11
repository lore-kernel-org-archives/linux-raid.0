From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: RAID5 troubles
Date: Sun, 11 Jun 2006 17:42:43 +0200
Message-ID: <62b0912f0606110842v1fbf117ag8eb57758af06977e@mail.gmail.com>
References: <200606102028.k5AKSD86022209@mrz.swissptt.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200606102028.k5AKSD86022209@mrz.swissptt.ch>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: osk@admin.swisscom-mobile.ch
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris wrote:
> Kernel: 2.6.16.16
> mdadm: v1.12.0

> The RAID5 array is still a problem, dmesg says:

> md: running: <sdc2><sdb2><sda2>
> raid5: device sdb2 operational as raid disk 0
> raid5: device sda2 operational as raid disk 1
> raid5: cannot start dirty degraded array for md1

Odd.  Perhaps a bug.
Not sure it will help, but try upgrading mdadm to latest stable (v2.5 or so).

> raid5: failed to run raid set md1
> md: pers->run() failed ...
> md: do_md_run() returned -5

Rather unhelpful to not print an error message.
Unfortunately, I've no clue what -5 means, or where one may look up
do_md_run() errors.
