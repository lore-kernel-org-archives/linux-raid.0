From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: "Missing" RAID devices
Date: Wed, 22 May 2013 17:43:33 -0500
Message-ID: <519D4A15.7020107@hardwarefreak.com>
References: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com> <519B9351.4050708@turmel.org> <CAGPLN=uiUD3wnwt6DfELaLh+yqxkbrA=KetPiQHZrqq4FrS=HA@mail.gmail.com> <519C0B13.3040906@turmel.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <519C0B13.3040906@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry for the dup Phil, hit the wrong reply button.

On 5/21/2013 7:02 PM, Phil Turmel wrote:
...
> ...First is /dev/md1, a small (~500m) n-way
> ...as /boot.  The other, /dev/md2, uses
> ...raid10,far3 or raid6.
> 
> I put LVM on top of /dev/md2, with LVs for swap, ... /tmp

Swap and tmp atop an LV atop RAID6?  The former will always RMW on page
writes, the latter quite often will cause RMW.  As you stated your
performance requirements are modest.  However, for the archives, putting
swap on a parity array, let alone a double parity array, is not good
practice.

-- 
Stan

