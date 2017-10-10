From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Tue, 10 Oct 2017 09:12:29 -0400
Message-ID: <4d469f4b-0ad9-257a-8370-65555d8eea09@turmel.org>
References: <22997.8664.67459.119616@quad.stoffel.home>
 <87a81637lq.fsf@notabene.neil.brown.name>
 <23002.37193.492253.120639@quad.stoffel.home>
 <87shetz207.fsf@notabene.neil.brown.name>
 <23002.53075.413063.6948@quad.stoffel.home>
 <87h8v9yn91.fsf@notabene.neil.brown.name>
 <c476e0a8-ff57-e38d-f3d7-0c59242cc0b9@turmel.org>
 <20171010000702.GA6038@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171010000702.GA6038@animx.eu.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: NeilBrown <neilb@suse.com>, John Stoffel <john@stoffel.org>, Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/09/2017 08:07 PM, Wakko Warner wrote:
> On a side note, is it possible for the lower layers to know what the last
> used sector is?

No.  Upper layers can use the device content in any order desired.

> IE lvm ontop of raid and has 10% allocated and the last
> sector is around the 10% mark.  (If this were possible --force would be,
> required if shrinking would result in inaccessible data)

LVM has a number of allocation policies, including selecting space at
the end instead of beginning.  And it won't relocate anything (on its
own) when gaps open.  Lower layers simply can't assume anything at all.

> I recently did a shrink of 4x 2tb drives so that I could replace the 2tb
> drives with 80gb drives (yes, big shrink!)  Would have been nice for mdadm
> to know the smallest size was that wouldn't destroy my lvm volumes that were
> on top.

Only LVM can know.

Phil
