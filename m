From: David Greaves <david@dgreaves.com>
Subject: Re: raid5/lvm setup questions
Date: Mon, 07 Aug 2006 23:32:27 +0100
Message-ID: <44D7BF7B.4010408@dgreaves.com>
References: <20060805165358.GA29177@cm.nu> <44D4D5F9.9080201@dgreaves.com> <87mzagz5d2.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87mzagz5d2.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Shane <shane@cm.nu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nix wrote:
> On 5 Aug 2006, David Greaves prattled cheerily:
that's me :)
>> As an example of the cons: I've just set up lvm2 over my raid5 and whilst
>> testing snapshots, the first thing that happened was a kernel BUG and an oops...
> 
> I've been backing up using writable snapshots on LVM2 over RAID-5 for
> some time. No BUGs.
I tried but it didn't recurr.
I sent a report to lkml.

> I think the blame here is likely to be layable at the snapshots' door,
> anyway: they're still a little wobbly and the implementation is pretty
> complex: bugs surface on a regular basis.
Hmmm. Bugs in a backup strategy. Hmmm.

I think I can live with a nightly shutdown of the daemons whilst rsync does it's
stuff across the LAN.

David


-- 
