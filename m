From: "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: [PATCH] userns: Replace netlink uses of cap_raised with capable.
Date: Tue, 3 Apr 2012 21:24:20 -0700
Message-ID: <CALQRfL50EL7k_G3oDwEzeJDRmCEPztkPx3aVHo6c-c6QbDjjzA@mail.gmail.com>
References: <m1mx6sz2f2.fsf@fess.ebiederm.org>
	<20120404022652.GA18730@mail.hallyn.com>
	<m1sjgkxlic.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <m1sjgkxlic.fsf@fess.ebiederm.org>
Sender: linux-security-module-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, Philipp Reisner <philipp.reisner@linbit.com>, Patrick McHardy <kaber@trash.net>, Vasiliy Kulikov <segoon@openwall.com>, David Howells <dhowells@redhat.com>, Neil Brown <neilb@suse.de>, Michal Januszewski <spock@gentoo.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew

On Tue, Apr 3, 2012 at 7:45 PM, Eric W. Biederman <ebiederm@xmission.co=
m> wrote:
> "Serge E. Hallyn" <serge@hallyn.com> writes:
>
>> Quoting Eric W. Biederman (ebiederm@xmission.com):
>>>
>>> In 2009 Philip Reiser notied that a few users of netlink connector
>>> interface needed a capability check and added the idiom
>>> cap_raised(nsp->eff_cap, CAP_SYS_ADMIN) to a few of them, on the pr=
emise
>>> that netlink was asynchronous.
>>>
>>> In 2011 Patrick McHardy noticed we were being silly because netlink=
 is
>>> synchronous and removed eff_cap from the netlink_skb_params and cha=
nged
>>> the idiom to cap_raised(current_cap(), CAP_SYS_ADMIN).
>>>
>>> Looking at those spots with a fresh eye we should be calling
>>> capable(CAP_SYS_ADMIN). =A0The only reason I can see for not callin=
g
>>> capable is that it once appeared we were not in the same task as th=
e
>>> caller which would have made calling capable() impossible.
>>
>> And (just to make sure) that is now absolutely not the case?
>
> Absolutely. =A0Netlink is synchronous.
>
> I reread netlink_unicast_kernel() in net/netlink/af_netlink.c while
> researching this patch.
>
> Netlink has been synchronous since 2007. =A0In a world of perfect
> knowledge transmission these calls could have been calls to capable
> from the very beginning.
>
>>> In the initial user_namespace the only difference between =A0betwee=
n
>>> cap_raised(current_cap(), CAP_SYS_ADMIN) and capable(CAP_SYS_ADMIN)
>>> are a few sanity checks and the fact that capable(CAP_SYS_ADMIN)
>>> sets PF_SUPERPRIV if we use the capability.
>>>
>>> Since we are going to be using root privilege setting PF_SUPERPRIV
>>> seems the right thing to do.
>>>
>>> The motivation for this that patch is that in a child user namespac=
e
>>> cap_raised(current_cap(),...) tests your capabilities with respect =
to
>>> that child user namespace not capabilities in the initial user name=
space
>>> and thus will allow processes that should be unprivielged to use th=
e
>>> kernel services that are only protected with
>>> cap_raised(current_cap(),..).
>>>
>>> To fix possible user_namespace issues and to just clean up the code
>>> replace cap_raised(current_cap(), CAP_SYS_ADMIN) with
>>> capable(CAP_SYS_ADMIN).
>>>
>>> Cc: Patrick McHardy <kaber@trash.net>
>>> Cc: Philipp Reisner <philipp.reisner@linbit.com>
>>> Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
>>
>> Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>
>>
>> thanks,
>> -serge
>>
>>> Cc: Andrew Morgan <morgan@kernel.org>
>>> Cc: Vasiliy Kulikov <segoon@openwall.com>
>>> Cc: David Howells <dhowells@redhat.com>
>>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>>> ---
>>> =A0drivers/block/drbd/drbd_nl.c =A0 =A0 =A0 =A0 =A0 | =A0 =A02 +-
>>> =A0drivers/md/dm-log-userspace-transfer.c | =A0 =A02 +-
>>> =A0drivers/video/uvesafb.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0=
2 +-
>>> =A03 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd=
_nl.c
>>> index abfaaca..946166e 100644
>>> --- a/drivers/block/drbd/drbd_nl.c
>>> +++ b/drivers/block/drbd/drbd_nl.c
>>> @@ -2297,7 +2297,7 @@ static void drbd_connector_callback(struct cn=
_msg *req, struct netlink_skb_parms
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>>> =A0 =A0 =A0}
>>>
>>> - =A0 =A0if (!cap_raised(current_cap(), CAP_SYS_ADMIN)) {
>>> + =A0 =A0if (!capable(CAP_SYS_ADMIN)) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0retcode =3D ERR_PERM;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
>>> =A0 =A0 =A0}
>>> diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm=
-log-userspace-transfer.c
>>> index 1f23e04..08d9a20 100644
>>> --- a/drivers/md/dm-log-userspace-transfer.c
>>> +++ b/drivers/md/dm-log-userspace-transfer.c
>>> @@ -134,7 +134,7 @@ static void cn_ulog_callback(struct cn_msg *msg=
, struct netlink_skb_parms *nsp)
>>> =A0{
>>> =A0 =A0 =A0struct dm_ulog_request *tfr =3D (struct dm_ulog_request =
*)(msg + 1);
>>>
>>> - =A0 =A0if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
>>> + =A0 =A0if (!capable(CAP_SYS_ADMIN))
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>>>
>>> =A0 =A0 =A0spin_lock(&receiving_list_lock);
>>> diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
>>> index 260cca7..9f7d27a 100644
>>> --- a/drivers/video/uvesafb.c
>>> +++ b/drivers/video/uvesafb.c
>>> @@ -73,7 +73,7 @@ static void uvesafb_cn_callback(struct cn_msg *ms=
g, struct netlink_skb_parms *ns
>>> =A0 =A0 =A0struct uvesafb_task *utask;
>>> =A0 =A0 =A0struct uvesafb_ktask *task;
>>>
>>> - =A0 =A0if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
>>> + =A0 =A0if (!capable(CAP_SYS_ADMIN))
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>>>
>>> =A0 =A0 =A0if (msg->seq >=3D UVESAFB_TASKS_MAX)
>>> --
>>> 1.7.2.5
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
