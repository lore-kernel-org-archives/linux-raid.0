From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Wed, 4 Apr 2012 19:56:41 +0300
Message-ID: <CAGRgLy7BaVTjacaqMVD1JNYgtTn6MAk9bN-GzDC8B0CypJWJmw@mail.gmail.com>
References: <20111212115459.GC20730@fi.muni.cz>
	<4EE61EAE.20101@anonymous.org.uk>
	<20120106150823.GX25976@fi.muni.cz>
	<20120107075526.59ed433c@notabene.brown>
	<CAGRgLy4Q5FhHMAeU3egqEfFKR_h1HneReg0sD_+hCmsF3WDzQw@mail.gmail.com>
	<20120322213114.61fd4e44@notabene.brown>
	<CAGRgLy7N7m4zFY-EKe8ApUGSR3ZCUpOTZcRvLVLd5WAN2f+k9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7N7m4zFY-EKe8ApUGSR3ZCUpOTZcRvLVLd5WAN2f+k9g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

I fetched this commit, and also the "fixed sysfs_freeze_array array to
work properly with Manage_subdevs" commit
fd324b08dbfa8404558534dd0a2321213ffb7257, which looks relevant.
I experimented with this, and I have some questions:

Is there any special purpose for calling
sysfs_attribute_available("sync_action")? If this call fails, the code
returns 1, which will make the caller to attempt to un-freeze. Without
this call, however, sysfs_get_str("sync_action") will fail and return
0, which will prevent the caller from unfreezing, which looks better.

Why do you refuse to freeze the array if it's not "idle"? What will
happen is that current recover/resync will abort, drives will be
added, and on unfreezing, array will resume (restart?) recovery with
all drives. If array was resyncing, however, it will start recovering
the newly added drives, because kernel prefers recovery over resync
(as we discussed earlier).

Any other caveats of this freezing/unfreezing you can think of?

Thanks,
  Alex.





On Sun, Mar 25, 2012 at 12:30 PM, Alexander Lyakas
<alex.bolshoy@gmail.com> wrote:
> Thanks, Neil!
> I will merge this in and test.
>
>
> On Thu, Mar 22, 2012 at 12:31 PM, NeilBrown <neilb@suse.de> wrote:
>> On Thu, 22 Mar 2012 12:01:48 +0200 Alexander Lyakas <alex.bolshoy@gm=
ail.com>
>> wrote:
>>
>>> Neil,
>>>
>>> > =A0echo frozen > /sys/block/mdN/md/sync_action
>>> > =A0mdadm --add /dev/mdN /dev......
>>> > =A0echo recover > /sys/block/mdN/md/sync_action
>>> >
>>> > it should do them all at once.
>>> >
>>> > I should teach mdadm about this..
>>>
>>> What is required to do that from mdadm? I don't see any other place
>>> where MD_RECOVERY_FROZEN is set, except via sysfs. So do you sugges=
t
>>> that mdadm use sysfs for that?
>>
>> Yes.
>>
>> http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D9f58469128c9=
9c0d7f434d28657f86789334f253
>>
>>> Also, what should be done if mdadm succeeds to "freeze" the array, =
but
>>> fails to "unfreeze" it for some reason?
>>
>> What could possibly cause that?
>> I guess if someone kills mdadm while it was running..
>>
>>
>> NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
