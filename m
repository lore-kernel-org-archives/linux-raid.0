From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [LSF/MM ATTEND] md raid general
 discussion
Date: Sun, 15 Jan 2017 21:40:51 -0800
Message-ID: <1484545251.2405.29.camel@HansenPartnership.com>
References: <79796ea4-2631-c762-b8a1-50bcdcbc602e@suse.de>
         <587C3EF1.3020401@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <587C3EF1.3020401@suse.com>
Sender: linux-block-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, Coly Li <colyli@suse.de>, lsf-pc@lists.linux-foundation.org
Cc: linux-block@vger.kernel.org, songliubraving@fb.com, pawel.baldysiak@intel.com, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, NeilBrown <neilb@suse.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, artur.paszkiewicz@intel.com, Hannes Reinecke <hare@suse.de>, Jes.Sorensen@redhat.com, mariusz.dabrowski@intel.com, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

On Mon, 2017-01-16 at 11:33 +0800, Guoqing Jiang wrote:
> 
> On 01/10/2017 12:38 AM, Coly Li wrote:
> > Hi Folks,
> > 
> > I'd like to propose a general md raid discussion, it is quite 
> > necessary for most of active md raid developers sit together to 
> > discuss current challenge of Linux software raid and development
> > trends.
> > 
> > In the last years, we have many development activities in md raid, 
> > e.g. raid5 cache, raid1 clustering, partial parity log, fast fail
> > upstreaming, and some effort for raid1 & raid0 performance
> > improvement.
> > 
> > I see there are some kind of functionality overlap between r5cache
> > (raid5 cache) and PPL (partial parity log), currently I have no 
> > idea where we will go for these two development activities.
> > Also I receive reports from users that raid1 performance is desired 
> > when it is built on NVMe SSDs as a cache (maybe bcache or dm
> > -cache). I am working on some raid1 performance improvement (e.g. 
> > new raid1 I/O barrier and lockless raid1 I/O submit), and have some 
> > more ideas to discuss.
> > 
> > Therefore, if md raid developers may have a chance to sit together,
> > discuss how to efficiently collaborate in next year, it will be 
> > much more productive then communicating on mailing list.
> 
> I would like to attend raid discussion, besides above topics I think 
> we can talk about improve the test suite of mdadm to make it more 
> robust (I can share related test suite which is used for clustered
> raid).

Just so you know ... and just in case others are watching.  You're not
going to be getting an invite to LSF/MM unless you send an attend or
topic request in as the CFP asks:

http://marc.info/?l=linux-fsdevel&m=148285919408577

The rationale is simple: it's to difficult to track all the "me too"
reply emails and even if we could, it's not actually clear what the
intention of the sender is.  So you taking the time to compose an
official email as the CFP requests allows the programme committee to
distinguish.

James

