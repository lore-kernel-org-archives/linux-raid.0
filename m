From: MasterPrenium <masterprenium.lkml@gmail.com>
Subject: Re: PROBLEM: Kernel BUG with raid5 soft + Xen + DRBD -
	invalid opcode
Date: Thu, 5 Oct 2017 23:35:55 +0200
Message-ID: <0c9502dc-ccd4-6ff3-9f24-56bdc0300375@gmail.com>
References: <585D6C34.2020908@gmail.com>
 <20170104223015.cr6vtyhxuwxrg76g@kernel.org>
 <e56edc2b-f2ad-2ab1-4184-5d7cad80085a@gmail.com>
 <20170105193745.qnmqsussxy7nasdn@kernel.org>
 <2717981a-4308-3f7b-15c6-f384a41fd445@gmail.com>
 <20170109224435.sfyrvkxhajgrq2i5@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6171131709784619375=="
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <20170109224435.sfyrvkxhajgrq2i5@kernel.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <https://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, xen-users@lists.xen.org, "MasterPrenium@gmail.com" <MasterPrenium@gmail.com>, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--===============6171131709784619375==
Content-Type: multipart/alternative;
 boundary="------------6A290CEFD3970A8694A92565"
Content-Language: en-GB

This is a multi-part message in MIME format.
--------------6A290CEFD3970A8694A92565
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Shaohua,

It seems this patch fixed my issue ! Had the issue remaining in 4.13.3, 
after patched with the following patch, issue seems to be gone. I can't 
reproduce it anymore.

Thanks anyway ;)

From: Shaohua Li<shli@fb.com>

commit 3664847d95e60a9a943858b7800f8484669740fc upstream.

We have a race condition in below scenario, say have 3 continuous stripes, sh1,
sh2 and sh3, sh1 is the stripe_head of sh2 and sh3:

CPU1				CPU2				CPU3
handle_stripe(sh3)
				stripe_add_to_batch_list(sh3)
				-> lock(sh2, sh3)
				-> lock batch_lock(sh1)
				-> add sh3 to batch_list of sh1
				-> unlock batch_lock(sh1)
								clear_batch_ready(sh1)
								-> lock(sh1) and batch_lock(sh1)
								-> clear STRIPE_BATCH_READY for all stripes in batch_list
								-> unlock(sh1) and batch_lock(sh1)
->clear_batch_ready(sh3)
-->test_and_clear_bit(STRIPE_BATCH_READY, sh3)
--->return 0 as sh->batch == NULL
				-> sh3->batch_head = sh1
				-> unlock (sh2, sh3)

In CPU1, handle_stripe will continue handle sh3 even it's in batch stripe list
of sh1. By moving sh3->batch_head assignment in to batch_lock, we make it
impossible to clear STRIPE_BATCH_READY before batch_head is set.

Thanks Stephane for helping debug this tricky issue.

Reported-and-tested-by: Stephane Thiell<sthiell@stanford.edu>
Signed-off-by: Shaohua Li<shli@fb.com>
Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>

---
  drivers/md/raid5.c |   10 ++++++++--
  1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -812,6 +812,14 @@ static void stripe_add_to_batch_list(str
  			spin_unlock(&head->batch_head->batch_lock);
  			goto unlock_out;
  		}
+		/*
+		 * We must assign batch_head of this stripe within the
+		 * batch_lock, otherwise clear_batch_ready of batch head
+		 * stripe could clear BATCH_READY bit of this stripe and
+		 * this stripe->batch_head doesn't get assigned, which
+		 * could confuse clear_batch_ready for this stripe
+		 */
+		sh->batch_head = head->batch_head;
  
  		/*
  		 * at this point, head's BATCH_READY could be cleared, but we
@@ -819,8 +827,6 @@ static void stripe_add_to_batch_list(str
  		 */
  		list_add(&sh->batch_list, &head->batch_list);
  		spin_unlock(&head->batch_head->batch_lock);
