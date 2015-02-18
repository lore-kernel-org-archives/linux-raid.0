From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: md_raid5 using 100% CPU and hang with status resync=PENDING, if a drive is removed during initialization
Date: Tue, 17 Feb 2015 20:01:05 -0500
Message-ID: <wrfjh9ukf2y6.fsf@redhat.com>
References: <CD8664C5675EDF49A5E76D7DB099D7B32611BB56@VENUS1.in.megatrends.com>
	<20141231164800.GL19091@reaktio.net>
	<CD8664C5675EDF49A5E76D7DB099D7B326130D6E@VENUS1.in.megatrends.com>
	<20150203093040.569aa5e1@notabene.brown> <wrfjpp99pp9d.fsf@redhat.com>
	<wrfjd259o4iy.fsf@redhat.com> <wrfj61b0gk6l.fsf@redhat.com>
	<20150218112741.08495514@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150218112741.08495514@notabene.brown> (NeilBrown's message of
	"Wed, 18 Feb 2015 11:27:41 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Manibalan P <pmanibalan@amiindia.co.in>, Pasi =?utf-8?B?S8Okcmtrw6Rp?= =?utf-8?B?bmVu?= <pasik@iki.fi>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Tue, 17 Feb 2015 19:03:30 -0500 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
>
>> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>> > Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>> >> NeilBrown <neilb@suse.de> writes:
>> >>> On Mon, 2 Feb 2015 07:10:14 +0000 Manibalan P <pmanibalan@amiindia.co.in>
>> >>> wrote:
>> >>>
>> >>>> Dear All,
>> >>>> 	Any updates on this issue.
>> >>>
>> >>> Probably the same as:
>> >>>
>> >>>   http://marc.info/?l=linux-raid&m=142283560704091&w=2
>> >>
>> >> Hi Neil,
>> >>
>> >> I ran some tests on this one against the latest Linus' tree as of today
>> >> (1fa185ebcbcefdc5229c783450c9f0439a69f0c1) which I believe includes all
>> >> your pending 3.20 patches.
>> >>
>> >> I am able to reproduce Manibalan's hangs on a system with 4 SSDs if I
>> >> run fio on top of a device while it is resyncing and I fail one of the
>> >> devices.
>> >
>> > Since Manibalan mentioned this issue wasn't present in earlier kernels,
>> > I started trying to track down what change caused it.
>> >
>> > So far I have been able to reproduce the hang as far back as 3.10.
>> 
>> After a lot of bisecting I finally traced the issue back to this commit:
>> 
>> a7854487cd7128a30a7f4f5259de9f67d5efb95f is the first bad commit
>> commit a7854487cd7128a30a7f4f5259de9f67d5efb95f
>> Author: Alexander Lyakas <alex.bolshoy@gmail.com>
>> Date:   Thu Oct 11 13:50:12 2012 +1100
>> 
>>     md: When RAID5 is dirty, force reconstruct-write instead of
>> read-modify-write.
>>     
>>     Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
>>     Suggested-by: Yair Hershko <yair@zadarastorage.com>
>>     Signed-off-by: NeilBrown <neilb@suse.de>
>> 
>> If I revert that one I cannot reproduce the hang, applying it reproduces
>> the hang consistently.
>
> Thanks for all the research!
>
> That is consistent with what you already reported.
> You noted that it doesn't affect RAID6, and RAID6 doesn't have an RMW cycle.
>
> Also, one  of the early emails from Manibalan contained:
>
> handling stripe 273480328, state=0x2041 cnt=1, pd_idx=5, qd_idx=-1
> , check:0, reconstruct:0
> check 5: state 0x10 read           (null) write           (null) written           (null)
> check 4: state 0x11 read           (null) write           (null) written           (null)
> check 3: state 0x0 read           (null) write           (null) written           (null)
> check 2: state 0x11 read           (null) write           (null) written           (null)
> check 1: state 0x11 read           (null) write           (null) written           (null)
> check 0: state 0x18 read           (null) write ffff8808029b6b00 written           (null)
> locked=0 uptodate=3 to_read=0 to_write=1 failed=1 failed_num=3,-1
> force RCW max_degraded=1, recovery_cp=7036944 sh->sector=273480328
> for sector 273480328, rmw=2 rcw=1
>
> So it is forcing RCW, even though a single block update is usually handled
> with RMW.
>
> In this stripe, the parity disk is '5' and disk 3 has failed.
> That means to perform an RCW, we need to read the parity block in order
> to reconstruct the content of the failed disk.  And if we were to do that,
> we may as well just do an RMW.
>
> So I think the correct fix would be to only force RCW when the array
> is not degraded.
>
> So something like this:
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index aa76865b804b..fa8f8b94bfa8 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3170,7 +3170,8 @@ static void handle_stripe_dirtying(struct r5conf *conf,
>  	 * generate correct data from the parity.
>  	 */
>  	if (conf->max_degraded == 2 ||
> -	    (recovery_cp < MaxSector && sh->sector >= recovery_cp)) {
> +	    (recovery_cp < MaxSector && sh->sector >= recovery_cp &&
> +	     s->failed == 0)) {
>  		/* Calculate the real rcw later - for now make it
>  		 * look like rcw is cheaper
>  		 */
>
>
> I think reverting the whole patch is not necessary and discards useful
> functionality while the array is not degraded.
>
> Can you test this patch please?

Actually I just tried this one - I was on my way home and grabbed food
on the way, and thought there was a better solution than to revert.

I'll give your solution a spin too.

Jes

From 63e7c81c955d99e1eb7ab70956689a12e02eb856 Mon Sep 17 00:00:00 2001
From: Jes Sorensen <Jes.Sorensen@redhat.com>
Date: Tue, 17 Feb 2015 19:48:49 -0500
Subject: [PATCH] [md] raid5.c: Do not force reconstruct writes on a degraded
 array

If an array has no writeable spares, do not try to force
reconstruct-write to it.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/md/raid5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index aa76865..c0036c4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3170,7 +3170,8 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	 * generate correct data from the parity.
 	 */
 	if (conf->max_degraded == 2 ||
-	    (recovery_cp < MaxSector && sh->sector >= recovery_cp)) {
+	    (conf->mddev->degraded < (conf->max_degraded - 1) &&
+	     recovery_cp < MaxSector && sh->sector >= recovery_cp)) {
 		/* Calculate the real rcw later - for now make it
 		 * look like rcw is cheaper
 		 */
-- 
2.1.0

