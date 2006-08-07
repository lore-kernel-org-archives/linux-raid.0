From: Nix <nix@esperi.org.uk>
Subject: Re: raid5/lvm setup questions
Date: Mon, 07 Aug 2006 20:57:13 +0100
Message-ID: <87mzagz5d2.fsf@hades.wkstn.nix>
References: <20060805165358.GA29177@cm.nu> <44D4D5F9.9080201@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44D4D5F9.9080201@dgreaves.com> (David Greaves's message of "5 Aug 2006 18:31:52 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Shane <shane@cm.nu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5 Aug 2006, David Greaves prattled cheerily:
> As an example of the cons: I've just set up lvm2 over my raid5 and whilst
> testing snapshots, the first thing that happened was a kernel BUG and an oops...

I've been backing up using writable snapshots on LVM2 over RAID-5 for
some time. No BUGs.

I think the blame here is likely to be layable at the snapshots' door,
anyway: they're still a little wobbly and the implementation is pretty
complex: bugs surface on a regular basis.

-- 
`We're sysadmins. We deal with the inconceivable so often I can clearly 
 see the need to define levels of inconceivability.' --- Rik Steenwinkel
