From: Mike Hardy <mhardy@h3c.com>
Subject: Re: migrating raid-1 to different drive geometry ?
Date: Tue, 25 Jan 2005 10:13:44 -0800
Message-ID: <41F68C58.4040708@h3c.com>
References: <20050124145910.GC29766@kaneda> <16885.31484.125772.316987@cse.unsw.edu.au> <ct447m$l90$1@sea.gmane.org> <41F598BC.3040805@h3c.com> <ct4vhu$c62$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ct4vhu$c62$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Robin Bowes wrote:
> Mike Hardy wrote:
>> To grow component count on raid5 you have to use raidreconf, which can 
>> work, but will toast the array if anything goes bad. I have personally 
>> had it work, and not work, in different instances. The failures were 
>> not necessarily raidreconf's fault, but its not fault tolerant is the 
>> point, as it starts at the first stripe, laying things out the new 
>> way, and if it doesn't finish, and finish correctly, you are in an 
>> irretrievable inconsistent state.
>>
> 
> Bah, too bad.
> 
> I don't need it yet, but at some stage I'd like to be able to add 
> another 250GB drive(s) to me array and grow the array to use the 
> additional space in a safe/failsafe way.
> 
> Perhaps by the time I come to need it this might be possible?

Well, I want to be clear here, as who ever wrote raidreconf deserves 
some respect, and I don't want to appear to be disparaging it.

raidreconf works. I'm not aware of any bugs in it.

Further, if mdadm was to implement the feature of adding components to a 
raid5 array, I'm guessing it would look exactly the same as raidreconf, 
simply because of the work it has to do (re-configuring each stripe, 
moving parity blocks and data blocks around, etc). Its just the way the 
raid5 disk layout is.

So, since raidreconf does work, its definitely possible now, but you 
have to make absolutely amazingly sure of three things:

1) the component size you add is at least as large as the rest of the 
components (it'll barf at the end if not)
2) the old and new configurations you feed raidreconf are perfect (or 
what happens is undefined)
3) you have absolutely no bad blocks on any component, as it will read 
each block on each component and write each block on each component. 
(that's a tall order these days, if you get a bad block, what can it do?)

If any of those things go bad, your array goes bad, but its not the 
algorithm's fault, as far as I can tell. Its constrained by the 
problem's requirements. So I'd add:

4) you have a perfect, fresh backup of the array ;-)

Honestly, I've done it, and it does work, its just touchy. You can 
practice with it with loop devices (check for a raid5 loop array creator 
and destructor script I posted a week or so back) if you want to see it.

-Mike
