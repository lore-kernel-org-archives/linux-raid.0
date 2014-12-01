From: Phil Turmel <philip@turmel.org>
Subject: Re: upgrading a RAID array in-place with larger drives.  request
 for review of my approach?
Date: Mon, 01 Dec 2014 08:47:07 -0500
Message-ID: <547C715B.6050309@turmel.org>
References: <1417402553.1412807.197119853.0D7A911E@webmail.messagingengine.com> <21627.57456.206853.819767@quad.stoffel.home> <1417406691.1429321.197136309.39C9A098@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1417406691.1429321.197136309.39C9A098@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: terrygalant@mailbolt.com, John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Terry,

On 11/30/2014 11:04 PM, terrygalant@mailbolt.com wrote:
> Hi John,
> 
> On Sun, Nov 30, 2014, at 07:28 PM, John Stoffel wrote:
>> If you have the ability and the power and space in the chassis, i'd
>> just add in the four new drives, set them up in their RAID10 format,
> 
> Unfortunately I don't.  I have the 4 slots and thats it :-(
> 
> If I did, it'd be pretty easy.  But no.  So that's why I'm trying to figure out how to do this right -- 'in place'.

You cannot --grow your array, as that isn't supported for the "far"
layout of raid10.  Sorry.  As you only have four slots, I recommend the
following convoluted procedure:

1) Get the new drives into the box w/ the existing array on the tail of
the space, as follows:
  a) Partition new drive w/ 2T and 1T partitions, with the latter large
enough to serve as a member of the current array.
  b) --fail and --remove the old disk.
  c) Install the new disk, --add the 1T partition to your array.
  d) Let it resync, then repeat for drives 2-4.

2) Create a new, growable array in the collection of 2T partitions.
With newer kernels, raid10,n2 should work.  Experiment with that if you
aren't sure.  Make sure you enable bitmaps.

3) Use pvcreate and vgextend to merge the new array into your existing
LVM setup.

4) Use pvmove to shift all of your volumes onto the new array.

5) Use vgreduce to drop the old array, then --stop it and destroy it.

6) Repartion each device to delete the 1T partitions and then resize the
2T over that space.  Use --fail and --re-add to keep the array happy
with minimal disruption.

7) When all resyncing is done, --grow the array then use pvresize to
activate the space.

Enjoy!

Phil

