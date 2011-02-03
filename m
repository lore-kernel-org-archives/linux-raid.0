From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: raid1 - optimization
Date: Thu, 3 Feb 2011 16:45:40 +0100
Message-ID: <20110203154540.GB27356@www2.open-std.org>
References: <AANLkTiknvYgckFSjgr3tE0CSLzAbH62O3x4a5Jn1dg6n@mail.gmail.com> <4D4AC231.8010900@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D4AC231.8010900@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Roberto Spadim <roberto@spadim.com.br>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Feb 03, 2011 at 02:56:49PM +0000, John Robinson wrote:
> On 03/02/2011 14:37, Roberto Spadim wrote:
> >hi guys, i another thread i read about SNIA DDF Technical Position v2.0
> >could we implement RAID-1E, for sequencial/random read speedup?
> >http://www.snia.org/tech_activities/standards/curr_standards/ddf/SNIA_DDF_Technical_Position_v2.0.pdf
> >after that, could we implement some tweaks on read balance (there's
> >another thread just for it)
> 
> Those RAID-1E layouts look to me like what's implemented in md RAID as 
> RAID-10 with near and offset layouts.
> 
> As discussed frequently here, md RAID-10 also has a far layout which can 
> provide slightly faster than RAID-0 throughput for sequential reading 
> with slightly slower than RAID-1 throughput for sequential writing. 
> Please see some of the benchmarks that have also been referred to on 
> this list in the last couple of days.

I have written SNIA over a year ago on raid10,f2 to have it
to be a standardized layout too, but without any response.

Best regards
Keld
