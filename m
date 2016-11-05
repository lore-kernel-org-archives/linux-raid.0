From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID10 with 2 drives auto-assembled as RAID1
Date: Sat, 5 Nov 2016 16:20:50 -0400
Message-ID: <57ce55da-fadc-db02-289e-db44bf6fb7d7@turmel.org>
References: <0487f9a4-c04a-8a4d-78ad-0191995d4be9@luketic.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0487f9a4-c04a-8a4d-78ad-0191995d4be9@luketic.de>
Sender: linux-raid-owner@vger.kernel.org
To: Darko Luketic <darko@luketic.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/05/2016 10:10 AM, Darko Luketic wrote:

> Now. I'd like to save whatever data is possible to be saved.
> 
> I'd like to force the 2 drives to be recognized as being in a RAID10
> array. By whatever means necessary, without losing more data.

You haven't provided anywhere near enough data to advise you.  At the
very least, provide "mdadm -E /dev/sdXn" for each member device and your
dmesg from the current environment, plus syslogs showing the last
assembly of the raid10 you think you want.  Paste inline, please.

If you can, run lsdrv[1] on your current environment and paste that in
your reply as well.

Phil

[1] https://github.com/pturmel/lsdrv

