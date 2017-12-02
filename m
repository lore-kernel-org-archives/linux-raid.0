From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5 devices assemble into RAID0 array
Date: Sat, 2 Dec 2017 11:52:01 -0500
Message-ID: <59cff63b-a81c-5e1a-8821-e956d17d8b9e@turmel.org>
References: <c1ae7110-8f62-9afd-2e4c-092256212153@evenson.tk>
 <5A1AADCF.8090405@youngman.org.uk>
 <3d9c7310-ffe9-d79e-ff75-0a95b5c5170a@evenson.tk>
 <5A1B2DFC.6090702@youngman.org.uk>
 <449af583-e7d6-236e-3ac2-d5da1bd7caf6@evenson.tk>
 <ae2695e2-5fdd-b6a8-bb58-75ab3fe0d027@evenson.tk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ae2695e2-5fdd-b6a8-bb58-75ab3fe0d027@evenson.tk>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Duane <duane@evenson.tk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/30/2017 04:39 PM, Duane wrote:
> I need to tie off this thread.
> 
> I got my data. I ended up manually (scriptly) merging all the strips.
> 
> On later test RAID5 arrays, I removed all the devices. Then I recorded
> the configuration of the array from the metadata in the devices. I
> cleared the superblocks on the devices and then recreated the array. Of
> importance were level, chunk size, and device order. Data offset and
> layout were the default so I didn't specify them. The data area was not
> changed and, with the same configuration as the last array, was in a
> sane format.

Well done.  Based on your OP, this was the correct solution.  { Sorry I
couldn't contribute this week -- business travel. }

> ************************************************************
> 
> Therefore, from my experience, the best way to recover a FAILED array is
> to recreate a new array with the same devices and settings.

No, most people don't deliberately fail a device out of an array that's
already degraded.  That's an operator error that deleted the device role
information needed for any variation of --assemble.

Manual --assemble in its various forms is always preferred over
--create, and if there was any reshape in progress, the only way to succeed.

The key to successful use of --create --assume-clean is to fully
understand all of the array settings and member device order, in a
situation where the layout is unmixed.  You were paranoid enough to
collect and use these details.  You didn't have a reshape in progress.
You are extremely rare.

This mailing list is full of horror stories from people who ask for help
*after* using --create --assume-clean in their recovery attempts, and
who had *not* collected the necessary details.  --create blows away the
prior superblocks, preventing collection of those details after the fact.

So NO, --create is rarely the "best way" to recover a failed array.

Phil
