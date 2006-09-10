From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: proactive-raid-disk-replacement
Date: Sun, 10 Sep 2006 13:53:01 +0300
Message-ID: <5b170a7d0609100353n60dcb57drd38aabad4a0081a4@mail.gmail.com>
References: <45012E73.5040900@tls.msk.ru>
	 <20060910020203.27d26886@30_bodo.rupinet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060910020203.27d26886@30_bodo.rupinet>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bodo Thiesen <bothie@gmx.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 9/10/06, Bodo Thiesen <bothie@gmx.de> wrote:
> So, we need a way, to feedback the redundancy from the raid5 to the raid1.
<snip long explanation>

Sounds awfully complicated to me. Perhaps this is how it internally
works, but my 2 cents go to the option to gracefully remove a device
(migrating to a spare without losing redundancy) in the kernel (or
mdadm).

I'm thinking

mdadm /dev/raid-device -a /dev/new-disk
mdadm /dev/raid-device --graceful-remove /dev/failing-disk

also hopefully a path to do this instead of kicking (multiple) disks
when bad blocks occur.
