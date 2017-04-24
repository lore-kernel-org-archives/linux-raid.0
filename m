From: Phil Turmel <philip@turmel.org>
Subject: Re: Recover array after I panicked
Date: Mon, 24 Apr 2017 19:35:39 -0400
Message-ID: <68e48836-3c18-e07a-6378-06d6d7a2c9b9@turmel.org>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
 <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
 <20170423104606.GA4603@metamorpher.de>
 <754209bb-9990-2a36-2233-d7d1273c8e37@powerlamerz.org>
 <58FC91B8.5090603@youngman.org.uk> <20170423165810.75b5836e@natsu>
 <58FC99ED.7080705@youngman.org.uk>
 <e4c2acc6-420a-e454-fe74-c82737a1bbf0@powerlamerz.org>
 <09feff90-bb2b-7e27-599e-40284ca004ae@turmel.org>
 <a88537bc-a133-482a-e726-7d3680727af6@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a88537bc-a133-482a-e726-7d3680727af6@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>, Wols Lists <antlists@youngman.org.uk>, Roman Mamedov <rm@romanrm.net>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/24/2017 05:56 PM, Patrik Dahlström wrote:
> On 04/24/2017 11:04 PM, Phil Turmel wrote:

>> Thanks for the patch.  Could you elaborate a bit on the errors you
>> received so I can reproduce and document this fully?
> Sure. It started out with this error:
> $ ./lsdrv
> Traceback (most recent call last):
>   File "./lsdrv", line 413, in <module>
>     probe_block('/sys/block/'+x)
>   File "./lsdrv", line 389, in probe_block
>     blk.FS = "MD %s (%s/%s)%s %s" % (blk.array.md.LEVEL, blk.slave.slot,
> blk.array.md.raid_disks, peers, blk.slave.state)
> AttributeError: 'NoneType' object has no attribute 'LEVEL'

Ok.  I'll spin up an Ubuntu 16.04 VM to play with this.  Thanks.

>> Also, do you have some large files (media files, perhaps) that you know
>> are in your array but you have a copy in hand?  If so, you could use the
>> findHash script in my github account to map how that file is laid out on
>> your array's devices.  Since large media files tend to be contiguous,
>> such a map would definitively show your chunk size and device order.

> I'll take a look. I definitely have some large continuous files on this
> array.

The first draft of this script was written for a fellow in a situation
very similar to yours.  The results were miraculous.  Not to get your
hopes up too high, though -- my first impression of this thread is that
you're screwed. /-:

Phil

