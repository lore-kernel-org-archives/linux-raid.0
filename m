From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or destructive
 result?
Date: Sun, 31 Mar 2013 10:56:41 -0500
Message-ID: <51585CB9.5020208@hardwarefreak.com>
References: <16639206.20.1364400094382.JavaMail.root@zimbra> <51534450.8050905@hardwarefreak.com> <CAK2H+eczN+fqWJv0r6WTA871R__jrrybS9ObdZ9dx6mX+Z=HHw@mail.gmail.com> <51535252.2080105@hardwarefreak.com> <CAK2H+ecbcH-dqM6OAcip68-NkRf8w3eDC7ZCx0-QGteKURXvpw@mail.gmail.com> <51536DDD.5010800@hardwarefreak.com> <CAK2H+edehoVSrEbD_Hh_rE79V0MvgHPcrxNJiOh7_suhGdAXSA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+edehoVSrEbD_Hh_rE79V0MvgHPcrxNJiOh7_suhGdAXSA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/27/2013 5:18 PM, Mark Knecht wrote:
> On Wed, Mar 27, 2013 at 3:08 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 3/27/2013 4:06 PM, Mark Knecht wrote:
>>
>>> All that said, I still don't really know if I was starting over today
>>> how to choose a new chunk size. That still eludes me. I've sort of
>>> decided that's one of those things that make you guys pros and me just
>>> a user. :-)
>>
>> Chunk size is mostly dictated by your workload IO patterns, and the
>> number and latency of your spindles.
> 
> Is there a way for me to measure, say over a whole day or some fixed
> time, what the workload really looks like?

That's not the way to go about this.

> The machine is a basic Gentoo desktop machine running KDE. The only
> workload where I really care about performance is that I run a bunch
> of Virtualbox Win 7 & Win XP VMs where I need to the performance to be
> as good as I can reasonably get. The problem I have is these VMs are
> either 1 huge file (40-50GB in a single file) or many 2GB files. I
> haven't a clue how Windows & Virtualbox is accessing what it sees as a
> virtual drive and then underlying that how the vbox drivers are using
> the system to get to the RAID.

So you have a bunch of Windows VM guests that write to large sparse
files residing on what, EXT4?  NTFS block size is 4KB so that's your
smallest IO.

> It would be interesting to set some program running, probably on a
> weekend or sometime when performance isn't so critical, and see what
> sort of data gets collected, assuming there's a program that does that
> sort of thing.

Again, that's not the way to approach this.  What would be informative
to know is what applications you're running in these Windows VMs.  The
application dictates the write pattern.  You don't need a "collector" to
tell you that.  You just need to know the application(s).  If you're
just running productivity apps (web/mail/pdf/etc) inside these VMs then
there's nothing to optimize WRT RAID stripe parameters as you have no
sustained write IO.  So what are the Windows apps?

-- 
Stan


