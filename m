From: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Wed, 7 Feb 2018 10:42:39 +0100
Message-ID: <aedfc1ac-a95f-b20f-2713-87cf412afdf4@uni-konstanz.de>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180206181416.amo6geclrvc6ylrf@merlins.org>
Content-Language: en-MW
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/06/2018 07:14 PM, Marc MERLIN wrote:
> So, I have 2 drives on a 5x6TB array that have respectively 1 and 8
> pending sectors in smart.
> 
...
> # 3  Extended offline    Completed: read failure       90%       289
      1287409520

I have successfully used "badblocks" to overwrite bad sectors.

The variety of badblocks that comes with RHEL (there may be others!)
could be used with e.g.
 badblocks -svnb512 /dev/sdh 1287409599 1287409400
where
-n     Use non-destructive read-write mode.  By default only a
non-destructive read-only test is done.  This option  must  not  be
combined  with  the  -w option, as they are mutually exclusive.

I've adjusted the last-block and first-block numbers in the command
above so that they
a) encompass the known bad blocks
b) start and end on 4k-boundaries

This command leaves those blocks intact that still can be read.

After that, use a destructive-write badblocks e.g.

badblocks -sfvwb512 /dev/sdh <x> <y>
You'll have to adjust x and y to match just those blocks that cannot be
read, based on the output of the first badblocks run.

Afterwards, "smartctl -t short /dev/sdh" may clean up the SMART statistics.

HTH,

Kay





