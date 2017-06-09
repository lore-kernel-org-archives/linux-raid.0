From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: My md won't assemble even when disks are in clean state.
Date: Fri, 9 Jun 2017 21:55:37 +0100
Message-ID: <593B0B49.5000102@youngman.org.uk>
References: <f8d51bbd-6df7-2ea0-ba6f-8831a2b3e390@gmail.com>
 <da15e516-9d92-9b37-0df4-9a53e56e10ba@websitemanagers.com.au>
 <4353246d-a092-e342-6ef7-091d8e9d77c5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4353246d-a092-e342-6ef7-091d8e9d77c5@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/06/17 06:44, Ram Ramesh wrote:
> Thanks. That did it. I was able to assemble. It assembled degraded and I
> --re-added the remaining drives and it accepted without any issue. There
> was no rebuild after --re-add which is consistent with the examine
> output above that all disks are clean. Did fsck a couple of times for a
> good measure and things seem normal now.

Just added a note to that effect to the "When things go wrogn" section
of the front page of the wiki. Arrays left partially assembled on boot
seem such a common problem that a one-liner there seems a fairly good idea.

Cheers,
Wol
