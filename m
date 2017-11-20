From: Phil Turmel <philip@turmel.org>
Subject: Re: Unexpected mdadm behavior with old replugged disc
Date: Sun, 19 Nov 2017 21:08:47 -0500
Message-ID: <b4a26841-6c5c-e986-d182-e2c6c4c32c71@turmel.org>
References: <239f7f18-00d3-254a-e460-24b40e9db5e1@walther.xyz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <239f7f18-00d3-254a-e460-24b40e9db5e1@walther.xyz>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Walther <matthias@walther.xyz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/18/2017 09:35 AM, Matthias Walther wrote:
> Hello,
> 
> I just signed up for this mailing list to discuss the following,
> unexpected behavior:
> 
> Situation: Raid6 with 6 discs. For some reasons, which are unimportant,
> I had replaced a disc before, which was fully functional. This disc was
> never changed or written to in between.
> 
> Today I replugged this particular disc additionally as 7th disc to the
> server (cold plug, server was switched off).
> 
> Unexpectedly mdadm broke up my fully synced raid6 and now syncs back to
> this old disc dropping one of the newer discs from the raid.
> 
> This might be because it has its uuid still stored with higher rank than
> the newer disc or because the old disc got a lower sdX slot. I don't
> know that in detail.

This is called split-brain, as there's insufficient information for
mdadm to tell when it encounters this disk during startup to discard
this disk if it shows up before the other in that device role.  You're
lucky it was a raid6 instead of a mirror, as you can really get screwed
in that case.

It's not a question of rank, simply the order of device discovery on boot.

The correct (and only) solution is to clean off your UUIDs with
--zero-superblock if a removed device is actually still working.

Phil
