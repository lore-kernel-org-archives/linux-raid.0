From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/2] Manage: Inform udev about device removal when stopping
Date: Tue, 16 Feb 2016 17:02:25 -0500
Message-ID: <wrfjmvr09uvi.fsf@redhat.com>
References: <1455633877-4813-1-git-send-email-sebastian.riemer@profitbricks.com>
	<1455633877-4813-3-git-send-email-sebastian.riemer@profitbricks.com>
	<wrfjio1oeemz.fsf@redhat.com> <56C36487.3060201@profitbricks.com>
	<56C36D20.6030001@suse.de> <wrfja8n0bi8n.fsf@redhat.com>
	<8737sstmbh.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8737sstmbh.fsf@notabene.neil.brown.name> (NeilBrown's message of
	"Wed, 17 Feb 2016 07:46:58 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Hannes Reinecke <hare@suse.de>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> On Wed, Feb 17 2016, Jes Sorensen wrote:
>
>> Hannes Reinecke <hare@suse.de> writes:
>>> On 02/16/2016 07:03 PM, Sebastian Parschauer wrote:
>>>> The worst thing that can happen is that the kernel sends the change
>>>> event after the remove event. Then it is the current situation again.
>>>>  From my tests mdadm does enough other stuff in between. Udev is able to
>>>> handle receiving two remove events from my testing. Multiple mdadm
>>>> instances can't run in parallel any ways. So userspace around it needs
>>>> some serialization for it any ways. So also stopping an MD device and
>>>> assembling a new one with the same minor number shouldn't race.
>>>>
>>>> I still prefer this solution here. But if you decide to drop the udev
>>>> event sending in mdadm, then I'm also fine with that.
>>>>
>>> I strongly prefer removing the udev event generation altogether.
>>> As this appears to be a carry-over from older kernels, it looks to me
>>> as being an incomplete conversion:
>>> At one point udev introduced 'ONLINE' and 'OFFLINE' events, which were
>>> supposed to be used for this kind of scenario.
>>> (ONLINE being a companion to 'ADD', and 'OFFLINE' being the companion
>>> to 'DELETE'). However, later the 'ONLINE' got modified to 'CHANGE',
>>> and the 'OFFLINE' got dropped completely.
>>> Or that was the plan.
>>> So it looks as if the conversion to 'CHANGE' got applied to the
>>> 'OFFLINE' event, too.
>>> Hence I strongly recommend to drop it completely, and let the kernel
>>> or the MD module decide if and when a uevent should be send.
>>
>> I am totally fine with this, however we should make mdadm fail if run
>> against a pre-2.6.28 kernel then.
>>
>> Cheers,
>> Jes
>
> I would suggest protecting the
>
> 	if (fd >= 0)
> 		ioctl(fd, BLKRRPART, 0);
> 	if (mdi)
> 		sysfs_uevent(mdi, "change");
>
> code with
>
>    if (get_linux_version() < 2006028)
>
> That should be completely safe - 2.6.28 and later do this (if needed).

Seems a better fix to me. I much prefer the duplicated events.

Sebastian, does this patch resolve the problem for you? If nobody
hollors, I will push this into mdadm.

Cheers,
Jes

commit 7856fa44b8f0bc217a6bbcb5f7c51b2f03717655
Author: Jes Sorensen <Jes.Sorensen@redhat.com>
Date:   Tue Feb 16 16:58:36 2016 -0500

    Manage.c: Only issue change events for kernels older then 2.6.28
    
    2.6.28+ kernels handle this themselves and issuing the event here can
    cause a race.
    
    Reported-by: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
    Suggested-by: NeilBrown <neilb@suse.com>
    Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

diff --git a/Manage.c b/Manage.c
index 7e1b94b..eae96e1 100644
--- a/Manage.c
+++ b/Manage.c
@@ -493,14 +493,17 @@ done:
 		rv = 1;
 		goto out;
 	}
-	/* prior to 2.6.28, KOBJ_CHANGE was not sent when an md array
-	 * was stopped, so We'll do it here just to be sure.  Drop any
-	 * partitions as well...
-	 */
-	if (fd >= 0)
-		ioctl(fd, BLKRRPART, 0);
-	if (mdi)
-		sysfs_uevent(mdi, "change");
+
+	if (get_linux_version() < 2006028) {
+		/* prior to 2.6.28, KOBJ_CHANGE was not sent when an md array
+		 * was stopped, so We'll do it here just to be sure.  Drop any
+		 * partitions as well...
+		 */
+		if (fd >= 0)
+			ioctl(fd, BLKRRPART, 0);
+		if (mdi)
+			sysfs_uevent(mdi, "change");
+	}
 
 	if (devnm[0] && use_udev()) {
 		struct map_ent *mp = map_by_devnm(&map, devnm);
