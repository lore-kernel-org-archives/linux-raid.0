From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Need help with my raid5
Date: Fri, 22 Mar 2013 10:37:47 -0500
Message-ID: <CAAMCDeeympGaLMCfQKt32bJ-ZWtf08RCTv0=LZNP_r-kxn6fiQ@mail.gmail.com>
References: <loom.20130322T084406-543@post.gmane.org> <CAAMCDed0Pvs_+c6o5BvpVNi5ATZeu1abR1xeW=ikR8O9W5HJ1Q@mail.gmail.com>
 <loom.20130322T134448-923@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20130322T134448-923@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mirko <mirko76@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 22, 2013 at 7:53 AM, Mirko <mirko76@arcor.de> wrote:
>> According to the above you removed device 3 not device 7....device 3
>> is missing...device 7 is still there and is a spare.
>
> Thats right.
>
>> Put what you though was 7 back
> This device no longer exists.

What do you mean no longer exists?

If so, then you are likely restoring from backups as device 7 failed
and device 3 was otherwise was removed and is now no longer viable.
You may be able to do add a -f on the mdadm and force it
online...typically it will force a previously declared missing/spare
device to be re-evaluated and reused if it is good enough or failed
for some reasons.

>
>> ...note that properly determining which
>> device is which is pretty difficult unless you have a commercial grade
>> wired enclosure from a tier 1 vendor that is actually labeled and
>> wired correctly (don't always count on that).
>
> I thought, every device has its fixed device number in the raid:
>
> mdadm -E /dev/sd[a-f]1 | grep Role
>    Device Role : Active device 1
>    Device Role : Active device 5
>    Device Role : spare
>    Device Role : Active device 0
>    Device Role : Active device 4
>    Device Role : Active device 2
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
