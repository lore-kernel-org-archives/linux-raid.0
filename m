From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID wiped superblock recovery
Date: Mon, 11 May 2020 10:18:07 -0400
Message-ID: <0f954924-e7ae-c81e-55f1-afc41e293a18@turmel.org>
References: <922713c5-0cc1-24cb-14a6-9de7db631f98@sam-hurst.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <922713c5-0cc1-24cb-14a6-9de7db631f98@sam-hurst.co.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Sam Hurst <sam@sam-hurst.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Sam,

On 5/10/20 6:50 AM, Sam Hurst wrote:
> Hello,

[trim /]

> So, I now have three drives with a wiped superblock. I'm fairly certain 
> it hasn't wiped anything else, hex dumping the drives looks like the 
> data all begins at the same place. First we tried recreating the 
> superblocks by hand, but that didn't work. All the different 
> combinations of --assemble I've tried haven't been much help, as it 
> always ends the same way:

No surprise.  Assemble needs near-perfect superblocks, and --force only 
relaxes a few rules.

> So I've come to the conclusion that the only way forward is to use 
> `mdadm --create` and hope I get the array back that way, with new 
> superblocks.

Yes.  Be sure to always include --assume-clean in these trials.

> However, it's my understanding that you need to add these disks in the 
> correct order - and given I have 7 disks, that's 5040 possible 
> permutations! The original four disks show their device roles, so I'm 
> /assuming/ that's the order in which they need adding:

Yes, existing superblocks can be trusted.  You should show the complete 
"mdadm -E" output for each of these member devices for our reference.

> So I've tried all six permutations of the devices showing as "spare" at 
> the end and I can never get a sensible filesystem out when I do a --create.
> 
> Does anyone have any other ideas, or can offer some wisdom into what to 
> do next? Otherwise I'm writing a shell script to test all 5040 
> permutations...

It isn't just order that matters.   You must get the right data offset 
and chunk size.  Defaults have changed over the years, and offsets 
typically change (+/- 1 chunk) during reshapes.

You'll probably have to manually specify this stuff.  Be sure to use the 
latest released version of mdadm, even if you have to compile it yourself.

If your data offsets are at least a couple megabytes, consider 
partitioning these disks at the same time as you reconstruct--simply 
adjust the data offset for the start sector of the partition.  This will 
avoid future issues with stupid mobos.  (You aren't the first to suffer 
from this.)

Phil
