From: Randy Terbush <randy@terbush.org>
Subject: Re: RAID Class Drives`
Date: Thu, 18 Mar 2010 13:43:29 -0600
Message-ID: <7db987b31003181243n159eb7e9re2b614295221eee@mail.gmail.com>
References: <7db987b31003170648j19e3346bi1050e703ef8c811c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7db987b31003170648j19e3346bi1050e703ef8c811c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Let me follow-up to share what I have learned and what I have managed
to do to get this array to re-assemble.

I've received several responses from people telling me that they don't
have any problem with their "desktop class" drives being dropped from
the array. Congratulations to you all. I suspect that there may be a
theme in the drives that  you are using which may have different error
correction, may be smaller than 500GB or may not support the SCT
command set.

One of the first responses I received privately was from a gentlemen
that gave me the hint I needed regarding the SCT-ERC command. He
shared my frustration and actually presents a very compelling example
where this is a big problem. He works to support a commercial NAS
product which uses "desktop" class drives and fights this problem
continually.

With this new knowledge gained I started digging a bit more and ran
across a set of patches to smarttools which allows editing the values
for SCT-ERC. You can find that source here:
http://www.csc.liv.ac.uk/~greg/projects/erc/
FWIW, the Seagate Barracudas that I am running have non-volatile
storage for this variable. Not that I am recommending Seagate. Far
from it....

I can confirm that all of my drives had this value "disabled" which
means it allows the drive to go off and take as much time as it needs
to fix its own problem.

I set the values to 7 seconds for the 4 drives in my array and
attempted to rebuild the array. Unfortunately, it failed again. So I
reset the values to 5 seconds and fired off the rebuild once again and
managed to get through the rebuild process.

Now this solution does not satisfy the situation where you are
hot-plugging drives, but it at least gets me over my hurdle.

Seems it would be a nice improvement to md to actually detect the
SCT-ERC setting, warn when it cannot change the value and offer to set
these to reasonable values for the RAID application.

Here's to happy storage...

On Wed, Mar 17, 2010 at 7:48 AM, Randy Terbush <randy@terbush.org> wrote:
> Greetings RAIDers,
>
> Apologies if this topic has been thrashed here before. Google is not
> showing me much love on the topic and that which I have found does not
> convey consensus. So I am coming to the experts to get the verdict.
>
> Recent event: I spent a fair amount of time on the line with Seagate
> support yesterday who informed me that their desktop drives will not
> work in a RAID array. Now I may have been living in a cave for the
> past 20 years, but I always had a modem.
>
> As I started to dig into this a bit more looking for info on TLER,
> ERC, etc. from my understanding, these "RAID class" drives simply
> don't have the same level of error correction as the "desktop"
> alternative and instead report back to the RAID controller immediately
> instead of dawdling with fixing the problem themselves.
>
> If this is true, then I can understand where this might cause a RAID
> system some problems. However, I do not understand why the RAID system
> cannot detect the type of drive it is dealing with and either disable
> the behavior on the drive or allow more time for the drive to respond
> before kicking it out of the array.
>
> Just to give some background on how I got to this point, but not to
> distract from the main question, here is where I have been...
>
> Over past 5 years, have been struggling with a 4 drive mdraid array
> configured for RAID5. This is not a busy system by any stretch. Just a
> media server for my own personal use. Started out using the SATA
> headers on the MB. Gave up and bought a cheapy hardware RAID
> controller. Thought better of that decision and went back to software
> RAID using the hardware RAID controller as a SATA expansion card. Gave
> up on that and went back to the SATA headers on the MB (had replaced
> the MB along the way).
>
> Over that period, threw out original 4 drives and replaced them with
> newer bigger Seagate Barracudas. Bought snazzier and snazzier cables
> along the way. Discovered a firmware upgrade for the Barracudas that I
> thought had recently fixed the problem.
>
> After speaking with Seagate yesterday, I booted off of the SeaTools
> image and ran tests on all drives. The two suspect drives did have
> errors that were corrected by the test software. But alas, attempting
> to reassemble this array fails, dropping one drive to failed spare
> status and another to spare which has been the behavior I have been
> fighting for years.
>
> So the question becomes, do I try it again with the replacement drives
> that Seagate is sending me, or do I hang them in my "desktop" and
> spend the money for RAID Class drives? (I've grown tired of this
> learning experience and would like to just have a dependable storage
> system)
>
> And to tag onto that question, is there any reason why mdraid cannot
> detect these "lesser" drives and behave differently?
>
> Why would these drives be developing errors as a result of their
> tortuous experience in a RAID array?
>
> Thanks for any light you can shed on this issue.
>
> -Randy
>