-
-		sh->batch_head = head->batch_head;
  	} else {
  		head->batch_head = head;
  		sh->batch_head = head->batch_head;


Le 09/01/2017 à 23:44, Shaohua Li a écrit :
> On Sun, Jan 08, 2017 at 02:31:15PM +0100, MasterPrenium wrote:
>> Hello,
>>
>> Replies below + :
>> - I don't know if this can help but after the crash, when the system
>> reboots, the Raid 5 stack is re-synchronizing
>> [   37.028239] md10: Warning: Device sdc1 is misaligned
>> [   37.028541] created bitmap (15 pages) for device md10
>> [   37.030433] md10: bitmap initialized from disk: read 1 pages, set 59 of
>> 29807 bits
>>
>> - Sometimes the kernel completely crash (lost serial + network connection),
>> sometimes only got the "BUG" dump, but still have network access (but a
>> reboot is impossible, need to reset the system).
>>
>> - You can find blktrace here (while running fio), I hope it's complete since
>> the end of the file is when the kernel crashed : https://goo.gl/X9jZ50
> Looks most are normal full stripe writes.
>   
>>> I'm trying to reproduce, but no success. So
>>> ext4->btrfs->raid5, crash
>>> btrfs->raid5, no crash
>>> right? does subvolume matter? When you create the raid5 array, does adding
>>> '--assume-clean' option change the behavior? I'd like to narrow down the issue.
>>> If you can capture the blktrace to the raid5 array, it would be great to hint
>>> us what kind of IO it is.
>> Yes Correct.
>> The subvolume doesn't matter.
>> -- assume-clean doesn't change the behaviour.
> so it's not a resync issue.
>
>> Don't forget that the system needs to be running on xen to crash, without
>> (on native kernel) it doesn't crash (or at least, I was not able to make it
>> crash).
>>>> Regarding your patch, I can't find it. Is it the one sent by Konstantin
>>>> Khlebnikov ?
>>> Right.
>> It doesn't help :(. Maybe the crash is happening a little bit later.
> ok, the patch is unlikely helpful, since the IO size isn't very big.
>
> Don't have good idea yet. My best guess so far is virtual machine introduces
> extra delay, which might trigger some race conditions which aren't seen in
> native.  I'll check if I could find something locally.
>
> Thanks,
> Shaohua


--------------6A290CEFD3970A8694A92565
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <p>Hi Shaohua,</p>
    <p>It seems this patch fixed my issue ! Had the issue remaining in
      4.13.3, after patched with the following patch, issue seems to be
      gone. I can't reproduce it anymore.</p>
    <p>Thanks anyway ;)</p>
    <pre wrap="">From: Shaohua Li <a class="moz-txt-link-rfc2396E" href="mailto:shli@fb.com">&lt;shli@fb.com&gt;</a>

commit 3664847d95e60a9a943858b7800f8484669740fc upstream.

We have a race condition in below scenario, say have 3 continuous stripes, sh1,
sh2 and sh3, sh1 is the stripe_head of sh2 and sh3:

CPU1				CPU2				CPU3
handle_stripe(sh3)
				stripe_add_to_batch_list(sh3)
				-&gt; lock(sh2, sh3)
				-&gt; lock batch_lock(sh1)
				-&gt; add sh3 to batch_list of sh1
				-&gt; unlock batch_lock(sh1)
								clear_batch_ready(sh1)
								-&gt; lock(sh1) and batch_lock(sh1)
								-&gt; clear STRIPE_BATCH_READY for all stripes in batch_list
								-&gt; unlock(sh1) and batch_lock(sh1)
-&gt;clear_batch_ready(sh3)
--&gt;test_and_clear_bit(STRIPE_BATCH_READY, sh3)
---&gt;return 0 as sh-&gt;batch == NULL
				-&gt; sh3-&gt;batch_head = sh1
				-&gt; unlock (sh2, sh3)

In CPU1, handle_stripe will continue handle sh3 even it's in batch stripe list
of sh1. By moving sh3-&gt;batch_head assignment in to batch_lock, we make it
impossible to clear STRIPE_BATCH_READY before batch_head is set.

Thanks Stephane for helping debug this tricky issue.

Reported-and-tested-by: Stephane Thiell <a class="moz-txt-link-rfc2396E" href="mailto:sthiell@stanford.edu">&lt;sthiell@stanford.edu&gt;</a>
Signed-off-by: Shaohua Li <a class="moz-txt-link-rfc2396E" href="mailto:shli@fb.com">&lt;shli@fb.com&gt;</a>
Signed-off-by: Greg Kroah-Hartman <a class="moz-txt-link-rfc2396E" href="mailto:gregkh@linuxfoundation.org">&lt;gregkh@linuxfoundation.org&gt;</a>

