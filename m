From: Charles Polisher <cpolish@surewest.net>
Subject: Re: RAID performance - new kernel results
Date: Sun, 10 Mar 2013 08:35:18 -0700
Message-ID: <20130310153518.GQ5411@kevin>
References: <51134E43.7090508@websitemanagers.com.au>
 <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com>
 <51137FB8.6060003@websitemanagers.com.au>
 <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com>
 <5113A2D6.20104@websitemanagers.com.au>
 <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com>
 <51150475.2020803@websitemanagers.com.au>
 <5120A84E.4020702@websitemanagers.com.au>
 <20776.59138.27235.908118@quad.stoffel.home>
 <5130D2EB.1070507@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5130D2EB.1070507@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: John Stoffel <john@stoffel.org>, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mar 02, 2013 Adam Goryachev wrote:
> On 24/02/13 02:57, John Stoffel wrote:
> > Can I please ask you to sit down and write a paper for USENIX on this
> > whole issue and how you resolved it?  You and Stan have done a great
> > job here documenting and discussing the problems, troubleshooting
> > methods and eventual solution(s) to the problem.  
> > 
> > It would be wonderful to have some diagrams to go with all this
> > discussion, showing the original network setup, iSCSI disk setup,
> > etc.  Then how to updated and changed thing to find bottlenecks. 
> > 
> > The interesting thing is the complete slowdown when using LVM
> > snapshots, which points to major possibilities for performance
> > improvements there.  But those improvements will be hard to do without
> > being able to run on real hardware, which is expensive for people to
> > have at home.  
> > 
> > I've been following this discussion from day one and really enjoying
> > it and I've learned quite a bit about iSCSI, networking and some of
> > the RAID issues.  I too run Debian stable on my home NFS/VM/mail/mysql
> > server and I've been getting frustrated by how far back it is, even
> > with backports.  I got burned in the past by testing, which is why I
> > stay on stable, but now I'm feeling like I'm getting burned on stable
> > too.  *grin*  It's a balancing act for sure!

Hi Adam, John, and Stan,

I too have been poring over this thread for weeks while building and
testing arrays in my lab, trying techniques you've been tossing
around, diagramming hardware & software, and generating plots of
the results. It's quite interesting work though friends are
asking pointed questions about where I've been. 

Last night's episode was tweaking the IO queue scheduler -- with
a raid0-on-raid5x2 I saw a 40% boost in IOPS for 80/20 mix of
random read/write (noop vs cfq).

> I've never writen anything like that, but I think I could write a book
> on this. I keep thinking I should get a blog and put stuff like this on
> there, but there is always something else to do, and I'm not the sort of
> person to write in my diary every day :)
> 
> I've already written up a sort of non-technical summary for the client
> (about 5 pages), and just sent a non-detailed technical summary to the
> list. Once everything is completed and settled, I can try and combine
> those two, maybe throw in a bunch of extra details (command lines,
> config files, etc), and see where it ends up. I suppose you are
> volunteering as editor <G>

I can assist with testbeds, scripts, and visualizations that
support this process. I also have some editing skills. My
personal goal for this year (and maybe next) is to build an open
source tool that takes a system description, projects figures of
merit (price, performance, reliability) for specified workloads,
and scripts the setup, benching, data collection, and
visualization tasks. It seems there could be a lot of overlap
between my project and what is needed to put together an article.
Contact me if you'd like to explore working together.

Lastly, Adam: If MS Active Directory 2003 has any large group
objects (> 500 members), there can be large peaks in replication
traffic when group memberships change. There are other scenarios
for AD 2003 high-traffic issues. You could try using MS's
typeperf command line utility or their performance monitor GUI
to check the "DRA" inbound and outbound traffic during periods
of high disk/net activity. Also from experience you might check
if high CPU is related to anti-virus software that hasn't been
fenced out from checking the DIT.

Best regards,
-- 
Charles Polisher


