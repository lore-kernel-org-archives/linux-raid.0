From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Help please: 2-5 tps on write with 98% iowait
Date: Thu, 26 Jan 2012 14:21:53 -0600
Message-ID: <4F21B5E1.7070207@hardwarefreak.com>
References: <CAG-w=x54HyGxnjSHjBCpqYXvOOwpWd4dOHCJBYTTuvPHu_ViCA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG-w=x54HyGxnjSHjBCpqYXvOOwpWd4dOHCJBYTTuvPHu_ViCA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Seth Jennings <spartacus06@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/25/2012 12:15 PM, Seth Jennings wrote:
> The write performance on my raid5 took a nose dive yesterday

Simply identify what changed between the 24th and 25th, if indeed this
problem started on the 25th.

Odds are you're currently attacking this from the wrong angle, as
neither your mdraid setup, your HBA, nor the drives themselves have
changed in a 24 hour period, correct?

More likely is that in this time frame you wrote a large file(s) filling
up the EXT4 filesystem sufficiently to force writing into smaller and
smaller free spaces, which is likely causing excessive RAID RMW operations.

Show df output for all filesystems on the mdraid device to confirm or
reject this theory.

One of the downsides of parity RAID is that RMW kicks in with a
vengeance when filesystems start getting full.

-- Stan
