From: keld@keldix.com
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Thu, 15 Mar 2012 18:40:08 +0100
Message-ID: <20120315174008.GB30531@www5.open-std.org>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com> <4F61803A.60009@hardwarefreak.com> <CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com> <20321.63389.586851.689070@tree.ty.sabi.co.UK> <20120315152548.GA25194@www5.open-std.org> <CAA8mOyDquGX0kEbQSpo=S0EYdNvXNBQ6ZLnb5Sc7uvCPYB+xqA@mail.gmail.com> <20120315171548.GA30531@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120315171548.GA30531@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jessie Evangelista <jessie.evangelista@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On Thu, Mar 15, 2012 at 06:15:49PM +0100, keld@keldix.com wrote:
> On Fri, Mar 16, 2012 at 12:52:19AM +0800, Jessie Evangelista wrote:
> > Hi keld,
> > 
> > On Thu, Mar 15, 2012 at 11:25 PM,  <keld@keldix.com> wrote:
> > > On Thu, Mar 15, 2012 at 02:07:25PM +0000, Peter Grandi wrote:
> > >> >>> I want to create a raid10,n2 using 3 1TB SATA drives.
> > >> >>> I want to create an xfs filesystem on top of it. The
> > >> >>> filesystem will be used as NFS/Samba storage.
> > >>
> > >> Consider also an 'o2' layout (it is probably the same thing for a
> > >> 3 drive RAID10) or even a RAID5, as 3 drives and this usage seems
> > >> one of the few cases where RAID5 may be plausible.
> > >
> > > Well, for a file server like NFS/Samba, you could also consider raid10,f2.
> > > I would think you could get about double the read performance compared to n2 and o2
> > > layouts, and also for individual read transfers on a running system
> > > you would get somthing like double the read performance.
> > > Write performance could be somewhat slower (0 to 10 %) bot as users
> > > are not waiting for writes to complete, they will probably not notice.
> > 
> > I also plan to try raid10f2. Did you do your own benchmarks or are you
> > quoting someone elses?
> 
> Both, look at our wiki: https://raid.wiki.kernel.org/articles/p/e/r/Performance.html

I think it would be interesting to include your figures on the wiki page, if
you publish them here on the list. 

Maybe we should rearrange the wiki page a little. I am not so happy about the 
data reported in the section "New benchmarks from 2011" as it only illustrates
what is happening with a 100 % used CPU. I would like to move it to a separate page.
Also the really old data in section "Old performance benchmark" should be moved to
a separate page, IMHO. The text on the wiki page should be gaving info of
general interest for systems running today (still IMHO). Comments?

Best regards
keld
