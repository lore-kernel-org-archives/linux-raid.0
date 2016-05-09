From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] md: make the code more readable in the for-loop
Date: Mon, 09 May 2016 16:45:38 -0400
Message-ID: <wrfjd1ovrmdp.fsf@redhat.com>
References: <318e71b0.3d4e.1549071292b.Coremail.kernelpatch@126.com>
	<572FCCD3.4070907@eyal.emu.id.au> <20160509035319.GA57828@kernel.org>
	<87inynu4he.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87inynu4he.fsf@notabene.neil.brown.name> (NeilBrown's message of
	"Mon, 09 May 2016 16:31:41 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>
Cc: Shaohua Li <shli@kernel.org>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <nfbrown@novell.com> writes:
> On Mon, May 09 2016, Shaohua Li wrote:
>
>> On Mon, May 09, 2016 at 09:33:39AM +1000, Eyal Lebedinsky wrote:
>>> I do not see how this change makes it clearer. The original form is
>>> actually a very common and clear
>>> 	scan an array in reverse order
>>
>> People always have different opinions for this stuff. When I read '--j' or
>> 'j--', I always think extra time what the value of j is. So for me the change
>> actually makes the code more readable :)
>
> If the goal is to make the code more readable, you may as well make it:
>
>   for (j = 0; i < ->raid_disk; j++)
>
> That will be clearer to most people than the current code, which I don't
> think is very much clearer than the original (maybe a little bit).

I agree - I had to read the updated version multiple times to convince
myself it was doing the same thing as the original.

Cheers,
Jes
