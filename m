From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch v2 2/6] blk: dont allow discard request merge temporarily
Date: Thu, 22 Mar 2012 02:28:51 -0400
Message-ID: <20120322062850.GA25288@infradead.org>
References: <20120316073213.656519005@fusionio.com>
 <20120316073512.485027511@fusionio.com>
 <20120320162157.GE17071@redhat.com>
 <CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
 <yq1d385wf75.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1d385wf75.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shaohua Li <shli@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

On Wed, Mar 21, 2012 at 10:18:54PM -0400, Martin K. Petersen wrote:
> >>>>> "Shaohua" == Shaohua Li <shli@kernel.org> writes:
> 
> Shaohua> Enabling discard merge is required for device with slow discard
> Shaohua> (and very helpful for raid),
> 
> Before RAID support there really wasn't much point. That's one of the
> reasons the current discard merge code has survived despite being
> completely broken.

I've actually send repeated bug reports about it beeing broken when
I enabled async discard in XFS which led to merges, and debugged it down
to beeing a problem with merges.  But Jens didn't like my patch to mark
them nomerged, so we still couldn't commit the async discard support for
XFS which would have helped quite a bit with discard performance.

