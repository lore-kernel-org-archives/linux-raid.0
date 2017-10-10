From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Tue, 10 Oct 2017 16:09:37 -0400
Message-ID: <7b231d36-1434-0de0-2f7a-195a4f649d35@gmail.com>
References: <22997.8664.67459.119616@quad.stoffel.home>
 <87a81637lq.fsf@notabene.neil.brown.name>
 <23002.37193.492253.120639@quad.stoffel.home>
 <87shetz207.fsf@notabene.neil.brown.name>
 <23002.53075.413063.6948@quad.stoffel.home>
 <87h8v9yn91.fsf@notabene.neil.brown.name>
 <c476e0a8-ff57-e38d-f3d7-0c59242cc0b9@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c476e0a8-ff57-e38d-f3d7-0c59242cc0b9@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>, John Stoffel <john@stoffel.org>
Cc: Eli Ben-Shoshan <eli@benshoshan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/09/2017 04:04 PM, Phil Turmel wrote:
> On 10/09/2017 12:10 AM, NeilBrown wrote:
> 
>> If there is some action that mdadm can currently be told to perform, and
>> when it tries to perform that action it corrupts the array, then
>> it is certainly appropriate to teach mdadm not to perform that action.
>> It shouldn't even perform that action with --force.   I agree that
>> changing mdadm like this is complementary to changing the kernel.  Both
>> are useful.
> 
> A certain amount of the trouble with all of this is the english meaning
> of "grow" doesn't really match what mdadm allows.
> 
> Might it be reasonable to reject "--grow" operations that reduce the
> final array size, and introduce the complementary "--reduce" operation
> that rejects array size increases?
> 
> Both operations would share the current code, just apply a different
> sanity check before proceeding.

"grow" in mdadmlish translates to reshape/resize in English. Starting to 
introduce new keywords for this really makes no sense and just cause 
confusion, so I am not going to support that.

Jes

