From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 00/13] convert block layer to
	bioset_init()/mempool_init()
Date: Wed, 30 May 2018 13:36:58 -0600
Message-ID: <bda57417-4aa1-b22c-9973-76d039fcaa9e@kernel.dk>
References: <20180521144703.GA19303@redhat.com>
	<4b343aef-e11c-73ba-1d88-7e73ca838cad@kernel.dk>
	<20180521150439.GA19379@redhat.com>
	<61e30dcf-a01c-f47d-087a-12930caf9aef@kernel.dk>
	<20180521151817.GA19454@redhat.com>
	<d01a150a-7752-f6ce-78f2-17a65c1e6fa5@kernel.dk>
	<20180521160907.GA19553@redhat.com>
	<f9e3714c-b7c9-d5f6-4018-2a87dd5babb2@kernel.dk>
	<20180530133629.GC5157@redhat.com>
	<f654ad69-aa90-9580-4731-a05d0604f353@kernel.dk>
	<20180530193435.GC3487@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20180530193435.GC3487@kmo-pixel>
Content-Language: en-US
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, colyli-l3A5Bk7waGM@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, neilb-IBi9RG/b67k@public.gmane.org, bacik-b10kYP2dOMg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-raid.ids

On 5/30/18 1:34 PM, Kent Overstreet wrote:
> On Wed, May 30, 2018 at 12:55:48PM -0600, Jens Axboe wrote:
>> On 5/30/18 7:36 AM, Mike Snitzer wrote:
>>> So revisiting this patchset: are you inclined to take these changes (I
>>> assume yes)?  If so, what would you need in order to get them staged for
>>> 4.18?  I'll start with offering my review in reply to the DM patch.  I'd
>>> much prefer to see this level of change go in sooner rather than later.
>>
>> Yeah I'd like to take the changes, but we might have to wait for
>> 4.19 at this point. It'd certainly help to have the dm bits reviewed,
>> as they are some of the larger ones. The grunt of the others are mostly
>> trivial and smaller in scope.
> 
> I don't have a strong opinion on 4.18 vs. 4.19, but I'm available to do whatever
> fixups are needed if it'll help get them in faster.

Let's do 4.18, I'm getting ready to queue it up. Pinged a few btrfs folks to
get that part reviewed.

Note that I'll add a one liner description in the commit message for the
patches, as suggested by Mike. They are pretty barren, a little meat in
the body won't hurt.

-- 
Jens Axboe
