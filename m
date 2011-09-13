From: Phil Turmel <philip@turmel.org>
Subject: Re: What just happened to my disks/RAID5 array?
Date: Tue, 13 Sep 2011 07:37:53 -0400
Message-ID: <4E6F4091.7050206@turmel.org>
References: <4E6F13F7.6070507@truschnigg.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E6F13F7.6070507@truschnigg.info>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Truschnigg <johannes@truschnigg.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good Morning Johannes,

On 09/13/2011 04:27 AM, Johannes Truschnigg wrote:
> Dear list members,
> 
> my server at home just mailed in multiple FAIL events from members of
> the RAID5 array in it. I won't be able to get to the machine during
> the next ten or so hours, but I'd like to be prepared as best as I
> can when I face the disaster that apparently struck. I attached the
> relevant dmesg excerpt, as well as the current mdstat contents.
> Theories explaining what could have happened - and how to deal with
> such a scenario - are highly appreciated, as only some of the data on
> the array is actually backed up elsewhere. If you need any additional
> information about the system or its setup, please ask right away!
> 
> I do have SSH access to the box.

From a brief review of your dmesg, it all looks like hardware.  Some ideas come to mind:

1)  Controller failure.
2)  Power supply failure (possibly partial failure of a multi-rail PS).
3)  Cooling failure.

Simultaneous failure of that many devices strains credulity, so I doubt you've lost your array.  One possible variant of "2" would be a failed drive that draws enough current to drop the voltage to its sibling drives.

Since some drives are still "alive", they'll have newer event counts than the devices that went offline.  When you fix the root cause, you may need to use "--assemble --force" to get mdadm to restart your array.

The output of "lsdrv" [1] would be helpful in offering more specific advice, along with "mdadm -D" of the array and "mdadm -E" of all of its components (when you get them back).

HTH,

Phil

[1] http://github.com/pturmel/lsdrv
