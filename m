From: Patrick Dung <mpatdung@gmail.com>
Subject: Re: Feature request, resumable raid check action
Date: Fri, 2 Dec 2016 13:57:06 +0800
Message-ID: <CAEtPA0C=xH0gCaigs-THNZRspmwD6d4WCrecjL-30M3PP0vxHw@mail.gmail.com>
References: <CAEtPA0Aosn6q0pJxsh69EpHQehiSsyeyVfJf98cDhu6kORkE1g@mail.gmail.com>
 <8737i76idm.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8737i76idm.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for reply, NeilBrown.

In my testing:
I had run the mdcheck script, then reboot.
After rebooted, then I  run the mdcheck script again, it did not
resume from where it stopped before reboot.

Is there something that I may had missed?

Best regards,
Patrick

On Fri, Dec 2, 2016 at 12:54 PM, NeilBrown <neilb@suse.com> wrote:
> On Wed, Nov 30 2016, Patrick Dung wrote:
>
>> Hello,
>>
>> As I know if MD raid is using the newer metadata version, it support
>> resumable raid rebuild/sync. (that is, if a server is rebooted during
>> rebuild, it would resume from last position after reboot, instead of
>> starting from beginning).
>>
>> In my recently testing (a few months ago):
>> I sometimes use the mdadm 'check' action for doing the disk scrubbing
>> of a MD raid.
>> After I rebooted the server, the 'check' operation is forgotten and is
>> not resumable.
>>
>> I think resumable 'check' operation is useful as the array size would
>> become bigger in the future.
>
> "check" is resumable.  md doesn't record where it is up to though, you
> need to do that yourself.
> The "misc/mdcheck" script in the mdadm package makes use of this to
> support time-limited checking, and to resume from where it left off.
> You could use the script, or read it and see how it works.
>
> NeilBrown
