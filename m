From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Tue, 10 Oct 2017 16:58:14 -0400
Message-ID: <52f93e96-ae12-4131-b6db-ac33877cfbda@turmel.org>
References: <22997.8664.67459.119616@quad.stoffel.home>
 <87a81637lq.fsf@notabene.neil.brown.name>
 <23002.37193.492253.120639@quad.stoffel.home>
 <87shetz207.fsf@notabene.neil.brown.name>
 <23002.53075.413063.6948@quad.stoffel.home>
 <87h8v9yn91.fsf@notabene.neil.brown.name>
 <c476e0a8-ff57-e38d-f3d7-0c59242cc0b9@turmel.org>
 <871smaybig.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871smaybig.fsf@notabene.neil.brown.name>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, John Stoffel <john@stoffel.org>
Cc: Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/2017 04:48 PM, NeilBrown wrote:
> On Mon, Oct 09 2017, Phil Turmel wrote:

>> Might it be reasonable to reject "--grow" operations that reduce the
>> final array size, and introduce the complementary "--reduce" operation
>> that rejects array size increases?
> 
> While there is a lot to like about this approach, one problem is that
> some "grow" operations do not change the size. They might, e.g., just change
> the chunksize.

I tried to word my proposal to address that -- either keyword could
accept operations that didn't change the size.

> I guess you could have --grow --reduce --reshape.
> 
> I wouldn't object to such a change.

Jes has weighed in as opposed.  Sigh.

Phil
