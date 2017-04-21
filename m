From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: GET_ARRAY_INFO assumptions?
Date: Fri, 21 Apr 2017 12:13:25 -0400
Message-ID: <50dd0cec-917a-bf78-be5e-e1feaea0be5d@gmail.com>
References: <ab07d303-85fb-e912-e4fa-9ee66a1277cc@gmail.com>
 <20170413203742.wg6mrnzedw7ew5ky@kernel.org>
 <0c3633e4-df8c-c59a-17d4-917495931ba1@gmail.com>
 <c0a29266-fdf4-2f07-aabd-6aa1f55d7d46@gmail.com>
 <87k26itx2v.fsf@notabene.neil.brown.name>
 <59ca76c6-1f1f-4d9c-4eb9-d468131e0d55@gmail.com>
 <87k26esqac.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k26esqac.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/20/2017 05:49 PM, NeilBrown wrote:
> On Thu, Apr 20 2017, Jes Sorensen wrote:
>
>>
>> I think I got it right this time and pushed it into git. It made things
>> a lot prettier too IMHO :)
>>
>> In the process I also changed the behavior of
>> sysfs_read(GET_ARRAY_STATE) as I really didn't like how it was copying
>> in the string rather than parsing it.
>>
>> I am traveling at the moment and don't yet have my new raid test box
>> setup back at the office, so my testing is limited. If I broke something
>> badly, feel free to throw rotten tomatoes at me.
>>
>> Cheers,
>> Jes
>
> Looks good to me, except...
>
> 	/*
> 	 * Beware map_name() uses strcmp() so active-idle must come before
> 	 * active, to be detected correctly.
> 	 */
>
> ???
> If map_name() used strncmp() you might need to be careful, but not with
> strcmp.

Hmmm I should know better than that! I did work on glibc back in the day 
after all :(

> Also:
>
> int map_name(mapping_t *map, char *name)
> {
> 	while (map->name) {
> 		if (strcmp(map->name, name)==0)
> 			return map->num;
> 		map++;
> 	}
>
> 	return map->num;
> }
>
> Both returns do the same thing... so there should (could) just be one.
> is:
>
>  while (map->name && strcmp(map->name, name) != 0)
>  	map++;
>  return map->num;
>
> too terse??

Looks good to me - applied a patch for it.

> I do like that you could use map_name to parse the array_state file.

I actually had it done first with a large if list, but then discovered 
maps.c and felt I had to change it :)

Cheers,
Jes


> Thanks,
> NeilBrown
>

