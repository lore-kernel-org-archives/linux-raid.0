From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch v2 2/6] blk: dont allow discard request merge temporarily
Date: Wed, 21 Mar 2012 09:22:46 +0800
Message-ID: <CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
References: <20120316073213.656519005@fusionio.com>
	<20120316073512.485027511@fusionio.com>
	<20120320162157.GE17071@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120320162157.GE17071@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk, martin.petersen@oracle.com
List-Id: linux-raid.ids

2012/3/21 Vivek Goyal <vgoyal@redhat.com>:
> On Fri, Mar 16, 2012 at 03:32:15PM +0800, Shaohua Li wrote:
>> Didn't allow discard request merge temporarily, as SCSI layer isn't =
ready
>> for discard merge as Martin Petersen pointed out. This isn't fair fo=
r
>> non-scsi device, but looks this is the only way I can do currently.
>>
>> We should have the same issue before, but maybe because discard merg=
e is
>> very rare case. But now raid0/10 makes the merge quite possible, so =
we need
>> disable it explicitly.
>>
>> Signed-off-by: Shaohua Li <shli@fusionio.com>
>> ---
>> =A0include/linux/blkdev.h | =A0 =A02 +-
>> =A01 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: linux/include/linux/blkdev.h
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux.orig/include/linux/blkdev.h 2012-03-14 09:20:06.787261188 =
+0800
>> +++ linux/include/linux/blkdev.h =A0 =A0 =A02012-03-14 09:20:47.7972=
61248 +0800
>> @@ -575,7 +575,7 @@ static inline void blk_clear_queue_full(
>> =A0 * it already be started by driver.
>> =A0 */
>> =A0#define RQ_NOMERGE_FLAGS =A0 =A0 \
>> - =A0 =A0 (REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH |=
 REQ_FUA)
>> + =A0 =A0 (REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH |=
 REQ_FUA | REQ_DISCARD)
>> =A0#define rq_mergeable(rq) =A0 =A0 \
>> =A0 =A0 =A0 (!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
>> =A0 =A0 =A0 =A0(((rq)->cmd_flags & REQ_DISCARD) || \
>
> I think you will need to do little more cleanup to make discard
> unmergeable.
>
> - Change rq_mergeable(rq)
> - Change attempt_merge() and get rid of special conditions of allowin=
g
> =A0discard merge.
>
> Martin had a bigger patch where he wanted to cleanup many discard spe=
cific
> condition checks.
>
> As you are just focusing on disabling merging for discard requests, y=
ou
> might as well just pick the relevant pieces from the patch.
>
> http://www.spinics.net/lists/linux-scsi/msg57779.html
Thanks for pointing out the thread. I didn't think disabling discard me=
rging
permanently is a good idea. We can't do the merge because that code isn=
't
ready (actually just for driver of SCSI). Enabling discard merge is req=
uired
for device with slow discard (and very helpful for raid), so I just wan=
t a
temporarily disabling for the merge. Just changing RQ_NOMERGE_FLAGS
is an easy workaround for this goal.

Thanks,
Shaohua
