From: Bernd Schubert <bs@q-leap.de>
Subject: Re: md3: unsupported reshape (reduce disks) required - aborting
Date: Wed, 27 Feb 2008 15:19:05 +0100
Message-ID: <200802271519.05259.bs@q-leap.de>
References: <200802262020.12458.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200802262020.12458.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 26 February 2008 20:20:12 Bernd Schubert wrote:
> Hello,
>
> while doing a md-check, there was a problem with Lustre and I had to
> hard-reboot. Please note, the raid was perfectly fine, I only did a
> manual "echo check >/sys/block/md3/md/sync_action" to increase the load.

Aarg, I didn't do "echo check >...", but "echo reshape >...". This explains 
why it has a reshape position and why the superblock is at 0.91.


In the mean time I got the raid up by temporarily modifying the raid code and 
setting "mddev->reshape_position = MaxSector". 


-- 
Bernd Schubert
Q-Leap Networks GmbH
