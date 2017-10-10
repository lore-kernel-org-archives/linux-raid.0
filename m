From: "John Stoffel" <john@stoffel.org>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Mon, 9 Oct 2017 22:01:24 -0400
Message-ID: <23004.10740.53750.440109@quad.stoffel.home>
References: <22997.8664.67459.119616@quad.stoffel.home>
        <87a81637lq.fsf@notabene.neil.brown.name>
        <23002.37193.492253.120639@quad.stoffel.home>
        <87shetz207.fsf@notabene.neil.brown.name>
        <23002.53075.413063.6948@quad.stoffel.home>
        <87h8v9yn91.fsf@notabene.neil.brown.name>
        <c476e0a8-ff57-e38d-f3d7-0c59242cc0b9@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c476e0a8-ff57-e38d-f3d7-0c59242cc0b9@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.com>, John Stoffel <john@stoffel.org>, Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Phil" == Phil Turmel <philip@turmel.org> writes:

Phil> On 10/09/2017 12:10 AM, NeilBrown wrote:
>> If there is some action that mdadm can currently be told to perform, and
>> when it tries to perform that action it corrupts the array, then
>> it is certainly appropriate to teach mdadm not to perform that action.
>> It shouldn't even perform that action with --force.   I agree that
>> changing mdadm like this is complementary to changing the kernel.  Both
>> are useful.

Phil> A certain amount of the trouble with all of this is the english meaning
Phil> of "grow" doesn't really match what mdadm allows.

Phil> Might it be reasonable to reject "--grow" operations that reduce the
Phil> final array size, and introduce the complementary "--reduce" operation
Phil> that rejects array size increases?

I like this idea!  And it wouldn't be hard to implement in mdadm.  

Phil> Both operations would share the current code, just apply a different
Phil> sanity check before proceeding.

Phil> mdadm would then at least not violate the rule of least surprise.

