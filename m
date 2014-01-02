From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: How to prefer some devices over others in raid
Date: Thu, 02 Jan 2014 08:30:24 -0600
Message-ID: <52C57800.3090802@hardwarefreak.com>
References: <CAL1oBhr+V0NQ1zG4LVP8qFT3_wsMHnqhUkZafVibtk0oCDGg5Q@mail.gmail.com> <52C2E00B.90406@hardwarefreak.com> <CAL1oBhrVUTK5ayU=sgmVgP0Xu5eh1nGcfRjQSYALXXJMVE03+w@mail.gmail.com> <52C44708.3030307@hardwarefreak.com> <CAL1oBhovXZhnKMqzoYt=7N5ZHeyX76LK+1LNYMRmcQGGqs7W3w@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAL1oBhovXZhnKMqzoYt=7N5ZHeyX76LK+1LNYMRmcQGGqs7W3w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomas M <tomas@slax.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/1/2014 12:00 PM, Tomas M wrote:
>> Your initial post suggested you knew which drive was flaky.  Now you
>> indicate you don't know which, if any, is flaky.  This suggests you have
>> no idea why your array is slow.
> 
> Well, I always have an indication which drive is flaky, based on dmesg
> output (e.g. hard resetting ATA3 link, etc). However, sometimes it
> reports that more than one drive has problems
[snip]

Full stop.

Random resets on multiple links indicates a backplane (if present),
HBA/controller, or cable problem, not a drive problem.  If you're using
an HBA+backplane with an SFF-8087 4x multilane cable, or a breakout
cable, the problem could be as simple as a lose connection at the
SFF-8087 multilane connector, or a cable gone bad.  If you have multiple
discrete SATA cables, one per drive, this indicates a problem with the
controller/HBA.

Ergo, if you have a multilane cable, unplug/replug it and see if that
helps.  If not, replace it.  If that doesn't solve the problem, replace
the HBA.  If replacing the HBA doesn't solve it, replace the backplane.

If you have discrete cables, replacing the HBA should fix the problem.
If you have discrete cables and are using motherboard SATA ports, you'll
need to acquire an HBA and cease using the motherboard ports.

-- 
Stan
