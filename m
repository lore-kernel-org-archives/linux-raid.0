From: Zhilong Liu <zlliu@suse.com>
Subject: Re: report a bug that panic when grow size for external bitmap
Date: Thu, 31 Aug 2017 10:57:11 +0800
Message-ID: <2d737c2f-69f4-672f-2b7c-4a279f70c3c3@suse.com>
References: <ad8c69c7-f1e0-b6ab-dc87-a81aa7bca391@suse.com>
 <87y3q3gq8g.fsf@notabene.neil.brown.name>
 <6eaf97d4-bd8c-e33c-a9c7-37d0fe2086ce@suse.com>
 <87mv6jgj8z.fsf@notabene.neil.brown.name>
 <ba801ebe-9c0c-d911-2b18-936495fe0ed3@suse.com>
 <87k21mhcqw.fsf@notabene.neil.brown.name>
 <73429dce-a22d-149e-656a-13af228c093f@suse.com>
 <87r2vsfuom.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r2vsfuom.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/31/2017 08:27 AM, NeilBrown wrote:
> On Wed, Aug 30 2017, Zhilong Liu wrote:
>
>> On 08/29/2017 06:47 PM, NeilBrown wrote:
>>> Thanks.  I see what I missed. Please try this patch instead.
>> Hi, Neil;
>>       I have tested the following patch, I still got the call-trace after
>> I built with it.
>> If you need other infos, I would append.
>
> Thanks for testing.
> I looked more completely and I think it is easiest just to disable the
> functionality rather than try to fix it.
> Resizing the file in the kernel is extra complexity that I don't
> want to get in to.
> We could adjust the bitmap chunk size so that the file doesn't
> need to grow, but it started getting more complicated than I really
> wanted to deal with.
> If there is anyone actually using file-backed bitmaps who wants to
> be able to resize the array without removing the bitmap first, then
> we can look at the problem again.  For now I've sent a patch which
> just returns an error instead of crashing when someone tries to resize
> an array with a file-backed bitmap.

Hi, Neil;
     Shall update the "SIZE CHANGES" under "GROW MODE" of man-page for
resize like following after kernel patch merged?

Thanks,
-Zhilong

diff --git a/mdadm.8.in b/mdadm.8.in
index e0747fb..f0fd1fc 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2758,6 +2758,11 @@ Also the size of an array cannot be changed while 
it has an active
  bitmap.  If an array has a bitmap, it must be removed before the size
  can be changed. Once the change is complete a new bitmap can be created.

+.PP
+Note:
+.B "--grow --size"
+is not yet supported for external file bitmap.
+
  .SS RAID\-DEVICES CHANGES

  A RAID1 array can work with any number of devices from 1 upwards

> Thanks,
> NeilBrown

