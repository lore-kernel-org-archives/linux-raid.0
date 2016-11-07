From: Phil Turmel <philip@turmel.org>
Subject: Re: clearing blocks wrongfully marked as bad if --update=no-bbl can't
 be used?
Date: Sun, 6 Nov 2016 22:36:38 -0500
Message-ID: <19a0bd5b-5046-46ba-3050-078330fa8682@turmel.org>
References: <20161030161929.GA5582@metamorpher.de>
 <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
 <20161030171234.GD28648@merlins.org> <20161030171654.GE28648@merlins.org>
 <20161104181808.lplrtmafwlub3ck4@merlins.org>
 <90cf5c8f-fcd3-d510-7f6e-6be6ade3969f@turmel.org>
 <20161104185040.yrznk3j4rvtwsxbk@merlins.org> <20161104235917.2d6d0fcc@natsu>
 <20161104195127.ymenm7ezmhscbzn6@merlins.org>
 <87lgwwnnyf.fsf@notabene.neil.brown.name>
 <20161107011342.fld53ntd3djrctb2@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161107011342.fld53ntd3djrctb2@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, NeilBrown <neilb@suse.com>
Cc: Roman Mamedov <rm@romanrm.net>, Neil Brown <neilb@suse.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/06/2016 08:13 PM, Marc MERLIN wrote:
> On Mon, Nov 07, 2016 at 11:16:56AM +1100, NeilBrown wrote:

>> Is this a 32bit system you are using?  Such systems can only support
>> buffered IO up to 8TB.  If you use iflags=direct to avoid buffering, you
>> should get access to the whole device.
> 
> You found the problem, and you also found the reason why btrfs_tools
> also fails past 8GB. It is indeed a 32bit distro. If I put a 64bit
> kernel with the 32bit userland, there is a weird problem with a sound
> driver/video driver sync, so I've stuck with 32bits.

Huh.  Learn something new every day, I suppose.  Never would have
thought of this.  Thanks, Neil.

Phil