---
 drivers/md/raid5.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -812,6 +812,14 @@ static void stripe_add_to_batch_list(str
 			spin_unlock(&amp;head-&gt;batch_head-&gt;batch_lock);
 			goto unlock_out;
 		}
+		/*
+		 * We must assign batch_head of this stripe within the
+		 * batch_lock, otherwise clear_batch_ready of batch head
+		 * stripe could clear BATCH_READY bit of this stripe and
+		 * this stripe-&gt;batch_head doesn't get assigned, which
+		 * could confuse clear_batch_ready for this stripe
+		 */
+		sh-&gt;batch_head = head-&gt;batch_head;
 
 		/*
 		 * at this point, head's BATCH_READY could be cleared, but we
@@ -819,8 +827,6 @@ static void stripe_add_to_batch_list(str
 		 */
 		list_add(&amp;sh-&gt;batch_list, &amp;head-&gt;batch_list);
 		spin_unlock(&amp;head-&gt;batch_head-&gt;batch_lock);
-
-		sh-&gt;batch_head = head-&gt;batch_head;
 	} else {
 		head-&gt;batch_head = head;
 		sh-&gt;batch_head = head-&gt;batch_head;
</pre>
    <br>
    <div class="moz-cite-prefix">Le 09/01/2017 à 23:44, Shaohua Li a
      écrit :<br>
    </div>
    <blockquote type="cite"
      cite="mid:20170109224435.sfyrvkxhajgrq2i5@kernel.org">
      <pre wrap="">On Sun, Jan 08, 2017 at 02:31:15PM +0100, MasterPrenium wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">Hello,

Replies below + :
- I don't know if this can help but after the crash, when the system
reboots, the Raid 5 stack is re-synchronizing
[   37.028239] md10: Warning: Device sdc1 is misaligned
[   37.028541] created bitmap (15 pages) for device md10
[   37.030433] md10: bitmap initialized from disk: read 1 pages, set 59 of
29807 bits

- Sometimes the kernel completely crash (lost serial + network connection),
sometimes only got the "BUG" dump, but still have network access (but a
reboot is impossible, need to reset the system).

- You can find blktrace here (while running fio), I hope it's complete since
the end of the file is when the kernel crashed : <a class="moz-txt-link-freetext" href="https://goo.gl/X9jZ50">https://goo.gl/X9jZ50</a>
</pre>
      </blockquote>
      <pre wrap="">
Looks most are normal full stripe writes.
 
</pre>
      <blockquote type="cite">
        <blockquote type="cite">
          <pre wrap="">I'm trying to reproduce, but no success. So
ext4-&gt;btrfs-&gt;raid5, crash
btrfs-&gt;raid5, no crash
right? does subvolume matter? When you create the raid5 array, does adding
'--assume-clean' option change the behavior? I'd like to narrow down the issue.
If you can capture the blktrace to the raid5 array, it would be great to hint
us what kind of IO it is.
</pre>
        </blockquote>
        <pre wrap="">Yes Correct.
The subvolume doesn't matter.
-- assume-clean doesn't change the behaviour.
</pre>
      </blockquote>
      <pre wrap="">
so it's not a resync issue.

</pre>
      <blockquote type="cite">
        <pre wrap="">Don't forget that the system needs to be running on xen to crash, without
(on native kernel) it doesn't crash (or at least, I was not able to make it
crash).
</pre>
        <blockquote type="cite">
          <blockquote type="cite">
            <pre wrap="">Regarding your patch, I can't find it. Is it the one sent by Konstantin
Khlebnikov ?
</pre>
          </blockquote>
          <pre wrap="">Right.
</pre>
        </blockquote>
        <pre wrap="">It doesn't help :(. Maybe the crash is happening a little bit later.
</pre>
      </blockquote>
      <pre wrap="">
ok, the patch is unlikely helpful, since the IO size isn't very big.

Don't have good idea yet. My best guess so far is virtual machine introduces
extra delay, which might trigger some race conditions which aren't seen in
native.  I'll check if I could find something locally.

Thanks,
Shaohua
</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------6A290CEFD3970A8694A92565--


--===============6171131709784619375==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVs
IG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVuLm9yZwpodHRwczovL2xpc3RzLnhlbi5v
cmcveGVuLWRldmVsCg==

--===============6171131709784619375==--
