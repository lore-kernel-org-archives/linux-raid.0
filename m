From: Lewis Shobbrook <mylists@blue-matrix.org>
Subject: Re: Raid5 & Debian Yaird Woes
Date: Sun, 5 Feb 2006 09:07:29 +1100
Message-ID: <200602050907.31735.mylists@blue-matrix.org>
References: <200602031229.37972.mylists@blue-matrix.org> <200602040958.20183.mylists@blue-matrix.org> <Pine.LNX.4.64.0602031622100.19604@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0602031622100.19604@twinlark.arctic.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org, dr@jones.dk
List-Id: linux-raid.ids

On Saturday 04 February 2006 11:22 am, you wrote:
> On Sat, 4 Feb 2006, Lewis Shobbrook wrote:
> > Is there any way to avoid this requirement for input, so that the system
> > skips the missing drive as the raid/initrd system did previously?
>
> what boot errors are you getting before it drops you to the root password
> prompt?

Basically it just states waiting X seconds for /dev/sdx3 (corresponding to the 
missing raid5 member). Where X cycles from 2,4,8,16 and then drops you into a 
recovery console, no root pwd prompt.
It will only occur if the partition is completely missing, such as a 
replacement disk with a blank partition table, or a completely missing/failed 
drive.
> is it trying to fsck some filesystem it doesn't have access to?

No fsck seen for bad extX partitions etc.

Cheers,

Lewis


