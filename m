From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is this expected RAID10 performance?
Date: Mon, 10 Jun 2013 04:23:21 -0500
Message-ID: <51B59B09.5070903@hardwarefreak.com>
References: <CAO9HMNEThHrtzCK1A16uSxxHTBY-XxoCgpdV6u5PAhtWK=OuTQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNEThHrtzCK1A16uSxxHTBY-XxoCgpdV6u5PAhtWK=OuTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/9/2013 6:53 PM, Steve Bergman wrote:
>> This is almost certainly a result of forced IDE mode.  With this you end
> up with a master/slave setup between the drives on each controller, and
> all of the other overhead of EIDE.
> 
> Thank you for that. Normally, I would not pursue the issue further, as
> the server/filesystem is performing within 20%, on its most
> challenging workload, of what it can do with the workload running in a
> large tmpfs on the same machine. (I have lots of memory.) However, I'm
> now engaged in the issue sufficiently that I'll be contacting Dell
> tomorrow to ask them why we aren't getting what was advertised, and to
> see if they have any suggestions.
> 
> So, would you expect the situation to change if there was some magic
> way to make AHCI active?

I would expect AHCI mode to increase performance to a degree.  But quite
frankly I don't know Intel's system ASICs well enough to make further
predictions.  I only know such Intel ASICs from a published spec
standpoint, not direct experience or problem reports.  I typically don't
use motherboard down SATA controllers for server applications, but maybe
for the occasional mirror on a less than critical machine.  I don't
think the AHCI performance would be any worse.

As I stated previously, a ~$200 LSI HBA buys performance, flexibility,
and some piece of mind.  For a home PC it doesn't make sense to buy an
HBA at 2x the price of the motherboard.  For a business server using
either a SHV desktop board, or low end server board, it very often makes
sense.

> I will briefly address the filesystems thing. I'm not running down
> XFS. If anything, I'm shaking the bushes to see if it prompts anyone
> to tell me something that I don't know about XFS which might change my
> assessment of when it might be appropriate for my customers' use. I
> wouldn't mind at all being able to expand use of XFS in appropriate
> situations, if only to get more experience with it.

I did not say you should use XFS.  I was merely rebutting some of the
statements you made about XFS.  Ted, and others who've made similar
statements, are correct.  You pick the filesystem that best meets your
needs.  That's common sense.  I don't use XFS for my boot and root
filesystems because it doesn't fit those needs in my case.  I certainly
use it for user data.

> Beyond that, I'm not sure it would be constructive for you and me to
> continue that conversation. I've already posted my views, and
> repeating just gets... well... repetitive. ;-)

Of course not.  You've already covered all of this and much more in your
replies to Ric, Eric, etc.

Now we get to have the real discussion:  power. ;)  I know you'll have
different thoughts there, as I made some statements with very broad
general recommendations on runtimes.

-- 
Stan

