From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or destructive
 result?
Date: Sun, 31 Mar 2013 12:41:28 -0500
Message-ID: <51587548.3060306@hardwarefreak.com>
References: <16639206.20.1364400094382.JavaMail.root@zimbra> <51534450.8050905@hardwarefreak.com> <CAK2H+eczN+fqWJv0r6WTA871R__jrrybS9ObdZ9dx6mX+Z=HHw@mail.gmail.com> <51535252.2080105@hardwarefreak.com> <CAK2H+ecbcH-dqM6OAcip68-NkRf8w3eDC7ZCx0-QGteKURXvpw@mail.gmail.com> <51536DDD.5010800@hardwarefreak.com> <CAK2H+edehoVSrEbD_Hh_rE79V0MvgHPcrxNJiOh7_suhGdAXSA@mail.gmail.com> <51585CB9.5020208@hardwarefreak.com> <CAK2H+efkcjobknaWBupLQpxPkM+m_9JMDGwY1sH9UWw4tc=Czw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+efkcjobknaWBupLQpxPkM+m_9JMDGwY1sH9UWw4tc=Czw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/31/2013 12:15 PM, Mark Knecht wrote:
> On Sun, Mar 31, 2013 at 8:56 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 3/27/2013 5:18 PM, Mark Knecht wrote:
> <SNIP>
>>> Is there a way for me to measure, say over a whole day or some fixed
>>> time, what the workload really looks like?
>>
>> That's not the way to go about this.
>>
> OK
> 
>>> The machine is a basic Gentoo desktop machine running KDE. The only
>>> workload where I really care about performance is that I run a bunch
>>> of Virtualbox Win 7 & Win XP VMs where I need to the performance to be
>>> as good as I can reasonably get. The problem I have is these VMs are
>>> either 1 huge file (40-50GB in a single file) or many 2GB files. I
>>> haven't a clue how Windows & Virtualbox is accessing what it sees as a
>>> virtual drive and then underlying that how the vbox drivers are using
>>> the system to get to the RAID.
>>
>> So you have a bunch of Windows VM guests that write to large sparse
>> files residing on what, EXT4?  NTFS block size is 4KB so that's your
>> smallest IO.
>>
> 
> Currently EXT3 based on my starting point 2 years ago and never having
> changed. I'm open to EXT4 if this discussion show me it warrants the
> work. Would rather not deal with anything more exotic right now.

Doesn't make a difference here.

>>> It would be interesting to set some program running, probably on a
>>> weekend or sometime when performance isn't so critical, and see what
>>> sort of data gets collected, assuming there's a program that does that
>>> sort of thing.
>>
>> Again, that's not the way to approach this.  What would be informative
>> to know is what applications you're running in these Windows VMs.  The
>> application dictates the write pattern.  You don't need a "collector" to
>> tell you that.  You just need to know the application(s).  If you're
>> just running productivity apps (web/mail/pdf/etc) inside these VMs then
>> there's nothing to optimize WRT RAID stripe parameters as you have no
>> sustained write IO.  So what are the Windows apps?
> 
> Currently 3 VMs, but only 2 matter for performance. The one that
> doesn't matter is a VMWare Player VM used for things like watching
> Netflix & Hulu. Nothing much more than that. 1 CPU core dedicated. CPU
> usage is generally low. I haven't paid much attention to disk usage
> for this VM but will check it out.
> 
> Performance VMs:
> 
> 1) This first VM primarily runs TradeStation, a rules-based trading
> platform for trading stocks & futures. I generally run with 2-4 CPU
> cores and almost never uses much computational power. The big deal in
> this VM is stock data caching with years or even decades of data for
> each stock or futures contract. Currently this cache appears to be
> sitting in a single file which is about 3GB in size. This data streams
> into the VM over the net when the markets are open (pretty much 24/7)
> and the cache grows. Depending on the type of market and chart the
> data might be as fine grained as each individual trade taking place
> that day, or it might only be updated once every bar. (1 minute bar, 5
> minute bar, daily bar, etc.) TradeStation reads the cache as it needs
> data. I have no idea what the access looks like in real time but
> generally I expect that it's accessing the data in date order. Whether
> the data is sorted or not in this cache file I have no idea.
> 
> 2) This second VM is more computational in nature. It primarily runs
> two apps for long periods of time, although I don't think either app
> is all that disk intensive. Noth apps read market data once from disk,
> cache it in memory and then computer for hours to days depending on
> what I'm asking them to do. I will say I don't see a lot of disk
> activity lights when either of these programs are running.
> 
> - Adaptrade Builder - a genetic optimization program that attempts to
> generate TradeStation EasyLanguage trading strategies. I believe that
> once it has the market data in memory it's using memory and disk to
> store interesting strategies for me to look at later. The output of
> the program is generally a single file ranging in size from 1MB to
> maybe 50MB.
> 
> - TradingSolutions - a neural network program that attempts to
> generate neural network models for trading markets. Each instance of
> this program (I typically run 2-3 instances) generally has access to
> one file sized 25MB-200MB plus a lot (50-100) small files under 20K in
> size. I have no idea how often any of these programs are read or
> written. The program runs for hours doing it's work.
> 
> I suppose there are other things that happen in the VMs. I run Excel a
> lot, but it's not a lot of data.
> 
> Hopefully that gives you enough info to suggest a direction.

These applications append small data slowly over a long period of time,
which usually means fragmentation.  Thus there's not much to optimize at
the chunk/stripe level, other than keeping chunk size small to spread
random reads over all platters.  You currently have a 16KB chunk, IIRC,
which is about as good as you'll get for this workload.  Given your
applications' low write throughput chunk/strip really doesn't matter.

-- 
Stan

