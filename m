From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: raid1 - optimization
Date: Thu, 03 Feb 2011 14:56:49 +0000
Message-ID: <4D4AC231.8010900@anonymous.org.uk>
References: <AANLkTiknvYgckFSjgr3tE0CSLzAbH62O3x4a5Jn1dg6n@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTiknvYgckFSjgr3tE0CSLzAbH62O3x4a5Jn1dg6n@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/02/2011 14:37, Roberto Spadim wrote:
> hi guys, i another thread i read about SNIA DDF Technical Position v2.0
> could we implement RAID-1E, for sequencial/random read speedup?
> http://www.snia.org/tech_activities/standards/curr_standards/ddf/SNIA_DDF_Technical_Position_v2.0.pdf
> after that, could we implement some tweaks on read balance (there's
> another thread just for it)

Those RAID-1E layouts look to me like what's implemented in md RAID as 
RAID-10 with near and offset layouts.

As discussed frequently here, md RAID-10 also has a far layout which can 
provide slightly faster than RAID-0 throughput for sequential reading 
with slightly slower than RAID-1 throughput for sequential writing. 
Please see some of the benchmarks that have also been referred to on 
this list in the last couple of days.

Cheers,

John.

