From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Status of discard support in MD RAID
Date: Thu, 11 Sep 2014 18:46:04 -0600
Message-ID: <26CB8B36-9CD9-4EE0-BFF2-4B183DBDD033@colorremedies.com>
References: <1ED0286A-56DA-491D-853A-1C1045449201@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1ED0286A-56DA-491D-853A-1C1045449201@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids


On Sep 11, 2014, at 5:38 PM, Brassow Jonathan <jbrassow@redhat.com> wrote:

> Neil (or anyone else),
> 
> I know that trim/discard support was added back in 2012 (commit 9db90880).  However, I thought there were still issues regarding what happens when various sync operations occur.  I'd like to turn on discard support in dm-raid.c (a oneline patch) if things are in order.  I can enable any, all or none depending on your recommendation.  (I assume RAID1/10 is easier than the parity RAIDs.)

If all the controller and drive support it then it should pass through, but there's the problem whether the SSD supports deterministic trim. If it doesn't, a check check > md/sync_action will report mismatches in md/mismatch_cnt; and a repair will probably corrupt the volume. So you can still use trim with a drive that returns non-deterministic results with raid0/1/10, but you can't rely on the result of md/mismatch_cnt and you can't do repair type scrubs.

For raid5/6, it's a problem to use trim if the drive returns non-deterministically for trimmed blocks. I'd think that in addition to DRAT being supported, it'd need to support DZAT.

smartctl --identify=wb /dev/diskX | grep -i trim


Chris Murphy

