From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance - new kernel results
Date: Sat, 02 Mar 2013 03:10:19 +1100
Message-ID: <5130D2EB.1070507@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <20776.59138.27235.908118@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20776.59138.27235.908118@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/02/13 02:57, John Stoffel wrote:
> 
> Adam,
> 
> Can I please ask you to sit down and write a paper for USENIX on this
> whole issue and how you resolved it?  You and Stan have done a great
> job here documenting and discussing the problems, troubleshooting
> methods and eventual solution(s) to the problem.  
> 
> It would be wonderful to have some diagrams to go with all this
> discussion, showing the original network setup, iSCSI disk setup,
> etc.  Then how to updated and changed thing to find bottlenecks. 
> 
> The interesting thing is the complete slowdown when using LVM
> snapshots, which points to major possibilities for performance
> improvements there.  But those improvements will be hard to do without
> being able to run on real hardware, which is expensive for people to
> have at home.  
> 
> I've been following this discussion from day one and really enjoying
> it and I've learned quite a bit about iSCSI, networking and some of
> the RAID issues.  I too run Debian stable on my home NFS/VM/mail/mysql
> server and I've been getting frustrated by how far back it is, even
> with backports.  I got burned in the past by testing, which is why I
> stay on stable, but now I'm feeling like I'm getting burned on stable
> too.  *grin*  It's a balancing act for sure!

I've never writen anything like that, but I think I could write a book
on this. I keep thinking I should get a blog and put stuff like this on
there, but there is always something else to do, and I'm not the sort of
person to write in my diary every day :)

I've already written up a sort of non-technical summary for the client
(about 5 pages), and just sent a non-detailed technical summary to the
list. Once everything is completed and settled, I can try and combine
those two, maybe throw in a bunch of extra details (command lines,
config files, etc), and see where it ends up. I suppose you are
volunteering as editor <G>

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
